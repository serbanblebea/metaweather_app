import 'dart:convert';
import 'package:http/http.dart';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future<dynamic> getData() async {
    final Response response = await get(url);

    if (response.statusCode == 200) {
      final dynamic data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
