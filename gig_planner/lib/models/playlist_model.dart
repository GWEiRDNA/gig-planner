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
  dynamic element;
  Bool? played;

  PlaylistElementModel.song(SongModel this.element, this.played);
  PlaylistElementModel.set(SetModel this.element, this.played);
}