import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
// Widget
import 'CleanArchitecture/Presenter/AppCoordinator.dart';


AppCoordinator appCoordinator = AppCoordinator(null, null);
AppDIContainer appDIContainer = AppDIContainer(appStatus: AppStatus.db);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String flavor = await const MethodChannel('flavor')
      .invokeMethod<String>('getFlavor') ?? "";

  print("🟠🟠GET FLAVOR: ${flavor}🟠🟠");

  await appDIContainer.repository.databaseController?.initializeAsync();
  appCoordinator.start();
}
