import 'package:crypt/crypt.dart';
import 'package:gig_planner_sketch/queries/myQueriesList.dart';
import 'package:postgres/postgres.dart';
import 'models/user_model.dart';

class ConnectionParameters
{
  String hostname;
  int port;
  String database;
  String username;
  String password;
  ConnectionParameters(this.hostname, this.port, this.database, this.username, this.password);
}

Future<PostgreSQLConnection> connectToDatabase(ConnectionParameters params) async
{
  PostgreSQLConnection connection = PostgreSQLConnection(params.hostname, params.port, params.database, username: params.username, password: params.password);
  await connection.open();
  return connection;
}

Future<UserModel> loginUser(PostgreSQLConnection connection, String email, String password) async {
  final String passwordHash = Crypt.sha256(password, salt: 'v9SferVS2DklThF0').toString();
  List<Map<String, Map<String, dynamic>>> results = await executeQuery(connection, loginQuery, {'@email': email, '@passwordHash': passwordHash});
  if(results.isNotEmpty) {
    return UserModel(results[0]['users']!['id'], results[0]['users']!['email'], results[0]['users']!['name'], connection);
  }
  return UserModel(-1, "", "", connection, "Wrong email or password.");
}

Future<UserModel> registerUser(PostgreSQLConnection connection, String email, String password, String name) async {
  final String passwordHash = Crypt.sha256(password, salt: 'v9SferVS2DklThF0').toString();
  try {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(connection, registerQuery, {'@email': email, '@passwordHash': passwordHash, '@name': name});
    if(results.isEmpty) {return UserModel(-1, "", "", connection, "Cannot create user, unknown error.");}
  } on Exception catch(e)
  {
    if(e.toString().contains("email_check")) return UserModel(-1, "", "", connection, "Wrong email address.");
    if(e.toString().contains("users_email_key")) return UserModel(-1, "", "", connection, "There is already account with that email.");
    if(e.toString().contains("name_length_check")) return UserModel(-1, "", "", connection, "Nick too short. (At least 3 characters)");
    if(e.toString().contains("name_key")) return UserModel(-1, "", "", connection, "There is already account with that nick.");
    if(e.toString().contains("password_empty_check")) return UserModel(-1, "", "", connection, "Password cannot be empty.");
    print(e.toString());
    return UserModel(-1, "", "", connection, "Cannot create user, unknown error.");
  }

  List<Map<String, Map<String, dynamic>>> results = await executeQuery(connection, loginQuery, {'@email': email, '@passwordHash': passwordHash});
  if(results.isNotEmpty) {
    return UserModel(results[0]['users']!['id'], results[0]['users']!['email'], results[0]['users']!['name'], connection);
  }
  return UserModel(-1, "", "", connection, "Cannot login to account, unknown error.");
}

Future<List<Map<String, Map<String, dynamic>>>> executeQuery(var connection, String query, Map<String, dynamic> queryArgs) async
{
  for (final queryArgsName in queryArgs.keys) {
    if(queryArgs[queryArgsName] == null) {
      query = query.replaceAll(queryArgsName, "null");
    }
    else {
      query = query.replaceAll(queryArgsName, "'" + queryArgs[queryArgsName].toString() + "'");
    }
  }
  print(query);
  return connection.mappedResultsQuery(query);
}
