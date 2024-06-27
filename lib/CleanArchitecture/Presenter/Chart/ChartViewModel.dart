
import 'dart:async';

class ChartViewModel {

  // Observing
  final _dataController = StreamController<ChartViewModel>.broadcast();

  @override
  Stream<ChartViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  void reloadData() {
    _dataController.add(this);
  }
}