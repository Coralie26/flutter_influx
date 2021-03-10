import 'package:requests/requests.dart';

_buildUri(bool ssl, String host) {
  return (String unencodedPath, [Map<String, dynamic>? queryParameters]) {
    return (ssl) ? Uri.https(host, unencodedPath, queryParameters).toString() : Uri.http(host, unencodedPath, queryParameters).toString();
  };
}

class InfluxRequests {
  final String host;
  int port;
  final bool ssl;
  final _uriBuilder;

  InfluxRequests({
    required this.host,
    required this.ssl,
    this.port = 0
  }) : _uriBuilder = _buildUri(ssl, '$host${port != 0 ? ':$port' : ''}');

  get(
    String route,
    {
       Map<String, String>? headers,
       Map<String, dynamic>? queryParameters
    }
  ) async {
    print(_uriBuilder(route, queryParameters));
    return await Requests.get(
      _uriBuilder(route, queryParameters),
      headers: headers
    );
  }

  post(
    String route,
    {
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      dynamic? body,
    }
  ) async {
    print(_uriBuilder(route, queryParameters));
    return await Requests.post(
      _uriBuilder(route, queryParameters),
      headers: headers,
      body: body
    );
  }
}