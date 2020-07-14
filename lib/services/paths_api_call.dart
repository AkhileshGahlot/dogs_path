import 'package:dogs_path/model/paths.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PathApiProvider {

  final String baseUrl = "https://5d55541936ad770014ccdf2d.mockapi.io/api/v1/paths";
 

  Future<List<Path>> fetchPaths() async {
    final response = await http.get(baseUrl);

    final int statusCode=response.statusCode;

    if(statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data $statusCode");
    }

    return Path.convertJsonArray(json.decode(response.body));
  }




}