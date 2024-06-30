import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
// Widget
import 'AppColor/AppColors.dart';
import 'CleanArchitecture/Presenter/AppCoordinator.dart';


AppCoordinator appCoordinator = AppCoordinator(null, null);
AppDIContainer appDIContainer = AppDIContainer(appStatus: AppStatus.cbt); // main에서 다시 초기화

void main() async {
  print(">>>>>>>>>start main>>>>>>>>>>>>");



  WidgetsFlutterBinding.ensureInitialized()
  .addObserver(appCoordinator);
  appCoordinator.runcheScreen();

  AppStatus appStatus = await getAppStatusFromChannel();
  appDIContainer = AppDIContainer(appStatus: appStatus);

  await appDIContainer.repository.databaseController?.initializeAsync();

  appCoordinator.start();

  print("<<<<<<<<<<<<start main<<<<<<<<<<<<");
}

Future<AppStatus> getAppStatusFromChannel() async {
  String flavor = await const MethodChannel('flavor')
      .invokeMethod<String>('getFlavor') ?? "";

  print("🟠🟠GET FLAVOR: ${flavor}🟠🟠");

  if (flavor == "cbt") {
    return AppStatus.cbt;
  } else if (flavor == "mock") {
    return AppStatus.mock;
  } else if (flavor == "real") {
    return AppStatus.real;
  } else {
    return AppStatus.mock;
  }
}