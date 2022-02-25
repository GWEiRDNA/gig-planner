import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/song_model.dart';

class Song extends StatefulWidget {
  Controller ctl;
  SongModel song;
  Song({required Controller this.ctl, required SongModel this.song, Key? key}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.song.title),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Lyrics'),
                    Text('Sheet Music'),
                    Text('Chords'),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(widget.song.getAuthors()),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(widget.song.bpm != null)
                    Text(widget.song.bpm.toString()),
                  if(widget.song.duration != null)
                    Text(widget.song.duration.toString()),
                  if(widget.song.yearOfRelease != null)
                    Text("Released: ${widget.song.yearOfRelease}"),
                ],
              ),
            )
          ],
        ));
  }
}
