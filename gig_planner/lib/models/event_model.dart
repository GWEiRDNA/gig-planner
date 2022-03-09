import 'package:gig_planner_sketch/models/models.dart';

class EventModel {
  int _id;
  String _name;
  String _permissions; //From here you'll get users id
  String? _startDate;
  String? _endDate;
  String? _description;
  PlaylistModel? _playlist;

  EventModel({
    required int id,
    required String name,
    required String permissions,
    String? startDate,
    String? endDate,
    String? description,
    PlaylistModel? playlist,
  })  : _id = id,
        _name = name,
        _permissions = permissions,
        _startDate = startDate,
        _endDate = endDate,
        _description = description,
        _playlist = playlist;

  PlaylistModel? get playlist => _playlist;

  String? get description => _description;

  String? get endDate => _endDate;

  String? get startDate => _startDate;

  String get permissions => _permissions;

  String get name => _name;

  int get id => _id;
}
