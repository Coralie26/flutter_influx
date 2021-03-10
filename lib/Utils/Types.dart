class QueryResponse {
  final List<QueryResult> results;

  QueryResponse({ required Map<String, dynamic> json }) :
    results = (json['results'] is List) ? json['results'].map<QueryResult>((element) => QueryResult(json: element)).toList() : [QueryResult(json: json)]
  ;

  @override
  String toString() {
    return '<QueryResponse $results>';
  }
}

class QueryResult {
  final List<QueryStatementElement> elements;

  QueryResult({ required Map<String, dynamic> json }) :
    elements = (json['series'] is List) ? json['series'].map<QueryStatementElement>((element) => QueryStatementElement(json: element)).toList() : [QueryStatementElement(json: json)]
  ;

  List<dynamic> valuesOf(String columnName, { bool includeTags = false }) {
    return elements.map((element) => element.valuesOf(columnName, includeTags: includeTags)).toList();
  }

  @override
  String toString() {
    return '<QueryResults $elements>';
  }
}

class QueryStatementElement {
  final String name;
  final Map<String, dynamic> tags;
  final List<dynamic> columns;
  final List<dynamic> values;

  QueryStatementElement({ required Map<String, dynamic> json}) :
    name = json['name'],
    tags = json['tags'],
    columns = json['columns'],
    values = json['values']
  ;

  valuesOf(String columnName, { bool includeTags = false }) {
    if (includeTags)
      return { 'tags': tags, 'values': values.map((element) => element[columns.indexOf(columnName)]).toList() };
    return values.map((element) => element[columns.indexOf(columnName)]).toList();
  }

  @override
  String toString() {
    return '{ name : $name, tags : $tags, columns : $columns, values : $values }';
  }
}