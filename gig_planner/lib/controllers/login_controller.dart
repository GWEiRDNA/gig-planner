import 'package:gig_planner_sketch/models/user_model.dart';
import 'package:postgres/postgres.dart';

import '../databaseOperations.dart';

class LoginController{
  late PostgreSQLConnection connection;

  LoginController(this.connection);

  Future<UserModel?> login(String eMail, String password) async {
    return await loginUser(connection, eMail, password);
  }

  Future<UserModel?> register(String nick, String eMail, String password) async {
    return await registerUser(connection, eMail, password, nick);
  }
}