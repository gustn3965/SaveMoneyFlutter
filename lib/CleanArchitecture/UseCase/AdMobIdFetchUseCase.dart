
import 'dart:io';

abstract class AdMobIdFetchUseCase {

  String? fetchBottomBannerId();
}

class TestAdMobIdFetchUseCase extends AdMobIdFetchUseCase {
  @override
  String? fetchBottomBannerId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      return null;
    }
  }
}


class RealAdMobIdFetchUseCase extends AdMobIdFetchUseCase {
  @override
  String? fetchBottomBannerId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-2806661632110879/6103108724";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2806661632110879/7804586093";
    } else {
      return null;
    }
  }
}