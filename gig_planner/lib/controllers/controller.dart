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
  bool eventAvailable(String eventId){
    for(EventModel e in user.events){
      if(e.id == eventId){
        return true;
      }
    }
    return false;
  }

  List<String> getEventsIds(){
    List<String> eventIds = [];
    for(EventModel e in user.events){
      eventIds.add(e.id);
    }
    return eventIds;
  }

  String getEventName(String eventId){
    for(EventModel e in user.events){
      if(eventId == e.id){
        return e.name;
      }
    }
    //This doesn't happen
    return "";
  }

  String getEventPermissions(String eventId){
    return "w";
  }

  PlaylistModel? getEventPlaylistModel(String eventId){
    EventModel event = user.events.firstWhere((e) => e.id == eventId);
    return event.playlist;
  }

  bool canReadEvent(String eventId){
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

  getSong(String songId) {
    user.songs.firstWhere((song) => song.id == songId);
  }

  getTransitions(){
    return <TransitionModel>[TransitionModel(user.songs.first, user.songs.elementAt(2), 30, false)];
  }

  bool newSong(SongModel proposedSong){
    user.songs.add(proposedSong);
    return true;
  }
  bool updateSong(SongModel proposedSong){
    user.songs.removeWhere((s) => s.id == proposedSong.id);
    user.songs.add(proposedSong);
    return true;
  }

  //TAGS
    //TAGS
  bool createNewTag(String name, String? groupId){
    int NewId = Random().nextInt(2000000);
    TagModel newTag = TagModel(id: "T${NewId}", name: name, userId: user.id, tagGroupId: groupId);
    user.tags.add(newTag);
    return true;
  }

  bool deleteTag(String id){
    user.tags.removeWhere((tag) => tag.id == id);
    return true;
  }
    //TAG GROUPS
  bool createNewTagGroup(String name, String? color){
    int NewId = Random().nextInt(2000000);
    TagGroupModel newTagGroup = TagGroupModel(id: "TG${NewId}", userId: user.id, name: name, color: color);
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
    SetModel newSet = SetModel(id: "S${NewId}", userId: user.id, name: "Set");
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

  //PLAYLISTS
  void addSetToPlaylist(PlaylistModel playlist, SetModel selectedSet) {
    PlaylistElementModel newSet = PlaylistElementModel.set(set: selectedSet);
    user.playlists.firstWhere((p) => p.id == playlist.id).playlistElements.add(newSet);
  }

  void addSongToPlaylist(PlaylistModel playlistModel, SongModel songModel) {
    PlaylistElementModel newSong = PlaylistElementModel.song(song: songModel);
    user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.add(newSong);
  }

  void deleteSongFromPlaylist(PlaylistModel playlistModel, SongModel songModel) {
    user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.removeWhere((s) => s.id == songModel.id);
  }

  void deleteSetFromPlaylist(PlaylistModel playlistModel, SetModel set) {
    user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.removeWhere((s) => s.id == set.id);
  }

  EventModel? createBlankEvent() {
    int NewId = Random().nextInt(2000000);
    EventModel ev = EventModel(id: "E${NewId}", name: "Event", permissions: "write");
    user.events.add(ev);
    return ev;
  }

  void updateEvent(EventModel updatedEv) {
    user.events.removeWhere((ev) => ev.id == updatedEv.id);
    user.events.add(updatedEv);
  }

  void deleteEvent(EventModel event) {
    user.events.removeWhere((ev) => ev.id == event.id);
  }

  SongModel createBlankSong() {
    int NewId = Random().nextInt(2000000);
    return SongModel(id: "S${NewId}", title: "New Song", ownerId: user.id);
  }

  void deleteAuthor(AuthorModel author) {
    user.authors.removeWhere((a) => a.id == author.id);
  }

  void updateAuthor(AuthorModel author, String text) {
    user.authors.removeWhere((a) => a.id == author.id);
    user.authors.add(AuthorModel(author.id, text, author.ownerId));
  }

  void crateAuthor(String newAuthorName) {
    int NewId = Random().nextInt(2000000);
    user.authors.add(AuthorModel("A${NewId}", newAuthorName, user.id));
  }

  //EVENTS

}