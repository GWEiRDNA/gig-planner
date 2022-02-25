import 'package:gig_planner_sketch/views/event_library/event.dart';
import 'package:gig_planner_sketch/views/song_library/song.dart';
import 'package:gig_planner_sketch/views/tags/tags.dart';

import 'models.dart';

class UserModel{
  String id;
  String eMail;
  String nick;
  List<EventModel> events = <EventModel>[];
  List<SongModel> songs = <SongModel>[];
  List<SetModel> sets = <SetModel>[];
  List<TagModel> tags = <TagModel>[];
  List<TagGroupModel> tagGroups = <TagGroupModel>[];
  List<PlaylistModel> playlists = <PlaylistModel>[];
  UserModel(this.id, this.eMail, this.nick){
    tags; // getMyTags();
    songs;// = getMySongs();
    playlists;//getMyPlaylists();
    sets;// = getMySets();
    events;// = getMyEvents();
    tagGroups; // = getMyTagGroupModels
  }

  UserModel.mock({this.id = "U1", this.eMail = "johnsmith@gmai.com", this.nick = "Smith"}){
    tags.add(TagModel(id: "T1", name: "Slow", userId: "U1"));
    tags.add(TagModel(id: "T2", name: "Fast", userId: "U1"));
    songs.add(SongModel(id: "S1", title: "Knocking on Heavens door", ownerId: "U1"));
    songs.add(SongModel(id: "S2", title: "Mambo No. 5", ownerId: "U1"));
    songs.add(SongModel(id: "S3", title: "Stairway to Heaven", ownerId: "U1"));
    sets.add(SetModel(id: "S1", userId: "U1"));
    playlists.add(PlaylistModel("P1", "U1"));
    events.add(EventModel(id: 'E1', name: "New Year", permissions: "owner"));
    tagGroups.add(TagGroupModel(id: "TG1", userId: "U1", name: "Genre"));
  }

  List<String> getAvailableEventsIds(){
    //Mock
    List<String> eventIds = <String>[];
    for(EventModel e in events){
      eventIds.add(e.id);
    }
    return eventIds;
  }
}