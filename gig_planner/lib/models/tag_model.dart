class TagModel{
  String id;
  String name;
  String? tagGroupId;
  String? userId;

  TagModel({
    required this.id,
    required this.name,
    required this.userId,
    this.tagGroupId,
  });
}