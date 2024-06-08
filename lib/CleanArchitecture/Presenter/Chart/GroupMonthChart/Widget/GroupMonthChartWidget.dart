import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';

class GroupMonthChartWidget extends StatelessWidget {
  final GroupMonthChartViewModel viewModel;

  GroupMonthChartWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<GroupMonthChartViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Text("GroupMonthChart");
      },
    );
  }
}
