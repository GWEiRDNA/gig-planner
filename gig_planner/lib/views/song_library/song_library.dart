import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';
import 'package:gig_planner_sketch/views/song_library/song_form.dart';
import '../../controllers/controller.dart';
import 'song.dart';

class SongLibrary extends StatefulWidget {
  final Controller ctl;
  List<SongModel> songs;
  SongLibrary({required Controller this.ctl, Key? key})
      : songs = ctl.user.songs,
        super(key: key);

  @override
  State<SongLibrary> createState() => _SongLibraryState();
}

class _SongLibraryState extends State<SongLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text("Song Library"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
          itemCount: widget.ctl.user.songs.length,
          itemBuilder: (context, i) {
            return Song(ctl: widget.ctl, song: widget.ctl.user.songs[i]);
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(context,
          MaterialPageRoute(
              builder: (_) => SongForm.new(ctl: widget.ctl)
            )
          );
        },
        ),
      );
  }
}
