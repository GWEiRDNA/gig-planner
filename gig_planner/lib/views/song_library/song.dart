import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/views/song_library/song_form.dart';

import '../../controllers/controller.dart';
import '../../models/song_model.dart';

class Song extends StatefulWidget {
  Controller ctl;
  SongModel song;
  Song({required this.ctl, required this.song, Key? key})
      : super(key: key);

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.song.title),
              subtitle: Text(widget.song.getAuthors()),
              enabled: true,
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SongForm.edit(ctl: widget.ctl, song: widget.song))
                    );
                  }, 
                  icon: const Icon(Icons.edit)
              ),
            ),
            if(widget.song.album != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16,0,16,12),
                child: Text(
                  "Album: ${widget.song.album}",
                  style: const TextStyle(
                    fontSize: 14
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Lyrics")),
                    ElevatedButton(onPressed: null, child: Text("Sheet Music")),
                    ElevatedButton(onPressed: null, child: Text("Chords")),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Column(
                      children: [
                        const Text("BPM"),
                        if (widget.song.bpm != null)
                          Text(widget.song.bpm.toString())
                        else
                          const Text(''),
                    ]),
                    Column(
                        children: [
                          const Text("Duration"),
                          if (widget.song.duration != null)
                            Text(widget.song.duration.toString())
                          else
                            const Text(''),
                        ]),
                    Column(
                        children: [
                          const Text("Released"),
                          if (widget.song.yearOfRelease != null)
                            Text(widget.song.yearOfRelease.toString())
                          else
                            const Text('')
                        ]),
                ],
              ),
            ),
          ],
        ));
  }
}
