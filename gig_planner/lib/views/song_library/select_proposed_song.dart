import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/song_model.dart';

class SelectProposedSong extends StatelessWidget {
  final Controller ctl;
  final Function returnSong;
  List<SongModel> proposedSongs = [];
  final SongModel songA;
  SelectProposedSong({required this.ctl, required this.returnSong, required this.songA, Key? key}) : super(key: key){
    proposedSongs = ctl.getProposedSongs(songA);
  }

  @override
  Widget build(BuildContext context) {
    if(proposedSongs.isNotEmpty){
      return Column(
        children: [
          const Text("Proposed Songs:"),
          ListView.builder(
            shrinkWrap: true,
            itemCount: proposedSongs.length,
            itemBuilder: (context, i){
              return ListTile(
                title: Text(proposedSongs[i].title),
                onTap: (){
                  ctl.selectSong(proposedSongs[i]);
                  returnSong();
                  Navigator.pop(context);
                },
                tileColor: const Color.fromRGBO(199, 250, 147, 1.0),
              );
            },
          ),
        ],
      );
    }else{
      return const SizedBox.shrink();
    }
  }
}
