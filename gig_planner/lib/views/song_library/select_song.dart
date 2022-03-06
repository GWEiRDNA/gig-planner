import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/views/set_library/set.dart';

import '../../controllers/controller.dart';
import '../../models/song_model.dart';

class SelectSong extends StatefulWidget {
  final Controller ctl;
  final Function refreshCaller;
  const SelectSong({required this.ctl, required this.refreshCaller, Key? key}) : super(key: key);

  @override
  _SelectSongState createState() => _SelectSongState();
}

class _SelectSongState extends State<SelectSong> {
  late List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    songs = widget.ctl.user.songs;
      return ListView.builder(
          shrinkWrap: true,
          itemCount: songs.length,
          itemBuilder: (context, i){
            return ListTile(
              title: Text(songs[i].title),
              onTap: (){
                widget.ctl.selectSong(songs[i]);
                widget.refreshCaller();
                Navigator.pop(context);
              },
            );
          }
      );
  }
}
