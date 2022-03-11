import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import 'package:gig_planner_sketch/controllers/login_controller.dart';
import 'package:gig_planner_sketch/views/login.dart';
import 'package:postgres/postgres.dart';
import 'views/tags/tags_library.dart';
import 'views/views.dart';
import 'models/user_model.dart';
import 'databaseOperations.dart';

late PostgreSQLConnection connection;

Future<void> main() async {
  ConnectionParameters connectionParameters = ConnectionParameters("10.0.2.2", 5432, "gigplanner", "postgres", "password");
  connection = await connectToDatabase(connectionParameters);
  LoginController con = LoginController(connection);

  runApp(MaterialApp(
    title: 'Gig-planner',
    home: LoginView(logCtl: con),
  ));
}

class MyApp extends StatelessWidget {
  final UserModel usr;
  const MyApp({required this.usr, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller ctl = Controller(usr);
    List<String> fields = [
      "All Events",
      "Song Library",
      "Set Library",
      "Tags",
      "Transitions",
      "Authors"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gig-planner"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(fields[0]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventLibrary(ctl: ctl),
                )
              );
            }
          ),
          const Divider(),
          ListTile(
              title: Text(fields[1]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongLibrary(ctl: ctl),
                    ));
              }),
          const Divider(),
          ListTile(
              title: Text(fields[2]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SetLibrary(ctl: ctl),
                    ));
              }),
          const Divider(),
          ListTile(
            title: Text(fields[3]),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(
                builder: (_) => Tags(ctl: ctl),
              )
              );
            }
          ),
          const Divider(),
          ListTile(
            title: Text(fields[4]),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (_) => Transitions(ctl: ctl))
              );
            }
          ),
          // const Divider(),
          // ListTile(
          //   title: Text(fields[5]),
          //     onTap: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (_) => LoginView(logCtl: LoginController(),))
          //       );
          //     }
          // ),
          const Divider(),
          ListTile(
            title: Text(fields[5]),
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => AuthorsLibrary(ctl: ctl))
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

// From RayWenderlich
//  : 1. - 3 Basic Widgets and making your basic widgets after
//  : 2. - 5 Scrollable Widgets and making few Lists out of your basic widgets
//  TODO: 3. - 6 Interactive Widgets and making your Interactive Widgets
//   4. - 7 Routes and Navigation. And making your own navigation
//  TODO: 5. - 13 States Management
//  TODO: 6. - 15 Saving data with SQLite
