import 'package:gig_planner_sketch/views/event_library/event.dart';
import 'package:gig_planner_sketch/views/song_library/song.dart';
import 'package:gig_planner_sketch/views/tags/tags_library.dart';
import 'package:postgres/postgres.dart';
import 'package:crypt/crypt.dart';
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

  static Future<UserModel?> login(PostgreSQLConnection connection, String email, String password) async {
    final String passwordHash = Crypt.sha256(password, salt: 'v9SferVS2DklThF0').toString();
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(connection, loginQuery, {'@email': email, '@passwordHash': passwordHash});
    if(results.isNotEmpty) {
      return UserModel(results[0]['users']!['id'], results[0]['users']!['email'], results[0]['users']!['name'], connection);
    } else {
      return null;
    }
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

  Future<void> pullTagsGroups() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectTagGroupsQuery, {'@userId': _id});
    _tagGroups.clear();
    for (final row in results) {
      _tagGroups.add(TagGroupModel(id: row['tag_groups']!['id'], name: row['tag_groups']!['name'], userId: row['tag_groups']!['users_id'], color: row['tag_groups']!['color']));
    }
  }

  Future<void> pullTags() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectTagsQuery, {'@userId': _id});
    _tags.clear();
    for (final row in results) {
      _tags.add(TagModel(id: row['tags']!['id'], name: row['tags']!['name'], userId: row['tags']!['users_id'], tagGroupId: row['tags']!['tag_groups_id']));
    }
  }

  Future<void> pullAuthors() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectAuthorsQuery, {'@userId': _id});
    //_authors.clear();
    for (final row in results) {
     // _authors.add(TagModel(id: row['tags']!['id'], name: row['tags']!['name'], userId: row['tags']!['users_id'], tagGroupId: row['tags']!['tag_groups_id']));
      print(row);
    }
  }

  Future<void> pullSongs() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectSongsQuery, {'@userId': _id});
    _songs.clear();

    for (final row in results) {
      List<int>? tagIds = [];
      if(row[''] != null && row['']!['tags'] != null) {
        for (String strId in row['']!['tags'].split(' ')) {
          tagIds.add(int.parse(strId));
        }
      }
      String? authorsIds;
      if(row[''] != null && row['']!['authors'] != null) {
        authorsIds = row['']!['authors'];
        // for (String strId in row['']!['authors'].split(' ')) {
        //   authorsIds.add(int.parse(strId));
        // }
      }
      _songs.add(SongModel(
        id: row['songs']!['id'],
        ownerId: row['songs']!['users_id'],
        title: row['songs']!['title'],
        album: row['songs']!['album'],
        bpm: row['songs']!['bpm'],
        lyrics: row['songs']!['lyrics'],
        mp3: row['songs']!['mp3'],
        duration: row['songs']!['length'],
        tagIds: tagIds,
        authorIds: authorsIds
      ));
    }
  }

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

  Future<void> pullEvents() async {
    List<Map<String, Map<String, dynamic>>> results = await executeQuery(_connection, selectEventsQuery, {'@userId': _id});
    _events.clear();
    for (final row in results) {
      _events.add(EventModel(
          id: row['events']!['id'],
          name: row['events']!['name'],
          permissions: row['']!['permissions'],
          startDate: row['events']!['start_date'].toString(),
          endDate: row['events']!['end_date'].toString(),
          description: row['events']!['description'],
          playlist : _playlists[0]
      ));
    }
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

  List<PlaylistModel> get playlists => _playlists;

  List<TagGroupModel> get tagGroups => _tagGroups;

  List<TagModel> get tags => _tags;

  List<SetModel> get sets => _sets;

  List<SongModel> get songs => _songs;

  List<EventModel> get events => _events;

  String get nick => _nick;

  String get eMail => _eMail;

  int get id => _id;

  List<AuthorModel> getAuthors(){
    List<AuthorModel> authors = <AuthorModel>[];
    authors.add(AuthorModel(1, "Billy Joel", 1));
    authors.add(AuthorModel(2, "Phil Collins", 1));
    authors.add(AuthorModel(3, "Billie Eilish", 1));
    authors.add(AuthorModel(4, "Michael Jackson", 1));
    authors.add(AuthorModel(5, "Guns & Roses", 1));
    return authors;
  }
}
