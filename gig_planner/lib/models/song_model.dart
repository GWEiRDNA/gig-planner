import 'package:gig_planner_sketch/models/author_model.dart';
import 'package:gig_planner_sketch/models/tag_model.dart';

class SongModel {
  String id;
  String ownerId;
  String title;
  String? album;
  int? yearOfRelease;
  int? bpm;
  String? lyrics;
  String? sheetMusic;
  String? mp3;
  String? duration;
  String? authorIds;
  List<TagModel> tags;

  SongModel({
    required this.id,
    required this.title,
    required this.ownerId,
    this.album,
    this.yearOfRelease,
    this.bpm,
    this.lyrics,
    this.mp3,
    this.duration,
    this.authorIds,
    List<TagModel>? preTags,
  }) : tags = preTags ?? [];

  AuthorModel getAuthors(){
    return AuthorModel("000", "Unknown Author", "U1");
  }
}
