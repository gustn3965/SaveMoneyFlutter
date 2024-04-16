import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/ViewModel/SettingsViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/Widget/SettingsWidget.dart';

class SettingsDIContainer {
  AppStatus appStatus;

  SettingsDIContainer(this.appStatus);

  SettingsViewModel makeSettingsViewModel(SettingsAction action) {
    return DefaultSettingsViewModel(action);
  }

  Widget makeSettingsWidget(SettingsViewModel viewModel) {
    return SettingsWidget(viewModel);
  }
}
