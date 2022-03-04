import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/controller.dart';

class CreateEvent extends StatefulWidget {
  final Controller ctl;
  const CreateEvent({required this.ctl, Key? key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String name = "";
  String? startDate = "";
  String? endDate = "";
  String? description = "";

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
                    widget.ctl.createEvent();
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
