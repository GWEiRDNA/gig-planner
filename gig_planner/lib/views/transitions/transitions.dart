import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/transition_model.dart';
import 'new_transition.dart';

class Transitions extends StatefulWidget {
  Controller ctl;
  List<TransitionModel> transitions;
  Transitions({required this.ctl, Key? key}) : transitions = ctl.getTransitions(), super(key: key);

  @override
  State<Transitions> createState() => _TransitionsState();
}

class _TransitionsState extends State<Transitions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transitions"),
      ),
      body: ListView.builder(
          itemCount: widget.transitions.length,
          itemBuilder: (context, i) {
            return Transition(ctl: widget.ctl, transition: widget.transitions[i]);
          }
      ),
      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => NewTransition(ctl: widget.ctl))
            );
          },
      ),
    );
  }
}

class Transition extends StatefulWidget {
  Controller ctl;
  TransitionModel transition;
  Transition({required this.ctl, required this.transition, Key? key}) : super(key: key);

  @override
  _TransitionState createState() => _TransitionState();
}

class _TransitionState extends State<Transition> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      leading: Text(widget.transition.power.toString()),
      title: Text(widget.transition.A.title),
      subtitle: Text(widget.transition.B.title),
    );
  }
}
