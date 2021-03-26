# flutter_influx

Flutter influx package, query influx databases.

## Getting Started

A complete documentation can be found in `doc/api`

## Next steps
Every query keyword should have their own function but that's too much for now.

## Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_influx/Utils/Types.dart';
import 'package:flutter_influx/flutter_influx.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Influx Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Influx Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final InfluxDBClient client = InfluxDBClient(host: "localhost", user: "admin", password: "admin", database: "sensors");
  QueryResponse response;

  @override
  void initState() {
    fetch() async {
      try {
        final r = await client.select(
          select: "value",
          from: "T",
          where: "UID='4e004f'",
          options: "GROUP BY UID,SENSOR ORDER BY DESC LIMIT 1"
        );
        setState(() {
          response = r;
        });
      } catch (e) {
        print(e);
      }
    }

    fetch();

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        title: Text("Influx"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Text(response != null ? response/*.results[0].valuesOf('value', includeTags: true)*/.toString() : 'null')
      )
    );
  }
}
```

## Functions

### `query` Execute any query on your influx database
Returns a `Future<Response>`

```dart
await client.query("SELECT value FROM T WHERE UID='4e004f' GROUP BY UID,SENSOR ORDER BY DESC LIMIT 1");
```

### `select` Execute a "SELECT" query on your influx database
Returns a `Future<QueryResponse>`  
  
```dart
await client.select(
  select: "value",
  from: "T",
  where: "UID='4e004f'",
  options: "GROUP BY UID,SENSOR ORDER BY DESC LIMIT 1"
);
```
