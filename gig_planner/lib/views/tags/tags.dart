import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';

import '../../controllers/controller.dart';

class Tags extends StatefulWidget {
  Controller ctl;
  List<TagGroupModel> tagGroups;
  List<TagModel> tags;
  Tags({required this.ctl, Key? key}) : tagGroups = ctl.user.tagGroups, tags = ctl.user.tags, super(key: key);

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your tags"),
      ),
      body: ListView.builder(
        itemCount: widget.tags.any((tag) => tag.tagGroupId == null) ? widget.tagGroups.length + 1 : widget.tagGroups.length,
        itemBuilder: (context, i) {
          if(i >= widget.tagGroups.length){
            return TagGroup.others(ctl: widget.ctl);
          }
          return TagGroup.specific(ctl: widget.ctl, tagGroup: widget.tagGroups[i]);
        },
      )
    );
  }
}

class TagGroup extends StatefulWidget {
  Controller ctl;
  String title;
  List<TagModel> tags = <TagModel>[];
  TagGroup.others({required this.ctl, Key? key}) : title = "Others", super(key: key){
    for(TagModel tag in ctl.user.tags){
      if(tag.tagGroupId == null){
        tags.add(tag);
      }
    }
  }
  TagGroup.specific({required this.ctl, required TagGroupModel tagGroup, Key? key}) : title = tagGroup.name ,super(key: key){
    for(TagModel tag in ctl.user.tags){
      if(tag.tagGroupId == tagGroup.id){
        tags.add(tag);
      }
    }
  }

  @override
  State<TagGroup> createState() => _TagGroupState();
}

class _TagGroupState extends State<TagGroup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.title),
            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
            leading: IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
          ),
          Wrap(
            spacing: 5,
            children:[
                  for(TagModel tag in widget.tags)
                    Tag(ctl: widget.ctl, tag: tag),
                ]
            ,
          )
        ]
      ),
    );
  }
}

class Tag extends StatefulWidget {
  Controller ctl;
  TagModel tag;
  Tag({required this.ctl, required this.tag, Key? key}) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(widget.tag.name),
      onDeleted: () {},
      deleteIcon: const Icon(Icons.close),
    );
  }
}
