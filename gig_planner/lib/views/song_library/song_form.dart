import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';
import '../../controllers/controller.dart';

class SongForm extends StatefulWidget {
  Controller ctl;
  SongModel? song;
  bool isUpdated;
  SongForm.new({required this.ctl, Key? key}) : isUpdated = false, super(key: key);
  SongForm.edit({required this.ctl, required this.song, Key? key})
      : isUpdated = true, super(key: key);

  @override
  _SongFormState createState() => _SongFormState();
}

class _SongFormState extends State<SongForm> {
  late final Controller ctl;
  String title = "";
  String? author;
  String? album;
  String? lyrics;
  String? sheetMusic;
  String? mp3;
  int? bpm;
  String? duration;
  int? released;

  @override void initState() {
    super.initState();
    ctl = widget.ctl;
    if(widget.isUpdated){
      title = widget.song!.title;
      album = widget.song!.album ?? "";
      lyrics = widget.song!.lyrics ?? "";
      sheetMusic = widget.song!.sheetMusic ?? "";
      mp3 = widget.song!.mp3 ?? "";
      bpm = widget.song!.bpm;
      duration = widget.song!.duration ?? "";
      released = widget.song!.yearOfRelease;
      author = widget.song!.getAuthors();
    }else {
      title = "";
      author = album = lyrics = sheetMusic = mp3 = duration = "";
      bpm = released = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new song"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          children: [
            //Title
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                hintText: "Title of the song",
              ),
            ),
            //Author
            TextFormField(
              initialValue: author,
              decoration: const InputDecoration(
                hintText: "Song's author",
              ),
            ),
            //Album
            TextFormField(
              initialValue: album,
              decoration: const InputDecoration(
                hintText: "Album of origin",
              ),
            ),
            //Lyrics
            Text("Lyrics"),
            //Sheet Music
            Text("Sheet Music"),
            //Chords
            Text("Chords"),
            //BMP
            TextFormField(
              initialValue: bpm != null? bpm.toString() : "",
              decoration: const InputDecoration(
                hintText: "Tempo in BPM ex. 140",
              ),
            ),
            //Duration
            TextFormField(
              initialValue: duration,
              decoration: const InputDecoration(
                hintText: "Song duration ex. 3:07",
              ),
            ),
            //Released
            TextFormField(
              initialValue: released != null ? released.toString() : "",
              decoration: const InputDecoration(
                hintText: "Year of release ex. 1924",
              ),
            ),
            IconButton(onPressed: (){
              if(widget.isUpdated){
                final proposedSong = SongModel(
                  id: widget.song!.id,
                  title: title,
                  ownerId: ctl.user.id,
                  album: album,
                  yearOfRelease: released,
                  bpm: bpm,
                  lyrics: lyrics,
                  mp3: mp3,
                  duration: duration,
                  authorIds: author,
                  //tagIds: tag,
                );
                if(ctl.updateSong(proposedSong)) {
                  Navigator.pop(context);
                }
              }
                if(ctl.newSong()) {
                  Navigator.pop(context);
                }
            }, icon: const Icon(Icons.check))
          ],
      ),
        )),
    );
  }
}
