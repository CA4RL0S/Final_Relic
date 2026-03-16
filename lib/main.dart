import 'package:darkness_dungeon/menu.dart';
import 'package:darkness_dungeon/screens/login_screen.dart';
import 'package:darkness_dungeon/screens/tutorial_screen.dart';
import 'package:darkness_dungeon/util/localization/my_localizations_delegate.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:darkness_dungeon/util/logger.dart';
import 'package:darkness_dungeon/services/ad_service.dart';
import 'package:darkness_dungeon/services/auth_service.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// La constante tileSize ahora está en constants/game_constants.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar AdMob
  await AdService().initialize();

  // Pre-cargar anuncios
  AdService().loadInterstitialAd();
  AdService().loadRewardedAd();

  // Inicializar sonidos (AudioPools)
  await Sounds.initialize();

  // Pre-cargar inventario para evitar lag al abrir UI
  await PlayerInventory().loadInventory();

  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  // Prueba
  MyLocalizationsDelegate myLocation = const MyLocalizationsDelegate();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Normal',
      ),
      home: const AuthGate(),
      routes: {
        '/menu': (context) => Menu(),
        '/login': (context) => const LoginScreen(),
        '/tutorial': (context) => const TutorialScreen(),
      },
      // Forzar español en toda la aplicación (Android & iOS)
      locale: const Locale('es', 'ES'),
      supportedLocales: [const Locale('es', 'ES')], // Solo español
      localizationsDelegates: [
        myLocation,
        DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Siempre devolver español, sin importar el idioma del dispositivo
        GameLogger.info('Forzando idioma a español');
        return const Locale('es', 'ES');
      },
    ),
  );
}

/// Widget que controla el flujo de autenticación:
/// 1. Sin usuario → LoginScreen
/// 2. Usuario autenticado + necesita tutorial → TutorialScreen
/// 3. Usuario autenticado + tutorial completado → Menu
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Mientras carga, mostrar splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0F0F1A),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFC107),
              ),
            ),
          );
        }

        // No autenticado → Login
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        // Autenticado → Cargar inventario y decidir si mostrar tutorial
        return FutureBuilder(
          future: PlayerInventory().loadInventory(),
          builder: (context, inventorySnapshot) {
            if (inventorySnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFF0F0F1A),
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFC107),
                  ),
                ),
              );
            }

            // ¿Necesita tutorial?
            if (PlayerInventory().needsTutorial) {
              return const TutorialScreen();
            }

            // Todo listo → Menú principal
            return Menu();
          },
        );
      },
    );
  }
}
