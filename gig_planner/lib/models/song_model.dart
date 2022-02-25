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
  List<String>? tagIds;

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
}
