import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import '../models/playlist_model.dart';
import 'song_library/song.dart';
import 'set_library/set.dart';

class Playlist extends StatefulWidget {
  final Controller ctl;
  final String eventId;
  final PlaylistModel? playlist;
  const Playlist({required this.ctl, required this.eventId, Key? key}) : super(key: key){
    playlist = ctl.getEventsPlaylist(eventId);
  }

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
