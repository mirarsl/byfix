import 'package:http/http.dart' as http;

class Network {
  final String url;
  final String parameters;
  final String _token = "0ioqGg3WntkzQf5Qap7qgF:3PLaF0g3mtsBtXWfZGE4FK";

  Network({required this.url, this.parameters = ""});

  Future<dynamic> getData() async {
    var uri = Uri.parse(
        'https://api.byfixstore.com/$url?api_token=$_token&$parameters');
    var response = await http.get(uri, headers: {});
    return response.body;
  }

  Future<dynamic> postData() async {
    var uri = Uri.parse(
        'https://api.byfixstore.com/$url?api_token=$_token&$parameters');
    var response = await http.post(uri, headers: {});
    return response.body;
  }
}
