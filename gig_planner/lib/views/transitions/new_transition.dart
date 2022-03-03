import 'package:flutter/material.dart';

import '../../controllers/controller.dart';

class NewTransition extends StatefulWidget {
  final Controller ctl;
  const NewTransition({required this.ctl, Key? key}) : super(key: key);

  @override
  _NewTransitionState createState() => _NewTransitionState();
}

class _NewTransitionState extends State<NewTransition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new Transition"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: (){}, child: const Text("Select Song A")),
            TextButton(onPressed: (){}, child: const Text("Select Song B")),
            IconButton(onPressed: (){}, icon: const Icon(Icons.check)),
          ],
        ),
      ),
    );
  }
}
