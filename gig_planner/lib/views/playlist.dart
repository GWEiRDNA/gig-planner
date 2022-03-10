import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import 'package:gig_planner_sketch/models/models.dart';
import 'package:gig_planner_sketch/views/set_library/select_set.dart';
import 'package:gig_planner_sketch/views/song_library/select_song.dart';
import '../models/playlist_model.dart';
import 'song_library/song.dart';
import 'set_library/set.dart';

class Playlist extends StatefulWidget {
  final Controller ctl;
  final int eventId;
  late EventModel curEvent;
  late final String eventName;
  PlaylistModel? playlist;
  Playlist({required PlaylistModel? newPlaylist, required this.ctl, required this.eventId, Key? key})
      : super(key: key) {
    this.playlist = ctl.getEventPlaylistModel(eventId);
    this.eventName = ctl.getEventName(eventId);
    this.curEvent = ctl.user.events.firstWhere((e) => e.id == eventId);
    if (playlist == null) {
      this.playlist = newPlaylist!;
    }
  }

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  late List<String> eMails;
  String newMail = "";

  @override
  initState() {
    super.initState();
    eMails = widget.ctl.getEventsSharedEmails(widget.curEvent)!;
  }

  addSong() {
    widget.ctl.addSongToPlaylist(widget.playlist!, widget.ctl.selectedSong!);
    setState(() {});
  }

  addSet() {
    widget.ctl.addSetToPlaylist(widget.playlist!, widget.ctl.selectedSet!);
    setState(() {});
  }

  deleteSong(SongModel song) {
    widget.ctl.deleteSongFromPlaylist(widget.playlist!, song);
    setState(() {});
  }

  deleteSet(SetModel set) {
    widget.ctl.deleteSetFromPlaylist(widget.playlist!, set);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.playlist = widget.ctl.user.playlists
        .firstWhere((p) => p.id == widget.playlist!.id);
    eMails = widget.ctl.getEventsSharedEmails(widget.curEvent)!;
    newMail = "";
    return Scaffold(
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: eMails.length + 1,
          itemBuilder: (context, i) {
            if (i < eMails.length) {
              return ListTile(
                title: Text(eMails[i]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.ctl.unshareEvent(widget.curEvent, eMails[i]);
                    setState(() {});
                  },
                ),
              );
            } else {
              return TextFormField(
                decoration: InputDecoration(
                  hintText: "To add user write his name",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (await widget.ctl.shareEventToUser(widget.curEvent, newMail)) {
                        setState(() {});
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(title: Text("Wrong user name.")));
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                onChanged: (text) {
                  newMail = text;
                },
              );
            }
          },
        ),
      ),
      appBar: AppBar(
        title: Text(widget.eventName),
      ),
      body: ListView.builder(
        itemCount: widget.playlist?.playlistElements.length,
        itemBuilder: (context, i) {
          if (widget.playlist?.playlistElements[i].element is SongModel) {
            return Column(
              children: [
                Checkbox(
                  value: widget.playlist!.playlistElements[i].played,
                  onChanged: (played) {
                    widget.ctl.switchPlayed(
                        widget.playlist!, widget.playlist!.playlistElements[i]);
                    setState(() {});
                  },
                ),
                SongRepresentation(
                    ctl: widget.ctl,
                    song: widget.playlist!.playlistElements[i].element
                        as SongModel,
                    deleteSong: deleteSong),
              ],
            );
          } else {
            return Column(
              children: [
                Checkbox(
                  value: widget.playlist!.playlistElements[i].played,
                  onChanged: (played) {
                    widget.ctl.switchPlayed(
                        widget.playlist!, widget.playlist!.playlistElements[i]);
                    setState(() {});
                  },
                ),
                SetRepresentation(
                  ctl: widget.ctl,
                  set: widget.playlist!.playlistElements[i].element as SetModel,
                  deleteSet: deleteSet,
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    children: [
                      ElevatedButton(
                        child: const Text("Add Song"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                      appBar:
                                          AppBar(title: Text("Select Song")),
                                      body: SelectSong(
                                          ctl: widget.ctl,
                                          refreshCaller: addSong))));
                        },
                      ),
                      ElevatedButton(
                          child: const Text("Add Set"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SelectSet(
                                        ctl: widget.ctl, returnSet: addSet)));
                          })
                    ],
                  ));
        },
      ),
    );
  }
}

class SongRepresentation extends StatefulWidget {
  final Controller ctl;
  final SongModel song;
  final Function deleteSong;
  SongRepresentation(
      {required this.ctl,
      required this.song,
      required this.deleteSong,
      Key? key})
      : super(key: key);

  @override
  State<SongRepresentation> createState() => _SongRepresentationState();
}

class _SongRepresentationState extends State<SongRepresentation> {
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
              subtitle: Text(widget.song.getAuthors().name),
              enabled: true,
              trailing: IconButton(
                  onPressed: () {
                    widget.deleteSong(widget.song);
                  },
                  icon: const Icon(Icons.delete)),
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
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    const Text("BPM"),
                    if (widget.song.bpm != null)
                      Text(widget.song.bpm.toString())
                    else
                      const Text(''),
                  ]),
                  Column(children: [
                    const Text("Duration"),
                    if (widget.song.duration != null)
                      Text(widget.song.duration.toString())
                    else
                      const Text(''),
                  ]),
                  Column(children: [
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

class SetRepresentation extends StatelessWidget {
  final Controller ctl;
  final SetModel set;
  final Function deleteSet;
  const SetRepresentation(
      {required this.ctl, required this.set, required this.deleteSet, Key? key})
      : super(key: key);

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
                  if (set.name != null) Text(set.name!) else const Text("Set"),
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          deleteSet(set);
                        },
                        icon: const Icon(Icons.delete)),
                  ])
                ],
              ),
              SetElements(ctl: ctl, set: set),
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
