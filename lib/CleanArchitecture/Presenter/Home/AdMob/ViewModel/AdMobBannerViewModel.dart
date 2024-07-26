
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AdMobIdFetchUseCase.dart';
class AdMobBannerViewModelAction {
  void Function(bool) didLoadedAdMob;

  AdMobBannerViewModelAction(this.didLoadedAdMob);
}

class AdMobBannerViewModel {
  AdMobBannerViewModelAction action;
  String? bannerId;
  bool shouldShowBanner = false;

  BannerAd? bannerAd;

  AdMobIdFetchUseCase adMobIdFetchUseCase;

  AdMobBannerViewModel(this.action, this.adMobIdFetchUseCase) {
    fetchBannerAd();
  }

  // Observing
  final _dataController = StreamController<AdMobBannerViewModel>.broadcast();

  @override
  Stream<AdMobBannerViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  void reloadData() {
    _dataController.add(this);
  }


  void fetchBannerAd() async {
    await Future.delayed(const Duration(milliseconds: 100));
    bannerId = adMobIdFetchUseCase.fetchBottomBannerId();

    if (bannerId != null) {
      BannerAdListener listener = BannerAdListener(onAdLoaded: (ad) {
        debugPrint('📢Ad Loaded');
        shouldShowBanner = true;
        action.didLoadedAdMob(true);
        _dataController.add(this);
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        shouldShowBanner = false;
        action.didLoadedAdMob(false);
        _dataController.add(this);
        debugPrint('📢Ad fail to load: $error');
      },
      onAdOpened: (ad) {
        debugPrint('📢Ad Opened');
      },
      onAdClosed: (ad) {
        debugPrint('📢Ad closed');
      });

      bannerAd = BannerAd(size: AdSize.fullBanner, adUnitId: bannerId!, listener: listener, request: AdRequest())..load();
    } else {
      bannerAd = null;
      _dataController.add(this);
    }
  }
}