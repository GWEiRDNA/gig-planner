import 'song_model.dart';

class SetModel{
  int id;
  String? name;
  String? color;
  List<SongModel> songs = <SongModel>[];
  int userId;


  SetModel({
    required this.id,
    required this.userId,
    this.name,
    this.color,
  });
}