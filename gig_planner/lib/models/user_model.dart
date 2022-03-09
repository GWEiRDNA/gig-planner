import 'package:postgres/postgres.dart';
import '../databaseOperations.dart';
import '../queries/myQueriesList.dart';
import 'models.dart';

class UserModel {
  int _id;
  String _eMail;
  String _nick;
  PostgreSQLConnection _connection;
  List<EventModel> _events = <EventModel>[];
  List<SongModel> _songs = <SongModel>[];
  List<SetModel> _sets = <SetModel>[];
  List<TagModel> _tags = <TagModel>[];
  List<TagGroupModel> _tagGroups = <TagGroupModel>[];
  List<PlaylistModel> _playlists = <PlaylistModel>[];
  List<AuthorModel> _authors = <AuthorModel>[];
  UserModel(id, eMail, nick, connection)
      : _id = id,
        _eMail = eMail,
        _nick = nick,
        _connection = connection{
    _tags; // getMyTags();
    _songs; // = getMySongs();
    _playlists; //getMyPlaylists();
    _sets; // = getMySets();
    _events; // = getMyEvents();
    _tagGroups; // = getMyTagGroupModels
    initUser();
  }

  void initUser()
  {
    pullTagsGroups();
    pullTags();
    pullAuthors();
    pullSongs();
    pullSets();
    pullPlaylists();
    pullEvents();
  }


  //TAGS GROUPS
  Future<void> pullTagsGroups() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectTagGroupsQuery, {'@userId': _id});
    _tagGroups.clear();
    for (final row in results) {
      _tagGroups.add(TagGroupModel(id: row['tag_groups']!['id'], name: row['tag_groups']!['name'], userId: row['tag_groups']!['users_id'], color: row['tag_groups']!['color']));
    }
  }

  Future<bool> insertTagGroup(String name, String color, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertTagGroupsQuery, {'@userId': userId, '@name': name, '@color': color});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullTagsGroups();
    return true;
  }

  Future<bool> updateTagGroup(TagGroupModel tagGroup) async {
    try {
      String? color = tagGroup.color;
      color ??= "#000000";
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, updateTagGroupsQuery, {'@id': tagGroup.id, '@name': tagGroup.name, '@color': color});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullTagsGroups();
    return true;
  }

  Future<bool> deleteTagGroup(int tagGroupId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteTagGroupsQuery, {'@id': tagGroupId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullTagsGroups();
    return true;
  }


  //TAGS
  Future<void> pullTags() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectTagsQuery, {'@userId': _id});
    _tags.clear();
    for (final row in results) {
      _tags.add(TagModel(id: row['tags']!['id'], name: row['tags']!['name'], userId: row['tags']!['users_id'], tagGroupId: row['tags']!['tag_groups_id']));
    }
  }

  Future<bool> insertTag(String name,[int? tagGroupId, int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertTagQuery, {'@tagGroupsId': tagGroupId, '@userId': userId, '@name': name});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullTags();
    return true;
  }

  Future<bool> deleteTag(int tagId, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteTagQuery, {'@id': tagId, '@userId': userId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullTags();
    return true;
  }


  //AUTHORS
  Future<void> pullAuthors() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectAuthorsQuery, {'@userId': _id});
    _authors.clear();
    for (final row in results) {
      _authors.add(AuthorModel(row['authors']!['id'], row['authors']!['name'], row['authors']!['users_id']));
    }
  }

  Future<bool> insertAuthor(String name, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertAuthorQuery, {'@userId': userId, '@name': name});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullAuthors();
    return true;
  }

  Future<bool> updateAuthor(AuthorModel author, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, updateAuthorQuery, {'@id': author.id, '@name': author.name, '@userId': userId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullAuthors();
    return true;
  }

  Future<bool> deleteAuthor(int authorsId, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteAuthorQuery, {'@id': authorsId, '@userId': userId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullAuthors();
    return true;
  }


  //SONGS
  Future<void> pullSongs() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectSongsQuery, {'@userId': _id});
    _songs.clear();

    for (final row in results) {
      List<TagModel> tags = [];
      if(row[''] != null && row['']!['tags'] != null) {
        for (String strId in row['']!['tags'].split(' ')) {
          int id = int.parse(strId);
          for(TagModel tag in _tags) {
            if(tag.id == id) {
              tags.add(tag);
            }
          }
        }
      }
      List<AuthorModel> authors = [];
      if(row[''] != null && row['']!['authors'] != null) {
        for (String strId in row['']!['authors'].split(' ')) {
          int id = int.parse(strId);
          for(AuthorModel author in _authors) {
            if(author.id == id) {
              authors.add(author);
            }
          }
        }
      }
      _songs.add(SongModel(
        id: row['songs']!['id'],
        ownerId: row['songs']!['users_id'],
        title: row['songs']!['title'],
        album: row['songs']!['album'],
        bpm: row['songs']!['bpm'],
        lyrics: row['songs']!['lyrics'],
        mp3: row['songs']!['mp3'],
        duration: (row['songs']!['length'] == null)? null : (row['songs']!['length']~/60).toString() + ":" + ( (row['songs']!['length']%60 < 10)? "0" + (row['songs']!['length']%60).toString() : (row['songs']!['length']%60).toString()), //form seconds to MM:SS
        preTags: tags,
        preAuthors: authors
      ));
    }
  }
  Future<bool> insertSong(String title, String? album, int? yearOfRelease, double bpm, String? lyrics, String? sheetMusic, String? mp3, String? duration,  [int? userId]) async {
    userId ??= _id;
    int? length;
    if(duration != null) {
      length = 60*(int.parse(duration.split(":")[0]) + int.parse(duration.split(":")[1]));
    }
    try {
      print('XXXXXXXXXXXX'+title);
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertSongQuery, {
            '@userId': userId,
            '@title': title,
            '@album': album,
            '@dateOfRelease': (yearOfRelease == null)? null :yearOfRelease.toString()+"-01-01",
            '@bpm': bpm, '@lyrics': lyrics,
            '@sheetMusic': sheetMusic,
            '@mp3': mp3,
            '@length': length
          });
      if(results.isEmpty) {print("empty");return false;}
    } on Exception catch(e) {print(e.toString());return false;}
    pullSongs();
    return true;
  }

  Future<bool> updateSong(SongModel updatedSong) async {
    int? length;
    if(updatedSong.duration != null) {
      length = 60*(int.parse(updatedSong.duration!.split(":")[0]) + int.parse(updatedSong.duration!.split(":")[1]));
    }
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, updateSongQuery, {
            '@id': updatedSong.id,
            '@title': updatedSong.title,
            '@album': updatedSong.album,
            '@dateOfRelease': (updatedSong.yearOfRelease == null)? null :updatedSong.yearOfRelease.toString()+"-01-01",
            '@bpm': updatedSong.bpm,
            '@lyrics': updatedSong.lyrics,
            '@sheetMusic': updatedSong.sheetMusic,
            '@mp3': updatedSong.mp3,
            '@length': length
          });
      if(results.isEmpty) {print("empty");return false;}
    } on Exception catch(e) {print(e.toString());return false;}
    pullSongs();
    return true;
  }

  Future<bool> deleteSong(int songId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteSongQuery, {'@id': songId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullSongs();
    return true;
  }


  //SETS
  Future<void> pullSets() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectSetsQuery, {'@userId': _id});
    _sets.clear();
    for (final row in results) {
      _sets.add(SetModel(id: row['sets']!['id'], name: row['sets']!['name'], userId: row['sets']!['users_id'], color: row['sets']!['color']));
      if(row[''] != null && row['']!['songs'] != null) {
        for (String sonstrId in row['']!['songs'].split(' ')) {
          int songId = int.parse(sonstrId);
          for (SongModel song in _songs) {
            if (song.id == songId) {
              _sets.last.songs.add(song);
            }
          }
        }
      }
    }
  }

  Future<bool> insertSet(String name, String color, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertSetQuery, {'@userId': userId, '@name': name, '@color': color});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullSets();
    return true;
  }

  Future<bool> updateSet(SetModel set) async {
    try {
      set.name ??= "nameless set";
      set.color ??= "#000000";
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, updateSetQuery, {'@id': set.id, '@name': set.name, '@color': set.color});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullSets();
    return true;
  }

  Future<bool> deleteSet(int setId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteSetQuery, {'@id': setId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullSets();
    return true;
  }

  Future<bool> insertSetElement(int setId, int songId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertSetElementQuery, {'@setId': setId, '@songId': songId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullSets();
    return true;
  }

  Future<bool> deleteSetElement(int setId, int songId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteSetElementQuery, {'@setId': setId, '@songId': songId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullSets();
    return true;
  }


  //PLAYLISTS
  Future<void> pullPlaylists() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectPlaylistsQuery, {'@userId': _id});
    _playlists.clear();
    for (final row in results) {
      _playlists.add(PlaylistModel(row['playlists']!['id'], row['playlists']!['users_id']));
      if(row[''] != null && row['']!['elements'] != null) {
        for (String elementStr in row['']!['elements'].split(' ')) {
          List<String> elementArr = elementStr.split('|');
          int id = int.parse(elementArr[0]);
          String type = elementArr[1];
          String played = elementArr[2];
          if(type == "song") {
            for (SongModel song in _songs) {
              if (song.id == id) {
                _playlists.last.playlistElements.add(PlaylistElementModel.song(song: song, played: played == "true"));
              }
            }
          }
          if(type == "set") {
            for (SetModel set in _sets) {
              if (set.id == id) {
                _playlists.last.playlistElements.add(PlaylistElementModel.set(set: set, played: played == "true"));
              }
            }
          }
        }
      }
    }
  }

  Future<bool> insertPlaylistSong(int playlistId, int songId, bool played) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertPlaylistElementQuery, {'@playlistId': playlistId, '@songId' : songId, '@setsId' : null, '@played': (played? 'true': 'false')});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullPlaylists();
    return true;
  }

  Future<bool> insertPlaylistSet(int playlistId, int setId, bool played) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertPlaylistElementQuery, {'@playlistId': playlistId, '@songId' : null, '@setsId' : setId, '@played': (played? 'true': 'false')});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullPlaylists();
    return true;
  }

  Future<bool> deletePlaylistSong(int playlistId, int songId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deletePlaylistSongQuery, {'@playlistId': playlistId, '@songId': songId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullPlaylists();
    return true;
  }

  Future<bool> deletePlaylistSet(int playlistId, int setId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deletePlaylistSetQuery, {'@playlistId': playlistId, '@setId': setId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullPlaylists();
    return true;
  }


  //EVENTS
  Future<void> pullEvents() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectEventsQuery, {'@userId': _id});
    _events.clear();
    for (final row in results) {
      PlaylistModel? playlist;
      for(PlaylistModel pl in _playlists) {
        if(pl.id == row['events']!['playlist_id']) {
          playlist = pl;
          break;
        }
      }
      _events.add(EventModel(
          id: row['events']!['id'],
          name: row['events']!['name'],
          permissions: row['']!['permissions'],
          startDate: row['events']!['start_date'].toString(),
          endDate: row['events']!['end_date'].toString(),
          description: row['events']!['description'],
          playlist : playlist
      ));
    }
  }

  Future<bool> insertEvent(int? playListId, String name, String? startDate, String? endDate, String? description) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertEventQuery, {'@playListId' : playListId, '@name' : name, '@startDate' : startDate, '@endDate' : endDate, '@description' : description});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullEvents();
    return true;
  }

  Future<bool> updateEvent(EventModel event) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, updateEventQuery, {'@id': event.id, '@playListId' : (event.playlist == null)? null :event.playlist?.id, '@name' : event.name, '@startDate' : event.startDate, '@endDate' : event.endDate, '@description' : event.description});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullEvents();
    return true;
  }

  Future<bool> deleteEvent(int eventId) async {
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deleteEventQuery, {'@id': eventId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullEvents();
    return true;
  }

  Future<bool> insertPermission(int eventId, int permissionId, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, insertPermissionsQuery, {'@userId' : userId, '@eventId' : eventId, '@permissionId' : permissionId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullEvents();
    return true;
  }

  Future<bool> deletePermission(int eventId, int permissionId, [int? userId]) async {
    userId ??= _id;
    try {
      List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, deletePermissionsQuery, {'@userId' : userId, '@eventId' : eventId, '@permissionId' : permissionId});
      if(results.isEmpty) {return false;}
    } on Exception catch(e) {return false;}
    pullEvents();
    return true;
  }

  // UserModel.mock({id = "U1", eMail = "johnsmith@gmai.com", nick = "Smith"})
  //     : _id = id,
  //       _eMail = eMail,
  //       _nick = nick {
  //   _tags.add(TagModel(id: 1, name: "Slow", userId: 1, tagGroupId: 1));
  //   _tags.add(TagModel(id: 2, name: "Fast", userId: 1, tagGroupId: 1));
  //   _tags.add(TagModel(id: 3, name: "TODO", userId: 1));
  //   _songs.add(
  //       SongModel(id: 1, title: "Knocking on Heavens door", ownerId: 1, bpm: 80, duration: "5:15", yearOfRelease: 1976));
  //   _songs.add(SongModel(id: 2, title: "Mambo No. 5", ownerId: 1, bpm: 120, album: "Mambo, Mambo"));
  //   _songs.add(SongModel(id: 3, title: "Stairway to Heaven", ownerId: 1, duration: "6:15", yearOfRelease: 1969));
  //   _sets.add(SetModel(id: 1, userId: 1));
  //   _sets[0].songs.add(_songs[0]);
  //   _sets[0].songs.add(_songs[1]);
  //   _sets[0].songs.add(_songs[2]);
  //   _playlists.add(PlaylistModel(1, 1));
  //   _events.add(EventModel(id: 1, name: "New Year", permissions: "owner", playlist: _playlists.first));
  //   _tagGroups.add(TagGroupModel(id: 1, userId: 1, name: "Tempo"));
  // }

  List<AuthorModel> get authors => _authors;

  List<PlaylistModel> get playlists => _playlists;

  List<TagGroupModel> get tagGroups => _tagGroups;

  List<TagModel> get tags => _tags;

  List<SetModel> get sets => _sets;

  List<SongModel> get songs => _songs;

  List<EventModel> get events => _events;

  String get nick => _nick;

  String get eMail => _eMail;

  int get id => _id;
}
