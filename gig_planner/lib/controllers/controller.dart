
import '../models/models.dart';
import '../models/user_model.dart';

class Controller{
  UserModel user;
  SongModel? _selectedSong;
  SetModel? _selectedSet;
  Controller(this.user);

  //EVENTS
  EventModel createBlankEvent() {
    EventModel ev = EventModel(id: -1, name: "Event", permissions: "read write");
    return ev;
  }

  Future<bool?> addEvent() async {
  //   int? eventId = await user.insertEvent(null, "Event", null, null, null);
  //   if(eventId == null) {
  //     return null;
  //   }
  //   await user.insertPermission(eventId, 2);
  //   return user.events.where((ev) => ev.id == eventId).first;
  // }
  // await user.insertPermission(eventId, 2);
  // return user.events.where((ev) => ev.id == eventId).first;
  }

  Future<bool> updateEvent(EventModel updatedEv) async {
    // user.events.removeWhere((ev) => ev.id == updatedEv.id);
    // user.events.add(updatedEv);
    return await user.updateEvent(updatedEv);
  }

  Future<bool> deleteEvent(EventModel event) async {
    // user.events.removeWhere((ev) => ev.id == event.id);
    return await user.deleteEvent(event.id);
  }

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

  String getEventPermissions(String eventId){
    return "w";
  }

  PlaylistModel? getEventPlaylistModel(int eventId){
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


  //TAGS
  Future<bool> createNewTag(String name, int? groupId) async {
    // int NewId = Random().nextInt(2000000);
    // TagModel newTag = TagModel(id: NewId, name: name, userId: user.id, tagGroupId: groupId);
    return await user.insertTag(name, groupId);
  }

  Future<bool> deleteTag(int id) async {
    // user.tags.removeWhere((tag) => tag.id == id);
    return await user.deleteTag(id);
  }


  //TAG GROUPS
  Future<bool> createNewTagGroup(String name, String? color) async {
    // int NewId = Random().nextInt(2000000);
    // TagGroupModel newTagGroup = TagGroupModel(id: NewId, userId: user.id, name: name, color: color);
    // user.tagGroups.add(newTagGroup);
    color ??= "#000000";
    return await user.insertTagGroup(name, color);
  }

  Future<bool> updateTagGroup(TagGroupModel updatedTagGroup) async {
    // user.tagGroups.removeWhere((tagGroup) => tagGroup.id == newTagGroup.id);
    // user.tagGroups.add(newTagGroup);
    return await user.updateTagGroup(updatedTagGroup);
  }

  Future<bool> deleteTagGroup(TagGroupModel tagGroup) async {
    // user.tagGroups.removeWhere((tagGroup) => tagGroup.id == tagGroup.id);
    return await user.deleteTagGroup(tagGroup.id);
  }


  //SONGS
  SongModel createBlankSong() {
    return SongModel(id: -1, title: "New Song", ownerId: user.id);
  }

  Future<bool> addSong(SongModel proposedSong) async {
    proposedSong.bpm ??= 0.0;
    return (await user.insertSong(
        proposedSong.title,
        proposedSong.album,
        proposedSong.yearOfRelease,
        proposedSong.bpm!,
        proposedSong.lyrics,
        proposedSong.sheetMusic,
        proposedSong.mp3,
        proposedSong.duration
    ));
  }

  Future<bool> updateSong(SongModel proposedSong) async {
    // user.songs.removeWhere((s) => s.id == proposedSong.id);
    // user.songs.add(proposedSong);
    return await user.updateSong(proposedSong);
  }

  getSong(int songId) {
    user.songs.firstWhere((song) => song.id == songId);
  }

  void selectSong(SongModel song) {
    _selectedSong = song;
  }

  SongModel? get selectedSong => _selectedSong;

  getTransitions(){
    return <TransitionModel>[TransitionModel(user.songs.first, user.songs.elementAt(2), 30, false)];
  }


  //SETS
  Future<bool> createSet() async {
    // int NewId = Random().nextInt(2000000);
    // SetModel newSet = SetModel(id: NewId, userId: user.id, name: "Set");
    // user.sets.add(newSet);
    return await user.insertSet("Set", "#000000");
  }

  Future<bool> updateSetName(SetModel updatedSet, String? name) async {
    // if(name != null) {
    //   user.sets.firstWhere((sett) => sett.id == updatedSet.id).name = name;
    // }
    return await user.updateSet(SetModel(id: updatedSet.id, name: name,userId: updatedSet.userId));
  }

  Future<bool> deleteSet(SetModel set) async {
    user.sets.removeWhere((element) => element.id == set.id);
    return await user.deleteSet(set.id);
  }

  void selectSet(SetModel value) {
    _selectedSet = value;
  }

  SetModel? get selectedSet => _selectedSet;

  Future<bool> addSongToSet(SetModel set, SongModel? selectedSong) async {
    // if(SongModel != null) {
    //   user.sets.firstWhere((sett) => sett.id == set.id).songs.add(selectedSong!);
    // }
    if(selectedSong != null) {
      return await user.insertSetElement(set.id, selectedSong.id);
    }
    return true;
  }

  Future<bool> deleteSongFromSet(SetModel set, SongModel song) async {
    // user.sets.firstWhere((sett) => sett.id == set.id).songs.removeWhere((oldSong) => oldSong.id == song.id);
    // return true;
    return await user.deleteSetElement(set.id, song.id);
  }


  //PLAYLISTS
  Future<bool> addSongToPlaylist(PlaylistModel playlist, SongModel songModel) async {
    // PlaylistElementModel newSong = PlaylistElementModel.song(song: songModel);
    // user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.add(newSong);
    return await user.insertPlaylistSong(playlist.id, songModel.id, false);
  }

  Future<bool> deleteSongFromPlaylist(PlaylistModel playlist, SongModel songModel) async {
    // user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.removeWhere((s) => s.id == songModel.id);
    return await user.deletePlaylistSong(playlist.id, songModel.id);
  }

  Future<bool> addSetToPlaylist(PlaylistModel playlist, SetModel selectedSet) async {
    // PlaylistElementModel newSet = PlaylistElementModel.set(set: selectedSet);
    // user.playlists.firstWhere((p) => p.id == playlist.id).playlistElements.add(newSet);
    return await user.insertPlaylistSet(playlist.id, selectedSet.id, false);
  }

  Future<bool> deleteSetFromPlaylist(PlaylistModel playlist, SetModel set) async {
    // user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.removeWhere((s) => s.id == set.id);
    return await user.deletePlaylistSet(playlist.id, set.id);
  }


  //AUTHORS
  Future<bool> crateAuthor(String newAuthorName) async {
    // int NewId = Random().nextInt(2000000);
    // user.authors.add(AuthorModel(NewId, newAuthorName, user.id));
    return await user.insertAuthor(newAuthorName);
  }

  Future<bool> updateAuthor(AuthorModel oldAuthor, String updatedName) async {
    // user.authors.removeWhere((a) => a.id == author.id);
    // user.authors.add(AuthorModel(author.id, text, author.ownerId));
    return await user.updateAuthor(AuthorModel(oldAuthor.id, updatedName, oldAuthor.ownerId));
  }

  Future<bool> deleteAuthor(AuthorModel author) async {
    // user.authors.removeWhere((a) => a.id == author.id);
    return await user.deleteAuthor(author.id);
  }

  //Events
  // bool eventAvailable(String eventId){
  //   for(EventModel e in user.events){
  //     if(e.id == eventId){
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // List<String> getEventsIds(){
  //   List<String> eventIds = [];
  //   for(EventModel e in user.events){
  //     eventIds.add(e.id);
  //   }
  //   return eventIds;
  // }

  // String getEventName(String eventId){
  //   for(EventModel e in user.events){
  //     if(eventId == e.id){
  //       return e.name;
  //     }
  //   }
  //   //This doesn't happen
  //   return "";
  // }
  //
  // String getEventPermissions(String eventId){
  //   return "w";
  // }
  //
  // PlaylistModel? getEventPlaylistModel(String eventId){
  //   EventModel event = user.events.firstWhere((e) => e.id == eventId);
  //   return event.playlist;
  // }
  //
  // bool canReadEvent(String eventId){
  //   String permissions = getEventPermissions(eventId);
  //   switch(permissions){
  //     case "w":
  //       {
  //         return true;
  //       }
  //     case "r":
  //       {
  //         return true;
  //       }
  //     default: {
  //         return false;
  //     }
  //   }
  // }
  //
  // getSong(String songId) {
  //   user.songs.firstWhere((song) => song.id == songId);
  // }
  //
  // getTransitions(){
  //   return <TransitionModel>[TransitionModel(user.songs.first, user.songs.elementAt(2), 30, false)];
  // }
  //
  // bool newSong(SongModel proposedSong){
  //   user.songs.add(proposedSong);
  //   return true;
  // }
  // bool updateSong(SongModel proposedSong){
  //   user.songs.removeWhere((s) => s.id == proposedSong.id);
  //   user.songs.add(proposedSong);
  //   return true;
  // }
  //
  // //TAGS
  //   //TAGS
  // bool createNewTag(String name, String? groupId){
  //   int NewId = Random().nextInt(2000000);
  //   TagModel newTag = TagModel(id: "T${NewId}", name: name, userId: user.id, tagGroupId: groupId);
  //   user.tags.add(newTag);
  //   return true;
  // }
  //
  // bool deleteTag(String id){
  //   user.tags.removeWhere((tag) => tag.id == id);
  //   return true;
  // }
  //   //TAG GROUPS
  // bool createNewTagGroup(String name, String? color){
  //   int NewId = Random().nextInt(2000000);
  //   TagGroupModel newTagGroup = TagGroupModel(id: "TG${NewId}", userId: user.id, name: name, color: color);
  //   user.tagGroups.add(newTagGroup);
  //   return true;
  // }
  //
  // bool updateTagGroup(TagGroupModel newTagGroup){
  //   user.tagGroups.removeWhere((tagGroup) => tagGroup.id == newTagGroup.id);
  //   user.tagGroups.add(newTagGroup);
  //   return true;
  // }
  //
  // bool deleteTagGroup(TagGroupModel tg){
  //   user.tagGroups.removeWhere((tagGroup) => tagGroup.id == tg.id);
  //   return true;
  // }
  //
  // //SONGS
  // void selectSong(SongModel song) {
  //   _selectedSong = song;
  // }
  //
  // SongModel? get selectedSong => _selectedSong;
  //
  // //SETS
  // bool createSet(){
  //   int NewId = Random().nextInt(2000000);
  //   SetModel newSet = SetModel(id: "S${NewId}", userId: user.id, name: "Set");
  //   user.sets.add(newSet);
  //   return true;
  // }
  //
  // void selectSet(SetModel value) {
  //   _selectedSet = value;
  // }
  //
  // SetModel? get selectedSet => _selectedSet;
  //
  // bool deleteSongFromSet(SetModel set, SongModel song) {
  //   user.sets.firstWhere((sett) => sett.id == set.id).songs.removeWhere((oldSong) => oldSong.id == song.id);
  //   return true;
  // }
  //
  // void addSongToSet(SetModel set, SongModel? selectedSong) {
  //   if(SongModel != null) {
  //     user.sets.firstWhere((sett) => sett.id == set.id).songs.add(selectedSong!);
  //   }
  // }
  //
  // void updateSetName(SetModel updatedSet, String? name) {
  //   if(name != null) {
  //     user.sets.firstWhere((sett) => sett.id == updatedSet.id).name = name;
  //   }
  // }
  //
  // void deleteSet(SetModel set) {
  //   user.sets.removeWhere((element) => element.id == set.id);
  // }
  //
  // //PLAYLISTS
  // void addSetToPlaylist(PlaylistModel playlist, SetModel selectedSet) {
  //   PlaylistElementModel newSet = PlaylistElementModel.set(set: selectedSet);
  //   user.playlists.firstWhere((p) => p.id == playlist.id).playlistElements.add(newSet);
  // }
  //
  // void addSongToPlaylist(PlaylistModel playlistModel, SongModel songModel) {
  //   PlaylistElementModel newSong = PlaylistElementModel.song(song: songModel);
  //   user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.add(newSong);
  // }
  //
  // void deleteSongFromPlaylist(PlaylistModel playlistModel, SongModel songModel) {
  //   user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.removeWhere((s) => s.id == songModel.id);
  // }
  //
  // void deleteSetFromPlaylist(PlaylistModel playlistModel, SetModel set) {
  //   user.playlists.firstWhere((p) => p.id == playlistModel.id).playlistElements.removeWhere((s) => s.id == set.id);
  // }
  //
  // EventModel? createBlankEvent() {
  //   int NewId = Random().nextInt(2000000);
  //   EventModel ev = EventModel(id: "E${NewId}", name: "Event", permissions: "write");
  //   user.events.add(ev);
  //   return ev;
  // }
  //
  // void updateEvent(EventModel updatedEv) {
  //   user.events.removeWhere((ev) => ev.id == updatedEv.id);
  //   user.events.add(updatedEv);
  // }
  //
  // void deleteEvent(EventModel event) {
  //   user.events.removeWhere((ev) => ev.id == event.id);
  // }
  //
  // SongModel createBlankSong() {
  //   int NewId = Random().nextInt(2000000);
  //   return SongModel(id: "S${NewId}", title: "New Song", ownerId: user.id);
  // }
  //
  // void deleteAuthor(AuthorModel author) {
  //   user.authors.removeWhere((a) => a.id == author.id);
  // }
  //
  // void updateAuthor(AuthorModel author, String text) {
  //   user.authors.removeWhere((a) => a.id == author.id);
  //   user.authors.add(AuthorModel(author.id, text, author.ownerId));
  // }
  //
  // void crateAuthor(String newAuthorName) {
  //   int NewId = Random().nextInt(2000000);
  //   user.authors.add(AuthorModel("A${NewId}", newAuthorName, user.id));
  // }
  //
  void switchPlayed(PlaylistModel playlistModel, PlaylistElementModel playlistElement) {
    if(playlistElement.played == true){
      playlistElement.played = false;
    }else{
      playlistElement.played = true;
    }
  }

  List<SongModel> getProposedSongs(SongModel songA) {
    List<SongModel> proposedSongs = <SongModel>[];
    proposedSongs.add(SongModel(id: 5, title: "Brown Girl in the Ring", ownerId: 1));
    return proposedSongs;
  }

  Future<bool> updateLyrics(SongModel song, String lyrics) async {
    // user.songs.firstWhere((s) => s.id == song.id).lyrics = lyrics;
    return await user.updateSong(SongModel(id: song.id, title: song.title, ownerId: song.ownerId, lyrics: lyrics));
  }

  //EVENTS

}