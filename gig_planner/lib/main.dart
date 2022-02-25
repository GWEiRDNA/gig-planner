import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import 'views/tags/tags.dart';
import 'views/views.dart';
import 'models/user_model.dart';
import 'models/models.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Gig-planner',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel usr = UserModel.mock();
    Controller ctl = Controller(usr);
    List<String> fields = [
      "All Events",
      "Song Library",
      "Set Library",
      "Tags",
      "Transitions",
      "Settings",
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
              List<String> ids = ctl.getAvailableEventsIds();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventLibrary(eventIds: ids),
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
                      builder: (_) => const SongLibrary(),
                    ));
              }),
          const Divider(),
          ListTile(
              title: Text(fields[2]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SetLibrary(),
                    ));
              }),
          const Divider(),
          ListTile(
            title: Text(fields[3]),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(
                builder: (_) => Tags(),
              )
              );
            }
          ),
          const Divider(),
          ListTile(
            title: Text(fields[4]),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (_) => Transitions())
              );
            }
          ),
          const Divider(),
          ListTile(
            title: Text(fields[5]),
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
//  TODO: 4. - 7 Routes and Navigation. And making your own navigation
//  TODO: 5. - 13 States Management
//  TODO: 6. - 15 Saving data with SQLite
