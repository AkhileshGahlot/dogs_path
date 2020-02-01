
import 'package:dogs_path/model/paths.dart';
import 'package:dogs_path/services/paths_api_call.dart';

class PathRepository {
  PathApiProvider _playerApiProvider = PathApiProvider();

  Future<List<Path>> fetchPaths() =>
      _playerApiProvider.fetchPaths();

}