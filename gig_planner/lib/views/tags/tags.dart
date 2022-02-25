import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  const Tags({Key? key}) : super(key: key);

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your tags"),
      ),
      body: Column(
        children: [
          TagGroup(),
          TagGroup(),
        ],
      ),
    );
  }
}

class TagGroup extends StatelessWidget {
  const TagGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("Szybkość utworu"),
            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
            leading: IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
          ),
          Wrap(
            spacing: 5,
            children: [
              Chip(label: Text("Wolny")),
              Chip(label: Text("Szybki")),
              Chip(label: Text("Bardzo szybki")),
              Chip(label: Text("Bardzo Wolny")),
              Chip(label: Text("Szybki ale nie za bardzo")),
              Chip(label: Text("Średnio szybki")),
              Chip(label: Text("Trochę Wolny")),
              Chip(label: Text("Gibki")),
              Chip(label: Text("Bardzo szybki")),
              Chip(label: Text("Wolny tak jakby")),
              Chip(label: Text("Szybki inaczej")),
              Chip(label: Text("+ New Tag")),
            ],
          )
        ]
      ),
    );
  }
}
