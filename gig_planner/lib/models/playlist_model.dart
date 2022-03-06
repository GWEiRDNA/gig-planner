import 'dart:ffi';
import 'package:gig_planner_sketch/views/playlist.dart';

import 'event_model.dart';
import 'song_model.dart';
import 'set_model.dart';

class PlaylistModel{
  String id;
  String ownerId;
  List<PlaylistElementModel> playlistElements = <PlaylistElementModel>[];

  List<EventModel> assignedToEvents = <EventModel>[];

  PlaylistModel(
    this.id, this.ownerId,
  );
}

class PlaylistElementModel{
  String _id;
  dynamic _element;
  bool? _played;

  PlaylistElementModel.song({required SongModel song, bool? played = false}) : _id = song.id, _element = song, _played = played;
  PlaylistElementModel.set({required SetModel set, bool? played = false}) : _id = set.id, _element = set, _played = played;

  String get id => _id;

  bool? get played => _played;

  dynamic get element => _element;

  set played(bool? value) {
    _played = value;
  }
}