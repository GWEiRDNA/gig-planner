
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

  Future<bool?> addEvent(EventModel ev) async {
    return await user.insertEvent(ev.playlist?.id, ev.name, ev.startDate, ev.endDate, ev.description);
  }

  Future<bool> updateEvent(EventModel updatedEv) async {
    return await user.updateEvent(updatedEv);
  }

  Future<bool> deleteEvent(EventModel event) async {
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

  Future<PlaylistModel?> createBlankPlaylist(EventModel ev) async {
    PlaylistModel? playlist = await user.insertPlaylist();
    await user.updateEvent(EventModel(id: ev.id, playlist: playlist, name: ev.name, startDate: ev.startDate, endDate: ev.endDate, description: ev.description, permissions: ev.permissions));
    ev.playlist = playlist;
    return playlist;
  }

  List<String>? getEventsSharedEmails(EventModel curEvent) {
    return curEvent.shared;
  }

  Future<bool> shareEventToUser(EventModel curEvent, String eMail) async {
      return await user.insertPermission(curEvent.id, "read", eMail);
  }

  Future<bool> unshareEvent(EventModel curEvent, String eMail) async {
    return await user.deletePermission(curEvent.id, "read", eMail);
  }

  List<SongModel> getProposedSongs(SongModel songA) {
    List<SongModel> proposedSongs = <SongModel>[]; //TODO
    proposedSongs.add(SongModel(id: 5, title: "Brown Girl in the Ring", ownerId: 1));
    return proposedSongs;
  }


  //TAGS
  Future<bool> createNewTag(String name, int? groupId) async {
    return await user.insertTag(name, groupId);
  }

  Future<bool> deleteTag(int id) async {
    return await user.deleteTag(id);
  }


  //TAG GROUPS
  Future<bool> createNewTagGroup(String name, String? color) async {
    color ??= "#000000";
    return await user.insertTagGroup(name, color);
  }

  Future<bool> updateTagGroup(TagGroupModel updatedTagGroup) async {
    return await user.updateTagGroup(updatedTagGroup);
  }

  Future<bool> deleteTagGroup(TagGroupModel tagGroup) async {
    return await user.deleteTagGroup(tagGroup.id);
  }


  //SONGS
  SongModel createBlankSong() {
    return SongModel(id: -1, title: "New Song", ownerId: user.id);
  }

  Future<bool> addSong(SongModel proposedSong) async {
    List<TagModel> tags = [];
    return await user.insertSong(
        proposedSong.title,
        proposedSong.album,
        proposedSong.yearOfRelease,
        proposedSong.bpm!,
        proposedSong.lyrics,
        proposedSong.sheetMusic,
        proposedSong.mp3,
        proposedSong.duration,
        proposedSong.authors,
        tags
    );
  }

  Future<bool> updateSong(SongModel proposedSong) async {
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

  Future<bool> updateLyrics(SongModel song, String lyrics) async {
    return await user.updateSong(SongModel(id: song.id, title: song.title, album: song.album, yearOfRelease: song.yearOfRelease, bpm: song.bpm, lyrics: lyrics, mp3: song.mp3, duration: song.duration, ownerId: song.ownerId));
  }


  //SETS
  Future<bool> createSet() async {
    return await user.insertSet("Set", "#000000");
  }

  Future<bool> updateSetName(SetModel updatedSet, String? name) async {
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
    if(selectedSong != null) {
      return await user.insertSetElement(set.id, selectedSong.id);
    }
    return true;
  }

  Future<bool> deleteSongFromSet(SetModel set, SongModel song) async {
    return await user.deleteSetElement(set.id, song.id);
  }


  //PLAYLISTS
  Future<bool> addSongToPlaylist(PlaylistModel playlist, SongModel songModel) async {
    return await user.insertPlaylistSong(playlist.id, songModel.id, false);
  }

  Future<bool> deleteSongFromPlaylist(PlaylistModel playlist, SongModel songModel) async {
    return await user.deletePlaylistSong(playlist.id, songModel.id);
  }

  Future<bool> addSetToPlaylist(PlaylistModel playlist, SetModel selectedSet) async {
    return await user.insertPlaylistSet(playlist.id, selectedSet.id, false);
  }

  Future<bool> deleteSetFromPlaylist(PlaylistModel playlist, SetModel set) async {
    return await user.deletePlaylistSet(playlist.id, set.id);
  }

  void switchPlayed(PlaylistModel playlistModel, PlaylistElementModel playlistElement) {
    if(playlistElement.element is SongModel) {
      user.updatePlaylistSong(playlistModel.id, playlistElement.id, (playlistElement.played == null)? false: !(playlistElement.played!));
    }
    else if(playlistElement.element is SetModel){
      user.updatePlaylistSet(playlistModel.id, playlistElement.id, (playlistElement.played == null)? false: !(playlistElement.played!));
    }
  }

  //AUTHORS
  Future<bool> crateAuthor(String newAuthorName) async {
    return await user.insertAuthor(newAuthorName);
  }

  Future<bool> updateAuthor(AuthorModel oldAuthor, String updatedName) async {
    return await user.updateAuthor(AuthorModel(oldAuthor.id, updatedName, oldAuthor.ownerId));
  }

  Future<bool> deleteAuthor(AuthorModel author) async {
    return await user.deleteAuthor(author.id);
  }
}