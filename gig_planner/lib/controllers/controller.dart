import 'package:gig_planner_sketch/views/playlist.dart';
import 'package:gig_planner_sketch/views/tags/tags_library.dart';
import 'dart:math';


import '../models/models.dart';
import '../models/user_model.dart';

class Controller{
  UserModel user;

  SongModel? _selectedSong;
  SetModel? _selectedSet;

  Controller(this.user);

  //Events
  bool eventAvailable(int eventId){
    for(EventModel e in user.events){
      if(e.id == eventId){
        return true;
      }
    }
    return false;
  }

  List<int> getEventsIds(){
    List<int> eventIds = [];
    for(EventModel e in user.events){
      eventIds.add(e.id);
    }
    return eventIds;
  }

  String getEventName(int eventId){
    for(EventModel e in user.events){
      if(eventId == e.id){
        return e.name;
      }
    }
    //This doesn't happen
    return "";
  }

  String getEventPermissions(int eventId){
    return "w";
  }

  PlaylistModel? getEventPlaylistModel(int eventId){
    EventModel event = user.events.firstWhere((e) => e.id == eventId);
    return event.playlist;
  }

  bool canReadEvent(int eventId){
    String permissions = getEventPermissions(eventId);
    switch(permissions){
      case "w":
        {
          return true;
        }
      case "r":
        {
          return true;
        }
      default: {
          return false;
      }
    }
  }

  getSong(int songId) {
    user.songs.firstWhere((song) => song.id == songId);
  }

  getTransitions(){
    return <TransitionModel>[TransitionModel(user.songs.first, user.songs.elementAt(2), 30, false)];
  }

  bool newSong(){
    //createSong(user, others....)
    return true;
  }
  bool updateSong(SongModel proposedSong){
    //if(tryUpdatingSong(user, proposedSong) == true){}
    return true;
  }

  //TAGS
    //TAGS
  bool createNewTag(String name, int? groupId){
    int NewId = Random().nextInt(2000000);
    TagModel newTag = TagModel(id: NewId, name: name, userId: user.id, tagGroupId: groupId);
    user.tags.add(newTag);
    return true;
  }

  bool deleteTag(int id){
    user.tags.removeWhere((tag) => tag.id == id);
    return true;
  }
    //TAG GROUPS
  bool createNewTagGroup(String name, String? color){
    int NewId = Random().nextInt(2000000);
    TagGroupModel newTagGroup = TagGroupModel(id: NewId, userId: user.id, name: name, color: color);
    user.tagGroups.add(newTagGroup);
    return true;
  }

  bool updateTagGroup(TagGroupModel newTagGroup){
    user.tagGroups.removeWhere((tagGroup) => tagGroup.id == newTagGroup.id);
    user.tagGroups.add(newTagGroup);
    return true;
  }

  bool deleteTagGroup(TagGroupModel tg){
    user.tagGroups.removeWhere((tagGroup) => tagGroup.id == tg.id);
    return true;
  }

  //SONGS
  void selectSong(SongModel song) {
    _selectedSong = song;
  }

  SongModel? get selectedSong => _selectedSong;

  //SETS
  bool createSet(){
    int NewId = Random().nextInt(2000000);
    SetModel newSet = SetModel(id: NewId, userId: user.id, name: "Set");
    user.sets.add(newSet);
    return true;
  }

  void selectSet(SetModel value) {
    _selectedSet = value;
  }

  SetModel? get selectedSet => _selectedSet;

  bool deleteSongFromSet(SetModel set, SongModel song) {
    user.sets.firstWhere((sett) => sett.id == set.id).songs.removeWhere((oldSong) => oldSong.id == song.id);
    return true;
  }

  void addSongToSet(SetModel set, SongModel? selectedSong) {
    if(SongModel != null) {
      user.sets.firstWhere((sett) => sett.id == set.id).songs.add(selectedSong!);
    }
  }

  void updateSetName(SetModel updatedSet, String? name) {
    if(name != null) {
      user.sets.firstWhere((sett) => sett.id == updatedSet.id).name = name;
    }
  }

  void deleteSet(SetModel set) {
    user.sets.removeWhere((element) => element.id == set.id);
  }
}