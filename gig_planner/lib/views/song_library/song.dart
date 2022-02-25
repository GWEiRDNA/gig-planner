import 'package:flutter/material.dart';

class Song extends StatefulWidget {
  const Song({Key? key}) : super(key: key);

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
                const Text("Title of the song"),
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
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Artist'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("140 BPM"),
                  Text("Duration: 5:14 min"),
                  Text("Released: 1968"),
                ],
              ),
            )
          ],
        ));
  }
}
