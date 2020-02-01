
import 'dart:async';

import 'package:dogs_path/model/paths.dart';
//import 'package:rxdart/rxdart.dart';
import 'package:dogs_path/services/repository.dart';

abstract class BlocStream {

  void dispose();

}

class PathListingBloc extends BlocStream {

  bool _isDisposed = false;

  final _repository  = PathRepository();

  final StreamController<List<Path>>  _streamController =StreamController<List<Path>>() ;

  Stream<List<Path>> get  pathListStream=> _streamController.stream;

  StreamSink<List<Path>> get  pathListSink=> _streamController.sink;

  fetchPaths() async {
    if(_isDisposed) {
      print('UserBloc dispose() is already called');
      return;
    }

    try{

    List<Path> itemModel = await _repository.fetchPaths();

    if(!_isDisposed)pathListSink.add(itemModel);

  }catch(error){
      pathListSink.addError(error);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    _isDisposed = true;

  }
}