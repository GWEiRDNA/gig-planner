import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/views/song_library/select_song.dart';

import '../../controllers/controller.dart';
import '../../models/set_model.dart';
import '../../models/song_model.dart';
import '../song_library/select_proposed_song.dart';

class SetForm extends StatefulWidget {
  final Controller ctl;
  final SetModel updatedSet;
  const SetForm({required this.ctl, required this.updatedSet, Key? key})
      : super(key: key);

  @override
  _SetFormState createState() => _SetFormState();
}

class _SetFormState extends State<SetForm> {
  String? name = "";
  String? color = "";
  List<SongModel> songs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.updatedSet.name;
    songs = widget.updatedSet.songs;
  }

  addSong() {
    widget.ctl.addSongToSet(widget.updatedSet, widget.ctl.selectedSong);
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    songs = widget.updatedSet.songs;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Set")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: name,
              decoration: InputDecoration(
                  hintText: "Set name",
                  suffixIcon: IconButton(onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      widget.ctl.updateSetName(widget.updatedSet, name);
                    }
                  }, icon: const Icon(Icons.check))
              ),
              onChanged: (text) {
                setState((){name = text;});
              },
                validator: (value){
                  //TODO
                  String? s = widget.ctl.checkSetName(value);
                  if(s != null){
                    return s; //Print error
                  }else{
                    return null;
                  }
                }
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: songs.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(songs[i].title),
                    trailing: IconButton(
                        onPressed: () {
                          widget.ctl
                              .deleteSongFromSet(widget.updatedSet, songs[i]);
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete)),
                  );
                }),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                        Scaffold(
                          appBar: AppBar(
                            title: Text("Select Song")
                          ),
                          body: Column(
                            children: [
                              if(songs.isNotEmpty)
                                SelectProposedSong(ctl: widget.ctl,
                                    returnSong: addSong,
                                    songA: songs.last),
                              SelectSong(ctl: widget.ctl, refreshCaller: addSong),
                            ],
                          ),
                        )
                    ));
              },
              leading: Icon(Icons.add),
              title: Text("Add New Song"),
            )
          ],
        ),
      ),
    );
  }
}
