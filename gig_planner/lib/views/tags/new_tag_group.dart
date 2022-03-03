import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/models/models.dart';

import '../../controllers/controller.dart';

class TagGroupForm extends StatefulWidget {
  final Controller ctl;
  final isUpdated;
  TagGroupModel? tagGroup;
  TagGroupForm({required this.ctl, Key? key}) : isUpdated = false, super(key: key);
  TagGroupForm.edit({required this.ctl, required this.tagGroup, Key? key}) : isUpdated = true, super(key: key);

  @override
  _TagGroupFormState createState() => _TagGroupFormState();
}

class _TagGroupFormState extends State<TagGroupForm> {
  String? id;
  String name = "";
  String? color;

  @override
  void initState() {
    super.initState();
    if(widget.isUpdated){
      id = widget.tagGroup!.id;
      name = widget.tagGroup!.name;
    }else{
      name = "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title:
        widget.isUpdated ? const Text("Edit Tag Group") : const Text("Create new Tag Group")
      ),
      body: Form(
          child: ListTile(
            title: TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                hintText: "Tag Group Name"
              ),
              onChanged: (newName){
                setState((){
                  name = newName;
                });
              },
            ),
            trailing: IconButton(onPressed: (){
              if(widget.isUpdated){
                TagGroupModel newTagGroup = TagGroupModel(id: widget.tagGroup!.id, userId: widget.tagGroup!.userId, name: name);
                widget.ctl.updateTagGroup(newTagGroup);
              }else{
                widget.ctl.createNewTagGroup(name, null);
                //TODO: Colors
              }
              Navigator.pop(context);
            }, icon: const Icon(Icons.check)),
          )
      ),
    );
  }
}
