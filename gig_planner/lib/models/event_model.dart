import 'package:gig_planner_sketch/models/models.dart';

import 'user_model.dart';

class EventModel{
  String id;
  String name;
  String permissions; //From here you'll get users id
  String? startDate;
  String? endDate;
  String? description;
  PlaylistModel? playlist;

  EventModel({
    required this.id,
    required this.name,
    required this.permissions,
    this.startDate,
    this.endDate,
    this.description,
    this.playlist,
  });
}