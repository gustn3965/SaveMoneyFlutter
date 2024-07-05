import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/AdMob/ViewModel/AdMobBannerViewModel.dart';

import '../../../../../AppColor/AppColors.dart';

class AdMobBannerWidget extends StatelessWidget {
  final AdMobBannerViewModel viewModel;

  AdMobBannerWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AdMobBannerViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          if (viewModel.bannerAd != null && viewModel.shouldShowBanner == true) {
            return Container(
              height: 70,
                child: AdWidget(ad: viewModel.bannerAd!));
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
