import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/event_model.dart';

class CreateEvent extends StatefulWidget {
  final Controller ctl;
  EventModel? ev;
  CreateEvent({required this.ctl, this.ev, Key? key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String name = "";
  String? startDate = "";
  String? endDate = "";
  String? description = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.ev != null){
      name = widget.ev!.name;
      startDate = widget.ev!.startDate ?? "";
      endDate = widget.ev!.endDate ?? "";
      description = widget.ev!.description ?? "";
    }else{
      widget.ev = widget.ctl.createBlankEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event")
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  hintText: "Event name"
                ),
                onChanged: (text){
                  setState((){name=text;});
                }
              ),
              TextFormField(
                initialValue: startDate,
                decoration: const InputDecoration(
                    hintText: "HH:MM DD-MM-YYYY"
                ),
                  onChanged: (text){
                    setState((){startDate=text;});
                  }
              ),
              TextFormField(
                initialValue: endDate,
                decoration: const InputDecoration(
                    hintText: "HH:MM DD-MM-YYYY"
                ),
                  onChanged: (text){
                    setState((){endDate=text;});
                  }
              ),
              TextFormField(
                maxLines: 8,
                minLines: 4,
                initialValue: description,
                decoration: const InputDecoration(
                    hintText: "Description/additional info"
                ),
                  onChanged: (text){
                    setState((){description=text;});
                  }
              ),
              ElevatedButton(
                  onPressed: (){
                    EventModel updatedEv = EventModel(id: widget.ev!.id, name: name, permissions: widget.ev!.permissions, description: description, endDate: endDate, startDate: startDate);
                    widget.ctl.updateEvent(updatedEv);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.check),
              )
            ],
          ),
        ),
      ),
    );
  }
}
