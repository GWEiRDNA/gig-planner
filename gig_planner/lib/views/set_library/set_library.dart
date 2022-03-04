import 'package:flutter/material.dart';
import '../../controllers/controller.dart';
import '../../models/set_model.dart';
import 'set.dart';

class SetLibrary extends StatefulWidget {
  final Controller ctl;
  List<SetModel> sets;
  SetLibrary({required Controller this.ctl, Key? key}) : sets = ctl.user.sets ,super(key: key);

  @override
  State<SetLibrary> createState() => _SetLibraryState();
}

class _SetLibraryState extends State<SetLibrary> {
  @override
  Widget build(BuildContext context) {
    List<SetModel> sets = widget.ctl.user.sets;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Library"),
        leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, i){
          return Set(ctl: widget.ctl, set: sets[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          widget.ctl.createSet();
          setState((){});
        },
        backgroundColor: Colors.blue,
      ),
    );
  }
}