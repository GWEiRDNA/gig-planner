import 'package:flutter/material.dart';
import '../../controllers/controller.dart';

class AuthorsLibrary extends StatefulWidget {
  final Controller ctl;
  const AuthorsLibrary({required this.ctl, Key? key}) : super(key: key);

  @override
  _AuthorsLibraryState createState() => _AuthorsLibraryState();
}

class _AuthorsLibraryState extends State<AuthorsLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your authors"),
        ),
        body: ListView.builder(
          itemCount: 10 + 1,
          itemBuilder: (context, i) {
            if(i==0){
              return ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Add new author",
                  ),
                ),
                trailing: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
              );
            }
            return ListTile(
              title: Text("Hello"),
              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
            );
          },
        ));
  }
}
