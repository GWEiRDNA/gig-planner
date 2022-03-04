import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import 'package:gig_planner_sketch/views/set_library/select_set.dart';
import 'package:gig_planner_sketch/views/song_library/select_song.dart';
import 'package:postgres/postgres.dart';
import 'views/tags/tags_library.dart';
import 'views/views.dart';
import 'models/user_model.dart';
import 'models/models.dart';
import 'databaseOperations.dart';
import 'queries/myQueriesList.dart';

late PostgreSQLConnection connection;
late UserModel usr;

Future<void> main() async {
  //connect to database
  ConnectionParameters connectionParameters = ConnectionParameters("10.0.2.2", 5432, "baza2", "postgres", "root");
  connection = await connectToDatabase(connectionParameters);

  //user login
  String email = "jcasetti0@delicious.com";
  String passwordHash = "c352854ecf97cebf8d21f0f9da99ea89ea56e8a11c2945d85d58ce5d1d08e9a1"; //TODO add hashing function
  List<Map<String, Map<String, dynamic>>> results = await executeQuery(connection, loginQuery, {'@email': email, '@passwordHash': passwordHash});
  //get results
  if(results.length > 0) {
    usr = UserModel(results[0]['users']!['id'], results[0]['users']!['email'], results[0]['users']!['name'], connection);
  } else {
    return;
  }
  runApp(const MaterialApp(
    title: 'Gig-planner',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Controller ctl = Controller(usr);
    List<String> fields = [
      "All Events",
      "Song Library",
      "Set Library",
      "Tags",
      "Transitions",
      "Settings",
      "Authors"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gig-planner"),
      ),
      body: Column(
        children: [
          // const Divider(),
          // ListTile(
          //     title: Text('execute myquery'),
          //     onTap: () async {
          //
          //       //execute query
          //       int idmax = 30; //query argument nr 1
          //       String name = 'user A'; //query argument nr 2
          //       List<Map<String, Map<String, dynamic>>> results = await executeQuery(connection, myquery, {'@idmax': idmax, '@name': name});
          //
          //       //get results
          //       print('results : ' + results.length.toString()); //row count
          //       for (final row in results) {
          //         print(row);
          //         print(row['users']!['id'].toString() + ' : ' + row['users']!['name']); //extract values from row
          //       }
          //     }
          // ),
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
          const Divider(),
          ListTile(
            title: Text(fields[5]),
          ),
          const Divider(),
          ListTile(
            title: Text(fields[6]),
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => AuthorsLibrary(ctl: ctl))
              );
            },
          ),
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
