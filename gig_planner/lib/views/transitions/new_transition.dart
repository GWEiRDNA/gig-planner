import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';
import 'package:gig_planner_sketch/views/song_library/select_song.dart';

import '../../controllers/controller.dart';

class NewTransition extends StatefulWidget {
  final Controller ctl;
  const NewTransition({required this.ctl, Key? key}) : super(key: key);

  @override
  _NewTransitionState createState() => _NewTransitionState();
}

class _NewTransitionState extends State<NewTransition> {
  SongModel? songA = null;
  SongModel? songB = null;

  selectSongA(){
    songA = widget.ctl.selectedSong;
    setState((){});
  }

  selectSongB(){
    songB = widget.ctl.selectedSong;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new Transition"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder:
                (_) => Scaffold(
                    appBar: AppBar(
                      title: Text("Select Song A"),
                    ),
                    body: SelectSong(ctl: widget.ctl, refreshCaller: selectSongA),
                  )
                )
              );
            }, child: Text(songA != null ? songA!.title : "Select Song A")),
            TextButton(onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder:
                      (_) => Scaffold(
                    appBar: AppBar(
                      title: Text("Select Song B"),
                    ),
                    body: SelectSong(ctl: widget.ctl, refreshCaller: selectSongB),
                  )
                  )
              );
            }, child: Text(songB != null ? songB!.title : "Select Song B")),
            IconButton(onPressed: (){
              if(songA != null && songB != null){
                TransitionModel transition = TransitionModel(songA!, songB!, -1, true);
                widget.ctl.createTransition(transition);
                Navigator.pop(context);
              }
            }, icon: const Icon(Icons.check)),
          ],
        ),
      ),
    );
  }
}
