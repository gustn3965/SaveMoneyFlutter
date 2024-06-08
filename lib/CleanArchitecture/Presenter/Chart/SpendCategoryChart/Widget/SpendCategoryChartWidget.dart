import 'package:flutter/cupertino.dart';
import '../ViewModel/SpendCategoryChartViewModel.dart';

class SpendCategoryChartWidget extends StatelessWidget {
  final SpendCategoryChartViewModel viewModel;

  SpendCategoryChartWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<SpendCategoryChartViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Text("SpendCategoryChartViewModel");
      },
    );
  }
}
