

import 'dart:async';

class SearchViewModel {

  // Observing
  final _dataController = StreamController<SearchViewModel>.broadcast();

  @override
  Stream<SearchViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  void reloadData() {
    _dataController.add(this);
  }
}