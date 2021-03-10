library flutter_influx;

import 'dart:convert';

import 'package:flutter_influx/Utils/Requests.dart';
import 'package:flutter_influx/Utils/Types.dart';
import 'package:requests/requests.dart';

class InfluxDBClient {
  final String host;
  final String user;
  final String password;
  final int port;
  final String ?database;
  final int timeout;
  final bool ssl;
  final InfluxRequests _requests;
  final Map<String, String> ?headers;
  final Map<String, String> _defaultQueryParameters;

  InfluxDBClient({
    required this.host,
    this.user = 'root',
    this.password = 'root',
    this.database,
    this.port = 8086,
    this.timeout = 3,
    this.ssl = false,
    this.headers
  }) :
    _requests = InfluxRequests(host: host, port: port, ssl: ssl),
    _defaultQueryParameters = {'u': user, 'p': password}
  {
    if (this.database != null)
      _defaultQueryParameters[this.database!] = this.database!;
  }

  select({
    required String select,
    required String from,
    String ?where,
    String options = '',
  }) async {
    final response = await _requests.get(
      'query',
      queryParameters: _defaultQueryParameters..addAll({
        'q': 'SELECT $select FROM $from ${where != null ? 'WHERE $where' : '' } $options',
      })
    );

    if (response.hasError)
      throw(response.content());

    return QueryResponse(json: jsonDecode(response.content()));
  }

  query({
    required String query
  }) async => (
    await _requests.get(
        'query',
        queryParameters: {
          'u': user,
          'p': password,
          'db': database,
          'q': query,
        }
    )
  );
}
