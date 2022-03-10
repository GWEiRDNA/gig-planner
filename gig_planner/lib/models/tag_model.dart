class TagModel{
  int id;
  String name;
  int? tagGroupId;
  int? userId;

  TagModel({
    required this.id,
    required this.name,
    required this.userId,
    this.tagGroupId,
  });
}