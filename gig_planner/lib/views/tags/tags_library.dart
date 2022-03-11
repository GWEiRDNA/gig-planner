import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';
import 'package:gig_planner_sketch/views/tags/new_tag_group.dart';

import '../../controllers/controller.dart';

class Tags extends StatefulWidget {
  Controller ctl;
  List<TagGroupModel> tagGroups;
  List<TagModel> tags;
  Tags({required this.ctl, Key? key})
      : tagGroups = ctl.user.tagGroups,
        tags = ctl.user.tags,
        super(key: key);

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
        itemCount: widget.tagGroups.length + 1,
        itemBuilder: (context, i) {
          if (i >= widget.tagGroups.length) {
            return TagGroup.others(ctl: widget.ctl);
          }
          return TagGroup.specific(
              ctl: widget.ctl, tagGroup: widget.tagGroups[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => TagGroupForm(ctl: widget.ctl)));
        },
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class TagGroup extends StatefulWidget {
  Controller ctl;
  String title;
  TagGroupModel? tagGroup;
  List<TagModel> tags = <TagModel>[];
  TagGroup.others({required this.ctl, Key? key})
      : title = "Others",
        super(key: key) {
    for (TagModel tag in ctl.user.tags) {
      if (tag.tagGroupId == null) {
        tags.add(tag);
      }
    }
  }
  TagGroup.specific({required this.ctl, required this.tagGroup, Key? key})
      : title = tagGroup!.name,
        super(key: key) {
    for (TagModel tag in ctl.user.tags) {
      if (tag.tagGroupId == tagGroup!.id) {
        tags.add(tag);
      }
    }
  }

  @override
  State<TagGroup> createState() => _TagGroupState();
}

class _TagGroupState extends State<TagGroup> {
  String newTagName = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
              title: Text(widget.title),
              trailing: (() {
                if (widget.tagGroup != null) {
                  return IconButton(
                      onPressed: () {
                        widget.ctl
                            .deleteTagGroup(widget.tagGroup as TagGroupModel);
                      },
                      icon: const Icon(Icons.delete));
                }
              }()),
              leading: (() {
                if (widget.tagGroup != null) {
                  return IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TagGroupForm.edit(
                                    ctl: widget.ctl,
                                    tagGroup: widget.tagGroup)));
                      },
                      icon: const Icon(Icons.edit));
                }
              }())),
          ListTile(
            title: TextFormField(
                decoration: const InputDecoration(hintText: "Add new tag"),
                onChanged: (input) {
                  setState(() {
                    newTagName = input;
                  });
                },
                validator: (value) {
                  //TODO
                  String? s = widget.ctl.checkTagName(value);
                  if (s != null) {
                    return s; //Print error
                  } else {
                    return null;
                  }
                }),
            trailing: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.tagGroup != null) {
                      widget.ctl.createNewTag(newTagName, widget.tagGroup!.id);
                    } else {
                      widget.ctl.createNewTag(newTagName, null);
                    }
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.add)),
          ),
          if (widget.tags.isNotEmpty)
            Wrap(
              spacing: 5,
              children: [
                for (TagModel tag in widget.tags)
                  Tag(ctl: widget.ctl, tag: tag),
              ],
            )
        ]),
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
      onDeleted: () {
        widget.ctl.deleteTag(widget.tag.id);
      },
      deleteIcon: const Icon(Icons.close),
    );
  }
}
