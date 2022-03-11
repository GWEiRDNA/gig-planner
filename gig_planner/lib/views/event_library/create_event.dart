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
  bool isUpdated = false;
  String name = "";
  String? startDate = "";
  String? endDate = "";
  String? description = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.ev != null){
      isUpdated = true;
      name = widget.ev!.name;
      startDate = widget.ev!.startDate ?? "";
      endDate = widget.ev!.endDate ?? "";
      description = widget.ev!.description ?? "";
    }else{
      widget.ev = widget.ctl.createBlankEvent();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event")
      ),
      body: Form(
        key: _formKey,
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
                },
                  validator: (value){
                    //TODO
                    String? s = widget.ctl.checkEventName(value);
                    if(s != null){
                      return s; //Print error
                    }else{
                      return null;
                    }
                  }
              ),
              TextFormField(
                initialValue: startDate,
                decoration: const InputDecoration(
                    hintText: "HH:MM DD-MM-YYYY"
                ),
                  onChanged: (text){
                    setState((){startDate=text;});
                  },
                  validator: (value){
                    //TODO
                    String? s = widget.ctl.checkEventStartDate(value);
                    if(s != null){
                      return s; //Print error
                    }else{
                      return null;
                    }
                  }
              ),
              TextFormField(
                initialValue: endDate,
                decoration: const InputDecoration(
                    hintText: "HH:MM DD-MM-YYYY"
                ),
                  onChanged: (text){
                    setState((){endDate=text;});
                  },
                  validator: (value){
                    //TODO
                    String? s = widget.ctl.checkEventEndDate(value);
                    if(s != null){
                      return s; //Print error
                    }else{
                      return null;
                    }
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
                  },

                  validator: (value){
                    //TODO
                    String? s = widget.ctl.checkEventDescription(value);
                    if(s != null){
                      return s; //Print error
                    }else{
                      return null;
                    }
                  }
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      EventModel updatedEv = EventModel(id: widget.ev!.id,
                          name: name,
                          permissions: widget.ev!.permissions,
                          description: description,
                          endDate: endDate,
                          startDate: startDate);
                      if (isUpdated) {
                        widget.ctl.updateEvent(updatedEv);
                      }
                      else {
                        widget.ctl.addEvent(updatedEv);
                      }
                      setState(() {});
                      Navigator.pop(context);
                    }
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
