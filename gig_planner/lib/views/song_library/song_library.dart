import 'package:flutter/material.dart';
import 'song.dart';

class SongLibrary extends StatelessWidget {
  const SongLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song Library"),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(children: const [Song(), Song()]),
    );
  }
}