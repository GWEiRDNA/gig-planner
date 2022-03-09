import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';
import 'package:gig_planner_sketch/views/authors/select_author.dart';
import 'package:gig_planner_sketch/views/song_library/song_lyrics.dart';
import '../../controllers/controller.dart';

class SongForm extends StatefulWidget {
  Controller ctl;
  SongModel song;
  bool isUpdated;
  SongForm.new({required this.ctl, Key? key}) : isUpdated = false, song = ctl.createBlankSong(), super(key: key);
  SongForm.edit({required this.ctl, required this.song, Key? key})
      : isUpdated = true, super(key: key);

  @override
  _SongFormState createState() => _SongFormState();
}

class _SongFormState extends State<SongForm> {
  String title = "";
  AuthorModel? author;
  String? album;
  String? lyrics;
  String? sheetMusic;
  String? mp3;
  double? bpm;
  String? duration;
  int? released;
  List<TagModel> selectedTags = [];

  selectAuthor(AuthorModel selectedAuthor){
    author = selectedAuthor;
    setState(() {});
  }

  @override void initState() {
    super.initState();
    if(widget.isUpdated){
      title = widget.song.title;
      album = widget.song.album ?? "";
      lyrics = widget.song.lyrics ?? "";
      sheetMusic = widget.song.sheetMusic ?? "";
      mp3 = widget.song.mp3 ?? "";
      bpm = widget.song.bpm;
      duration = widget.song.duration ?? "";
      released = widget.song.yearOfRelease;
      author = widget.song.getAuthors();
      selectedTags = widget.song.tags;
      //TODO: getAuthors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new song"),
      ),
      body: SingleChildScrollView(
        child: Form(
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
              ListTile(
                title: Text(author != null ? author!.name : "Select author"),
                subtitle: const Text("Tap to change"),
                onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SelectAuthor(ctl: widget.ctl, refreshCaller: selectAuthor))
                );}
              ),
              //Album
              TextFormField(
                initialValue: album,
                decoration: const InputDecoration(
                  hintText: "Album of origin",
                ),
              ),
              //Lyrics
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                        title: Text("${widget.song.title} lyrics")
                                    ),
                                    body: SongLyricsEdit(ctl: widget.ctl, song: widget.song)
                                )
                            )
                        );
                      },
                      child: widget.song.lyrics == null ? const Text("Add Lyrics") : Text("Edit Lyrics"),
                    ),
                    ElevatedButton(onPressed: null, child: Text("Sheet Music")),
                    ElevatedButton(onPressed: null, child: Text("Chords")),
                  ]),
              //BMP
              TextFormField(
                initialValue: bpm != null ? bpm.toString() : "",
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
              TagsView(ctl: widget.ctl, song: widget.song, selTags: selectedTags),
              ElevatedButton(
                  onPressed: () async {
                    List<AuthorModel> authors = [];
                    if(author != null) {
                      authors.add(author!);
                    }
                final proposedSong = SongModel(
                  id: widget.song.id,
                  title: title,
                  ownerId: widget.ctl.user.id,
                  album: album,
                  yearOfRelease: released,
                  bpm: bpm,
                  lyrics: lyrics,
                  mp3: mp3,
                  duration: duration,
                  preAuthors: authors,
                  preTags: selectedTags,
                );
                if(widget.isUpdated && await widget.ctl.updateSong(proposedSong)) {
                  Navigator.pop(context);
                }
                if(!widget.isUpdated && await widget.ctl.addSong(proposedSong)) {
                  Navigator.pop(context);
                }
              }, child: const Icon(Icons.check)),
            ],
        ),
          )),
      ),
    );
  }
}

class TagsView extends StatefulWidget {
  Controller ctl;
  SongModel song;
  List<TagModel> selTags;
  TagsView({required this.ctl, required this.song, required this.selTags, Key? key}) : super(key: key);

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
          return TagGroupView.others(ctl: widget.ctl, song: widget.song, selTags: widget.selTags);
        }
        return TagGroupView(ctl: widget.ctl, tg: tagGroups[i], song: widget.song, selTags: widget.selTags);
      },
    );
  }
}

class TagGroupView extends StatefulWidget {
  Controller ctl;
  TagGroupModel? tg;
  List<TagModel> selTags;
  SongModel song;
  TagGroupView({required this.ctl, required this.tg, required this.song, required this.selTags, Key? key}) : super(key: key);
  TagGroupView.others({required this.ctl, required this.song, required this.selTags, Key? key}) :super(key: key);

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
            for (TagModel tag in tags) TagView(ctl: widget.ctl, song: widget.song, tag: tag, selTags: widget.selTags),
          ],
        ),
      ],
    );
  }
}

class TagView extends StatefulWidget {
  Controller ctl;
  TagModel tag;
  List<TagModel> selTags;
  SongModel song;
  TagView({required this.ctl, required this.song, required this.tag, required this.selTags, Key? key}) : super(key: key);

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  late bool selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.song.tags.isNotEmpty && widget.song.tags.any((t) => t.id== widget.tag.id);
  }

  @override
  Widget build(BuildContext context) {
    selected = widget.song.tags.isNotEmpty && widget.song.tags.any((t) => t.id== widget.tag.id);
    return GestureDetector(
      child: Chip(
          label: Text(widget.tag.name, style: TextStyle(color: Colors.white)),
        backgroundColor: selected ? Colors.black : Colors.grey,
      ),
      onTap: (){
        setState(() {
          if(!selected){
            widget.selTags.add(widget.tag);
            selected = true;
          }else{
            widget.selTags.removeWhere((tag) => tag.id == widget.tag.id);
            selected = false;
          }
        });
      },
    );
  }
}


