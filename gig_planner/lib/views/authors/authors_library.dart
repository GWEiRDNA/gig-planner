import 'package:flutter/material.dart';
import '../../controllers/controller.dart';
import '../../models/author_model.dart';

class AuthorsLibrary extends StatefulWidget {
  final Controller ctl;
  const AuthorsLibrary({required this.ctl, Key? key}) : super(key: key);

  @override
  _AuthorsLibraryState createState() => _AuthorsLibraryState();
}

class _AuthorsLibraryState extends State<AuthorsLibrary> {
  List<AuthorModel> authors = <AuthorModel>[];
  String newAuthorName = "";

  @override
  void initState() {
    super.initState();
    authors = widget.ctl.user.authors;
  }

  final _formKey = GlobalKey<FormState>();

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    authors = widget.ctl.user.authors;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your authors"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Add new Author",
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (newAuthorName != "") {
                          if(_formKey.currentState!.validate()) {
                            widget.ctl.crateAuthor(newAuthorName);
                          }
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.add),
                    )),
                onChanged: (text) {
                  newAuthorName = text;
                },
                validator: (value){
                  //TODO
                  String? s = widget.ctl.checkAuthorName(value);
                  if(s != null){
                    return s; //Print error
                  }else{
                    return null;
                  }
                },
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: authors.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(authors[i].name),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          widget.ctl.deleteAuthor(authors[i]);
                          setState(() {});
                        }),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                children: [
                                  TextFormField(
                                    initialValue: authors[i].name,
                                    onChanged: (text) {
                                      authors[i].name = text;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.check),
                                        onPressed: () {
                                          widget.ctl.updateAuthor(
                                              authors[i], authors[i].name);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ));
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }
}
