import 'package:mysql1/mysql1.dart';

class DataBase {
  MySqlConnection _connection;

  DataBase() {
    connect();
  } 

  connect() async {
    _connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        db: 'mobilki2019test',
        user: 'temmie',
        password: "temmievillage"
      )
    );
  }

  close() {
    _connection.close();
  }
}


  dbTest() async {    
    final connection = await MySqlConnection.connect(ConnectionSettings(
        host: 'db4free.net', port: 3306, user: 'temmie', db: 'mobilki2019test', password: "temmievillage"));
    
    print("xd");
    var result = await connection.query("SELECT a, b, c, d FROM test");
    for (var row in result) {
      print('A: ${row[0]}, B: ${row[1]}, C: ${row[2]}, D: ${row[3]}');
    }
    connection.close();
  }