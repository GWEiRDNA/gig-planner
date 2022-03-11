import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';

import '../../controllers/controller.dart';

class TagGroupForm extends StatefulWidget {
  final Controller ctl;
  final isUpdated;
  TagGroupModel? tagGroup;
  TagGroupForm({required this.ctl, Key? key})
      : isUpdated = false,
        super(key: key);
  TagGroupForm.edit({required this.ctl, required this.tagGroup, Key? key})
      : isUpdated = true,
        super(key: key);

  @override
  _TagGroupFormState createState() => _TagGroupFormState();
}

class _TagGroupFormState extends State<TagGroupForm> {
  int? id;
  String name = "";
  String? color;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdated) {
      id = widget.tagGroup!.id;
      name = widget.tagGroup!.name;
    } else {
      name = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.isUpdated
              ? const Text("Edit Tag Group")
              : const Text("Create new Tag Group")),
      body: Form(
          key: _formKey,
          child: ListTile(
            title: TextFormField(
              initialValue: name,
              decoration: const InputDecoration(hintText: "Tag Group Name"),
              onChanged: (newName) {
                setState(() {
                  name = newName;
                });
              },
              validator: (value) {
                //TODO
                String? s = widget.ctl.checkTagGroupName(value);
                if (s != null) {
                  return s; //Print error
                } else {
                  return null;
                }
              },
            ),
            trailing: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.isUpdated) {
                      TagGroupModel newTagGroup = TagGroupModel(
                          id: widget.tagGroup!.id,
                          userId: widget.tagGroup!.userId,
                          name: name);
                      widget.ctl.updateTagGroup(newTagGroup);
                    } else {
                      widget.ctl.createNewTagGroup(name, null);
                      //TODO: Colors
                    }

                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check)),
          )),
    );
  }
}
