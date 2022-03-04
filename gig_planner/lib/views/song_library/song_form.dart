import 'dart:math';

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
  double? bpm;
  int? duration;
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
      duration = (widget.song!.duration ?? "") as int?;
      released = widget.song!.yearOfRelease;
      author = widget.song!.getAuthors();
    }else {
      title = "";
      author = album = lyrics = sheetMusic = mp3 = "";
      duration = bpm = released = null;
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
              initialValue: duration != null? (duration!~/60).toString() + ":" + (duration!%60).toString() : "",
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
                  authorIds: author
                  //tagIds: tag,
                );
                if(ctl.updateSong(proposedSong)) {
                  Navigator.pop(context);
                }
              }
                if(ctl.newSong()) {
                  Navigator.pop(context);
                }
            }, icon: const Icon(Icons.check)),
            TagsView(ctl: ctl),
          ],
      ),
        )),
    );
  }
}


class TagsView extends StatefulWidget {
  Controller ctl;
  TagsView({required this.ctl, Key? key}) : super(key: key);

  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  List<TagGroupModel> tagGroups = [];

  @override
  Widget build(BuildContext context) {
    tagGroups = widget.ctl.user.tagGroups;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tagGroups.length + 1,
      itemBuilder: (context, i) {
        if(i == tagGroups.length) {
          return TagGroupView.others(ctl: widget.ctl);
        }
        return TagGroupView(ctl: widget.ctl, tg: tagGroups[i]);
      },
    );
  }
}

class TagGroupView extends StatefulWidget {
  Controller ctl;
  TagGroupModel? tg;
  TagGroupView({required this.ctl, required this.tg, Key? key}) : super(key: key);
  TagGroupView.others({required this.ctl, Key? key}) :super(key: key);

  @override
  _TagGroupViewState createState() => _TagGroupViewState();
}

class _TagGroupViewState extends State<TagGroupView> {
  @override
  List<TagModel> tags = [];

  Widget build(BuildContext context) {
    if(widget.tg != null) {
      for (TagModel tag in widget.ctl.user.tags) {
        if (tag.tagGroupId == widget.tg!.id) {
          tags.add(tag);
        }
      }
    }else{
      for (TagModel tag in widget.ctl.user.tags) {
        if (tag.tagGroupId == null) {
          tags.add(tag);
        }
      }
    }
    return Column(
      children: [
        widget.tg != null ? Text(widget.tg!.name) : const Text("Others"),
        Wrap(
          children: [
            for (TagModel tag in tags) TagView(ctl: widget.ctl, tag: tag),
          ],
        ),
      ],
    );
  }
}

class TagView extends StatefulWidget {
  Controller ctl;
  TagModel tag;
  TagView({required this.ctl, required this.tag, Key? key}) : super(key: key);

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  late bool selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = Random().nextBool();
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: Text(widget.tag.name, style: TextStyle(color: Colors.white)),
      backgroundColor: selected ? Colors.black : Colors.grey,
    );
  }
}


