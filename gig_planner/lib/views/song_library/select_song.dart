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
  String search = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    songs = widget.ctl.getSongs("");
  }


  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: IconButton(
                onPressed: (){
                  songs = widget.ctl.getSongsLike(search);
                  setState((){});
                },
                icon: Icon(Icons.search),
              ),
            ),
            onChanged: (text){
              search = text;
            },
          ),
          ListView.builder(
              primary: false,
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
          ),
        ],
      );
  }
}
