# Guía de Configuración del Proyecto - Darkness Dungeon

Esta guía te ayudará a configurar y ejecutar el proyecto en tu computadora.

## Requisitos Previos

- **Flutter SDK** instalado y configurado
- **Git** instalado
- **Xcode** (para iOS/macOS)
- **Android Studio** (para Android)
- Cuenta de Google con acceso al proyecto Firebase `final-relic`

## Pasos de Instalación

### 1. Clonar el Repositorio

```bash
git clone [URL_DEL_REPOSITORIO]
cd final-game
```

### 2. Instalar Dependencias de Flutter

```bash
flutter pub get
```

### 3. Instalar Herramientas de Firebase

#### Firebase CLI

```bash
curl -sL https://firebase.tools | bash
```

#### FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Asegúrate de agregar el directorio al PATH (si no lo has hecho):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Agrega esta línea a tu archivo `~/.zshrc` o `~/.bashrc` para que sea permanente.

#### Para iOS: Instalar xcodeproj (solo macOS)

```bash
sudo gem install xcodeproj
```

### 4. Iniciar Sesión en Firebase

```bash
firebase login
```

Esto abrirá tu navegador para autenticarte con Google. Usa la cuenta que tiene acceso al proyecto Firebase.

### 5. Configurar Firebase en el Proyecto

#### Para iOS:

```bash
flutterfire configure --project=final-relic --platforms=ios --ios-bundle-id=com.project.darknessDungeon --yes
```

#### Para Android:

```bash
flutterfire configure --project=final-relic --platforms=android --android-package-name=com.final.relic --yes
```

#### Para ambas plataformas:

```bash
flutterfire configure --project=final-relic --platforms=ios,android --ios-bundle-id=com.project.darknessDungeon --android-package-name=com.final.relic --yes
```

Este comando generará automáticamente el archivo `lib/firebase_options.dart`.

### 6. Instalar Dependencias de iOS (solo para iOS/macOS)

```bash
cd ios
pod install
cd ..
```

### 7. Verificar la Instalación

```bash
flutter doctor -v
```

Asegúrate de que no haya errores críticos.

### 8. Ejecutar la Aplicación

#### Ver dispositivos disponibles:

```bash
flutter devices
```

#### Ejecutar en el dispositivo seleccionado:

```bash
flutter run
```

O especifica el dispositivo:

```bash
flutter run -d [DEVICE_ID]
```

## Solución de Problemas Comunes

### Error: "Firebase has not been correctly initialized"

**Solución:** Asegúrate de haber ejecutado el paso 5 correctamente. El archivo `lib/firebase_options.dart` debe existir.

### Error: "Permission denied" al instalar Firebase CLI

**Solución:** Es posible que necesites permisos de administrador. Usa `sudo` o contacta al administrador del sistema.

### Error: CocoaPods no encuentra dependencias

**Solución:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

### Error: "No Firebase projects found"

**Solución:** Asegúrate de:
1. Estar conectado a Internet
2. Haber iniciado sesión en Firebase (`firebase login`)
3. Tener acceso al proyecto `final-relic` en Firebase Console

## Acceso al Proyecto Firebase

Para que esta configuración funcione, necesitas:

1. Ser agregado como colaborador en el proyecto Firebase `final-relic`
2. Pedir al administrador del proyecto que te agregue en:
   - Firebase Console → Configuración del proyecto → Usuarios y permisos

## Notas Importantes

- **NO subas** el archivo `lib/firebase_options.dart` al repositorio Git (ya está en `.gitignore`)
- El archivo `ios/Runner/GoogleService-Info.plist` ya está incluido en el repo
- El archivo `android/app/google-services.json` ya está incluido en el repo
- Si cambias de proyecto Firebase, deberás ejecutar `flutterfire configure` nuevamente

## Comandos Útiles

### Limpiar build y dependencias:

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

### Hot reload durante desarrollo:

Presiona `r` en la terminal donde corre `flutter run`

### Hot restart:

Presiona `R` en la terminal donde corre `flutter run`

### Ver logs en tiempo real:

```bash
flutter logs
```

## Soporte

Si encuentras algún problema no cubierto en esta guía, contacta al equipo de desarrollo.
