import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../models/author_model.dart';

class SelectAuthor extends StatelessWidget {
  final Controller ctl;
  List<AuthorModel> authors;
  Function refreshCaller;
  SelectAuthor({required this.ctl, required this.refreshCaller, Key? key}) : authors = ctl.user.authors, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select author"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: authors.length,
          itemBuilder: (context, i) => ListTile(
        title: Text(authors[i].name),
        onTap: (){
          refreshCaller(authors[i]);
          Navigator.pop(context);
        },
      ))
    );
  }
}
