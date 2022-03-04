import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/views/set_library/set_form.dart';

import '../../controllers/controller.dart';
import '../../models/set_model.dart';
import '../../models/song_model.dart';

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
                    IconButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SetForm(ctl: widget.ctl, updatedSet: widget.set))
                      );
                    }, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () {
                      widget.ctl.deleteSet(widget.set);
                    }, icon: const Icon(Icons.delete)),
                  ])
                ],
              ),
              SetElements(ctl: widget.ctl, set: widget.set),
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
  final Controller ctl;
  final SetModel set;
  const SetElements({required this.ctl, required this.set, Key? key}) : super(key: key);

  @override
  _SetElementsState createState() => _SetElementsState();
}

class _SetElementsState extends State<SetElements> {
  @override
  Widget build(BuildContext context) {
    List<SongModel> songs = widget.set.songs;
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: songs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, i) {
            return SetSong(songs[i].title);
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
