import 'package:gig_planner_sketch/views/event_library/event.dart';
import 'package:gig_planner_sketch/views/song_library/song.dart';
import 'package:gig_planner_sketch/views/tags/tags.dart';

import 'models.dart';

class UserModel {
  String _id;
  String _eMail;
  String _nick;
  List<EventModel> _events = <EventModel>[];
  List<SongModel> _songs = <SongModel>[];
  List<SetModel> _sets = <SetModel>[];
  List<TagModel> _tags = <TagModel>[];
  List<TagGroupModel> _tagGroups = <TagGroupModel>[];
  List<PlaylistModel> _playlists = <PlaylistModel>[];
  UserModel(id, eMail, nick)
      : _id = id,
        _eMail = eMail,
        _nick = nick {
    _tags; // getMyTags();
    _songs; // = getMySongs();
    _playlists; //getMyPlaylists();
    _sets; // = getMySets();
    _events; // = getMyEvents();
    _tagGroups; // = getMyTagGroupModels
  }

  UserModel.mock({id = "U1", eMail = "johnsmith@gmai.com", nick = "Smith"})
      : _id = id,
        _eMail = eMail,
        _nick = nick {
    _tags.add(TagModel(id: "T1", name: "Slow", userId: "U1", tagGroupId: "TG1"));
    _tags.add(TagModel(id: "T2", name: "Fast", userId: "U1", tagGroupId: "TG1"));
    _tags.add(TagModel(id: "T3", name: "TODO", userId: "U1"));
    _songs.add(
        SongModel(id: "S1", title: "Knocking on Heavens door", ownerId: "U1"));
    _songs.add(SongModel(id: "S2", title: "Mambo No. 5", ownerId: "U1"));
    _songs.add(SongModel(id: "S3", title: "Stairway to Heaven", ownerId: "U1"));
    _sets.add(SetModel(id: "S1", userId: "U1"));
    _playlists.add(PlaylistModel("P1", "U1"));
    _events.add(EventModel(id: 'E1', name: "New Year", permissions: "owner", playlist: _playlists.first));
    _tagGroups.add(TagGroupModel(id: "TG1", userId: "U1", name: "Tempo"));
  }

  //TODO: Refresh

  List<PlaylistModel> get playlists => _playlists;

  List<TagGroupModel> get tagGroups => _tagGroups;

  List<TagModel> get tags => _tags;

  List<SetModel> get sets => _sets;

  List<SongModel> get songs => _songs;

  List<EventModel> get events => _events;

  String get nick => _nick;

  String get eMail => _eMail;

  String get id => _id;
}
