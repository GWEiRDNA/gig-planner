import 'package:flutter/material.dart';

class Transitions extends StatelessWidget {
  const Transitions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transitions"),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, i) {
            return Transition();
          }
      )
    );
  }
}

class Transition extends StatefulWidget {
  const Transition({Key? key}) : super(key: key);

  @override
  _TransitionState createState() => _TransitionState();
}

class _TransitionState extends State<Transition> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      leading: Text("54"),
      title: Text("Song A"),
      subtitle: Text("Song B"),
    );
  }
}
