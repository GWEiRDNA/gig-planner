import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import '../../models/event_model.dart';
import 'create_event.dart';
import 'event.dart';
import '../playlist.dart';

final List<String> exampleTitles = ["Karnawał", "Jaś i Małgosia kwiecień", "Jan i Joanna"];

class EventLibrary extends StatefulWidget {
  List<EventModel> events;
  final Controller ctl;
  EventLibrary({required this.ctl, Key? key}) : events = ctl.user.events, super(key: key);

  @override
  State<EventLibrary> createState() => _EventLibraryState();
}

class _EventLibraryState extends State<EventLibrary> {
  refresh(){
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: const Text("All Events"),
      ),
      body: ListView.builder(
        itemCount: widget.events.length,
        itemBuilder: (context, i) {
          return EventTile(ctl: widget.ctl, eventId: widget.events[i].id, notifyParent: refresh);
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => CreateEvent(ctl: widget.ctl)));
          }
      ),
    );
  }
}

class EventTile extends StatefulWidget {
  final String eventId;
  final Controller ctl;
  final Function() notifyParent;
  const EventTile({required this.ctl, required this.eventId, required this.notifyParent, Key? key}) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    String eventName = widget.ctl.getEventName(widget.eventId);

    return ListTile(
      title: Text(eventName),
      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
      onTap: () {
        if(widget.ctl.eventAvailable(widget.eventId)){
          Navigator.push(
              context, MaterialPageRoute(
            builder:  (_) => Playlist(ctl: widget.ctl, eventId: widget.eventId),
          )
          );
        }else{
          Scaffold.of(context).showSnackBar(const SnackBar(content: Text("You don't have access to this event anymore")));
          widget.notifyParent();
        }
      },
    );
  }
}
