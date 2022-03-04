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
  int? duration;
  String? authorIds;
  List<int>? tagIds;

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
    this.tagIds,
  });

  String getAuthors(){
    return "Unknown Author";
  }
}
