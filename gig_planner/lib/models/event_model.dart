import 'package:gig_planner_sketch/models/models.dart';

class EventModel {
  int _id;
  String _name;
  String _permissions;
  String? _startDate;
  String? _endDate;
  String? _description;
  PlaylistModel? _playlist;
  List<String>? _shared; //shared users

  EventModel({
    required int id,
    required String name,
    required String permissions,
    String? startDate,
    String? endDate,
    String? description,
    PlaylistModel? playlist,
    List<String>? shared,
  })  : _id = id,
        _name = name,
        _permissions = permissions,
        _startDate = startDate,
        _endDate = endDate,
        _description = description,
        _playlist = playlist,
        _shared = shared;

  PlaylistModel? get playlist => _playlist;

  List<String>? get shared => _shared;

  set playlist(PlaylistModel? value) {
    _playlist = value;
  }

  String? get description => _description;

  String? get endDate => _endDate;

  String? get startDate => _startDate;

  String get permissions => _permissions;

  String get name => _name;

  int get id => _id;
}
