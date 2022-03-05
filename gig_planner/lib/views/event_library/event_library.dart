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
    widget.events = widget.ctl.user.events;
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
          return EventTile(ctl: widget.ctl, event: widget.events[i], notifyParent: refresh);
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
  final EventModel event;
  final Controller ctl;
  final Function() notifyParent;
  const EventTile({required this.ctl, required this.event, required this.notifyParent, Key? key}) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    String eventName = widget.event.name;

    return ListTile(
      title: Text(eventName),
      trailing: IconButton(onPressed: (){
        widget.ctl.deleteEvent(widget.event);
      }, icon: const Icon(Icons.delete)),
      onLongPress: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateEvent(ctl: widget.ctl, ev: widget.event,))
        );
      },
      onTap: () {
        if(widget.ctl.eventAvailable(widget.event.id)){
          Navigator.push(
              context, MaterialPageRoute(
            builder:  (_) => Playlist(ctl: widget.ctl, eventId: widget.event.id),
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
