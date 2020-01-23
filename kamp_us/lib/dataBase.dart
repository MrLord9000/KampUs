import 'package:mysql1/mysql1.dart';

class DataBase {
  static DataBase _instance = new DataBase._init();

  static final settings =  ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        db: 'mobilki2019test',
        user: 'temmie',
        password: "temmievillage"
  );

  Future<MySqlConnection> _connection;

  factory DataBase() {
    return _instance;
  }

  DataBase._init() {
    _connection = MySqlConnection.connect(settings);
  } 

  close() {
    _connection.then( (con) => con.close() );
  }

  Future<Results> querry( String sql, List args ) async {
    return _connection.then( (con) => con.query(sql,args) );
  }
}