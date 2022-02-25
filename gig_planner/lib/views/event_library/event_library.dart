import 'package:flutter/material.dart';
import 'event.dart';
import '../playlist.dart';

final List<String> exampleTitles = ["Karnawał", "Jaś i Małgosia kwiecień", "Jan i Joanna"];

class EventLibrary extends StatefulWidget {
  final List<String> eventIds;
  const EventLibrary({required List<String> this.eventIds, Key? key}) : super(key: key);

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
            return EventTile(EventName: widget.eventIds[i]);
          }
        ,
      ),
    );
  }
}

class EventTile extends StatefulWidget {
  final String EventName;
  const EventTile({required this.EventName, Key? key}) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.EventName),
      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
      onTap: () {Navigator.push(
        context, MaterialPageRoute(
          builder:  (_) => Playlist(),
        )
      );},
    );
  }
}
