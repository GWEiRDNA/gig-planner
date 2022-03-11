import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/login_controller.dart';
import 'package:gig_planner_sketch/models/user_model.dart';

import '../main.dart';

class LoginView extends StatefulWidget {
  final LoginController logCtl;
  const LoginView({required this.logCtl, Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String nick = "";
  String eMail = "";
  String password = "";

  showLoginDialog(String text){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10)
            ),
            color: Color.fromRGBO(118, 164, 179, 1.0),
          ),
          child: Column(
            children: [
              TextFormField(
                initialValue: nick,
                decoration: const InputDecoration(
                  hintText: "Nick",
                ),
                onChanged: (text){
                  nick = text;
                },
              ),
              TextFormField(
                initialValue: eMail,
                decoration: const InputDecoration(
                  hintText: "E-mail",
                ),
                onChanged: (text){
                  eMail = text;
                },
              ),
              TextFormField(
                initialValue: password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
                onChanged: (text){
                  password = text;
                },
              ),
              ElevatedButton(onPressed: () async {
                UserModel user = await widget.logCtl.login(eMail, password);
                if( user.errorMsg == null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyApp(usr: user))
                  );
                }else{
                  showLoginDialog(user.errorMsg!);
                }
              }, child: const Text("Login")),
              ElevatedButton(onPressed: () async {
                UserModel user = await widget.logCtl.register(nick, eMail, password);
                if( user.errorMsg == null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyApp(usr: user))
                  );
                }else{
                  showLoginDialog(user.errorMsg!);
                }
              }, child: const Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
