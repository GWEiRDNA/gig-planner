import 'package:flutter/material.dart';
import 'song_library/song.dart';
import 'set_library/set.dart';

class Playlist extends StatefulWidget {

  const Playlist({Key? key}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event nr 2"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          if(i==2) {
            return const Set();
          }
          return const Song();
        },
      ),
    );
  }
}
