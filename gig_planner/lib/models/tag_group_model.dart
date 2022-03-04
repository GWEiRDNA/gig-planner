import 'package:flutter/cupertino.dart';

class TagGroupModel{
  int id;
  int userId;
  String name;
  String? color;

  TagGroupModel({
    required this.id,
    required this.userId,
    required this.name,
    this.color
  });
}