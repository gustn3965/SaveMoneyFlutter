
import 'dart:async';

class HomeViewModel {

  // Observing
  final _dataController = StreamController<HomeViewModel>.broadcast();

  @override
  Stream<HomeViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  void reloadData() {
    _dataController.add(this);
  }
}