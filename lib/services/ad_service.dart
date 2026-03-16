import 'dart:io';
import 'package:darkness_dungeon/util/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // Banner: IDs de PRUEBA temporalmente (hasta que Google apruebe la cuenta)
  // IMPORTANTE: Cuando recibas el email "Your AdMob account is now live",
  // cambia estos IDs por tus IDs reales: ca-app-pub-6728821178954086/6345505390
  static const String _androidBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  // Intersticial: IDs de prueba (crear unidad en AdMob para tener IDs reales)
  static const String _androidInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';

  // Rewarded: IDs de prueba (crear unidad en AdMob para tener IDs reales)
  static const String _androidRewardedId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _iosRewardedId = 'ca-app-pub-3940256099942544/1712485313';

  // Getters para los IDs según la plataforma
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _androidBannerId;
    } else if (Platform.isIOS) {
      return _iosBannerId;
    }
    throw UnsupportedError('Plataforma no soportada para anuncios');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidInterstitialId;
    } else if (Platform.isIOS) {
      return _iosInterstitialId;
    }
    throw UnsupportedError('Plataforma no soportada para anuncios');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _androidRewardedId;
    } else if (Platform.isIOS) {
      return _iosRewardedId;
    }
    throw UnsupportedError('Plataforma no soportada para anuncios');
  }

  // Inicializar AdMob
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    GameLogger.success('AdMob inicializado correctamente');
  }

  // ========== BANNER AD ==========
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  /// Notificador para cambios en el estado de carga del banner
  /// Permite a los widgets escuchar cambios sin usar polling
  final ValueNotifier<bool> bannerLoadedNotifier = ValueNotifier<bool>(false);

  bool get isBannerLoaded => _isBannerLoaded;
  BannerAd? get bannerAd => _bannerAd;

  void loadBannerAd() {
    disposeBannerAd(); // Limpiar banner anterior si existe
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          GameLogger.success('Banner ad cargado');
          _isBannerLoaded = true;
          bannerLoadedNotifier.value = true; // Notificar a escuchadores
        },
        onAdFailedToLoad: (ad, error) {
          GameLogger.error('Error al cargar banner', error);
          ad.dispose();
          _isBannerLoaded = false;
          bannerLoadedNotifier.value = false;
        },
      ),
    );
    _bannerAd!.load();
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerLoaded = false;
    bannerLoadedNotifier.value = false;
  }

  // ========== INTERSTITIAL AD ==========
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoaded = false;
  int _interstitialFailCount = 0;

  bool get isInterstitialLoaded => _isInterstitialLoaded;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('✅ Anuncio intersticial cargado');
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
          _interstitialFailCount = 0;

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('ℹ️ Anuncio intersticial cerrado');
              ad.dispose();
              _isInterstitialLoaded = false;
              loadInterstitialAd(); // Cargar el siguiente
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('❌ Error al mostrar intersticial: $error');
              ad.dispose();
              _isInterstitialLoaded = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('❌ Error al cargar intersticial: $error');
          _isInterstitialLoaded = false;
          _interstitialFailCount++;

          // Reintentar con backoff exponencial (máximo 3 reintentos)
          if (_interstitialFailCount < 3) {
            Future.delayed(Duration(seconds: _interstitialFailCount * 2), () {
              loadInterstitialAd();
            });
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('⚠️ El anuncio intersticial no está cargado');
      loadInterstitialAd();
    }
  }

  // ========== REWARDED AD ==========
  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;
  int _rewardedFailCount = 0;

  bool get isRewardedLoaded => _isRewardedLoaded;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print('✅ Anuncio con recompensa cargado');
          _rewardedAd = ad;
          _isRewardedLoaded = true;
          _rewardedFailCount = 0;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('ℹ️ Anuncio con recompensa cerrado');
              ad.dispose();
              _isRewardedLoaded = false;
              loadRewardedAd(); // Cargar el siguiente
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('❌ Error al mostrar anuncio con recompensa: $error');
              ad.dispose();
              _isRewardedLoaded = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('❌ Error al cargar anuncio con recompensa: $error');
          _isRewardedLoaded = false;
          _rewardedFailCount++;

          // Reintentar con backoff exponencial (máximo 3 reintentos)
          if (_rewardedFailCount < 3) {
            Future.delayed(Duration(seconds: _rewardedFailCount * 2), () {
              loadRewardedAd();
            });
          }
        },
      ),
    );
  }

  void showRewardedAd({required Function(int amount) onRewardEarned}) {
    if (_isRewardedLoaded && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('🎁 Recompensa ganada: ${reward.amount} ${reward.type}');
          onRewardEarned(reward.amount.toInt());
        },
      );
    } else {
      print('⚠️ El anuncio con recompensa no está cargado');
      loadRewardedAd();
    }
  }

  // ========== LIMPIEZA ==========
  void dispose() {
    disposeBannerAd();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
