import 'package:flutter/material.dart';
import 'set.dart';

class SetLibrary extends StatelessWidget {
  const SetLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Library"),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(children: const [Set(), Set()]),
    );
  }
}