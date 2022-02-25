import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import 'package:gig_planner_sketch/models/models.dart';
import '../models/playlist_model.dart';
import 'song_library/song.dart';
import 'set_library/set.dart';

class Playlist extends StatefulWidget {
  final Controller ctl;
  final String eventId;
  PlaylistModel? playlist;
  Playlist({required this.ctl, required this.eventId, Key? key}) : super(key: key){
    this.playlist = ctl.getEventPlaylistModel(eventId);
  }

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    if(widget.playlist != null){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Event nr 2"),
        ),
        body: ListView.builder(
          itemCount: widget.playlist?.playlistElements.length,
          itemBuilder: (context, i) {
            if(widget.playlist?.playlistElements[i] is SongModel){
              return Song();
            }
            else{
              return Set();
            }
          },
        ),
      );
    }else{
      return const Text("Hello");
    }

  }
}
