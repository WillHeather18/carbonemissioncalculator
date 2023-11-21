import 'package:mysql1/mysql1.dart';

class DatabaseService {
  late MySqlConnection conn;

  Future<void> openConnection() async {
    var settings = ConnectionSettings(
      host: '192.168.1.188',
      port: 3306,
      user: 'root',
      password: 'B0bsnowy66!will',
      db: 'cec',
    );
    conn = await MySqlConnection.connect(settings);
  }

  Future<void> closeConnection() async {
    await conn.close();
  }

  Future<Results> executeQuery(String query) async {
    var results = await conn.query(query);
    await Future.delayed(Duration(seconds: 2));
    return results;
  }
}
