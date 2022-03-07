import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/song_model.dart';

class SongLyrics extends StatelessWidget {
  final SongModel song;
  const SongLyrics({required this.song, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(song.lyrics!);
  }
}

class SongLyricsEdit extends StatefulWidget {
  final Controller ctl;
  final SongModel song;
  const SongLyricsEdit({required this.ctl, required this.song, Key? key}) : super(key: key);

  @override
  _SongLyricsEditState createState() => _SongLyricsEditState();
}

class _SongLyricsEditState extends State<SongLyricsEdit> {
  String lyrics = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lyrics = widget.song.lyrics ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: lyrics,
          minLines: 8,
          maxLines: 8,
          onChanged: (text){
            lyrics = text;
          },
        ),
        ElevatedButton(onPressed: (){
          widget.ctl.updateLyrics(widget.song, lyrics);
        }, child: const Text("Accept changes"))
      ],
    );
  }
}
