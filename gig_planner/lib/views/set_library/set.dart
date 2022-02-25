import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/set_model.dart';

class Set extends StatefulWidget {
  final Controller ctl;
  final SetModel set;
  const Set({required this.ctl, required this.set, Key? key}) : super(key: key);

  @override
  State<Set> createState() => _SetState();
}

class _SetState extends State<Set> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.grey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(widget.set.name != null)
                    Text(widget.set.name!)
                  else
                    const Text("Set"),
                  Row(children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.expand_more)),
                  ])
                ],
              ),
              const SetElements(),
            ],
          ),
        ]),
      ),
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      padding: const EdgeInsets.all(5),
    );
  }
}

class SetElements extends StatefulWidget {
  const SetElements({Key? key}) : super(key: key);

  @override
  _SetElementsState createState() => _SetElementsState();
}

class _SetElementsState extends State<SetElements> {
  @override
  Widget build(BuildContext context) {
    final songs = ["Satisfaction", "Mambo No.5", "Wehikuł Czasu"];
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: songs.length + 1,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, i) {
            if (i >= songs.length) {
              return const AddSongToSet();
            }
            return SetSong(songs[i]);
          }),
      alignment: Alignment.topLeft,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}

class SetSong extends StatelessWidget {
  final String _songTitle;
  const SetSong(this._songTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: [
            const Visibility(
              child: Icon(Icons.drag_handle),
              // visible: false,
            ),
            Text(_songTitle),
          ],
        ),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5));
  }
}

class AddSongToSet extends StatelessWidget {
  const AddSongToSet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add), iconSize: 20),
            const Text("Add song"),
          ],
        ),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(5),
        //padding: const EdgeInsets.all(5),
    );
  }
}
