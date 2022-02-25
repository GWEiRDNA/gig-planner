import 'package:flutter/cupertino.dart';

class TagGroupModel{
  String id;
  String userId;
  String name;
  String? color;

  TagGroupModel({
    required this.id,
    required this.userId,
    required this.name,
    this.color
  });
}