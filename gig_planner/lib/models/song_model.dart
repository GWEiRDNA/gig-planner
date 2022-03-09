import 'package:gig_planner_sketch/models/author_model.dart';
import 'package:gig_planner_sketch/models/tag_model.dart';

class SongModel {
  int id;
  int ownerId;
  String title;
  String? album;
  int? yearOfRelease;
  double? bpm;
  String? lyrics;
  String? sheetMusic;
  String? mp3;
  String? duration;
  List<AuthorModel> authors;
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
    List<AuthorModel>? preAuthors,
    List<TagModel>? preTags,
  }) : tags = preTags ?? [], this.authors = preAuthors ?? [];

  AuthorModel getAuthors(){
    if(authors.isEmpty)
      return AuthorModel(0, "Unknown Author", 1);
    return authors[0];
  }
}