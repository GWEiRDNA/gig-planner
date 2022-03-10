import 'event_model.dart';
import 'song_model.dart';
import 'set_model.dart';

class PlaylistModel{
  int id;
  int ownerId;
  List<PlaylistElementModel> playlistElements = <PlaylistElementModel>[];

  List<EventModel> assignedToEvents = <EventModel>[];

  PlaylistModel(
    this.id, this.ownerId,
  );
}

class PlaylistElementModel{
  int _id;
  dynamic _element;
  bool? _played;

  PlaylistElementModel.song({required SongModel song, bool? played = false}) : _id = song.id, _element = song, _played = played;
  PlaylistElementModel.set({required SetModel set, bool? played = false}) : _id = set.id, _element = set, _played = played;

  int get id => _id;

  bool? get played => _played;

  set played(bool? value) {
    _played = value;
  }

  dynamic get element => _element;
}