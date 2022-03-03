import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';
import 'package:gig_planner_sketch/views/set_library/set.dart';

import '../../controllers/controller.dart';

class SelectSet extends StatefulWidget {
  final Controller ctl;
  const SelectSet({required this.ctl, Key? key}) : super(key: key);

  @override
  _SelectSetState createState() => _SelectSetState();
}

class _SelectSetState extends State<SelectSet> {
  late List<SetModel> sets;

  @override
  Widget build(BuildContext context) {
    sets = widget.ctl.user.sets;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Set"),
      ),
      body: ListView.builder(
          itemCount: sets.length,
          itemBuilder: (context, i){
            return SetView(ctl: widget.ctl, set: sets[i]);
          }
      ),
    );
  }
}

class SetView extends StatelessWidget {
  final Controller ctl;
  final SetModel set;
  List<SongModel> songs;
  SetView({required this.ctl, required this.set, Key? key}) : songs = set.songs, super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        ctl.selectSet(set);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          if(set.name != null)
            Text(set.name!)
          else
            const Text("Set"),
          for(SongModel song in songs) Text(song.title, style: const TextStyle(
            fontSize: 12
          ),)
        ],
      ),
    );
  }
}

