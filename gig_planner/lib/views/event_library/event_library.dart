import 'package:flutter/material.dart';
import 'package:gig_planner_sketch/controllers/controller.dart';
import 'event.dart';
import '../playlist.dart';

final List<String> exampleTitles = ["Karnawał", "Jaś i Małgosia kwiecień", "Jan i Joanna"];

class EventLibrary extends StatefulWidget {
  final List<String> eventIds;
  final Controller ctl;
  const EventLibrary({required this.ctl, required List<String> this.eventIds, Key? key}) : super(key: key);

  @override
  State<EventLibrary> createState() => _EventLibraryState();
}

class _EventLibraryState extends State<EventLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        title: const Text("All Events"),
      ),
      body: ListView.builder(
          itemCount: widget.eventIds.length,
          itemBuilder: (context, i){
            return EventTile(ctl: widget.ctl, eventId: widget.eventIds[i]);
          }
        ,
      ),
    );
  }
}

class EventTile extends StatefulWidget {
  final String eventId;
  final Controller ctl;
  const EventTile({required this.ctl, required this.eventId, Key? key}) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.ctl.getEventName(widget.eventId)),
      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
      onTap: () {Navigator.push(
        context, MaterialPageRoute(
          builder:  (_) => Playlist(ctl: widget.ctl, eventId: widget.eventId),
        )
      );},
    );
  }
}
