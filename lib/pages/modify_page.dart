import 'package:composition/data/models/todo.dart';
import 'package:composition/data/services/post_service.dart';
import 'package:composition/data/services/todo_service.dart';
import 'package:composition/pages/list_page.dart';
import 'package:composition/pages/signup_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ModifyPage extends StatefulWidget {
  const ModifyPage({super.key, required this.todo});

  final Todo todo;

  @override
  State<ModifyPage> createState() => _ModifyPgeState();
}

class _ModifyPgeState extends State<ModifyPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;
  PostService postService = PostService();

  updateTodo() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> data = {
        'title': titleController.text,
        'description': descriptionController.text,
      };

      TodoService todoService = TodoService();
      await todoService.update(widget.todo.id!, data);

      titleController.text = "";
      descriptionController.text = "";

      Fluttertoast.showToast(msg: "Todo modifié avec succès");

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => ListPage()));
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "${e.message}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.todo.title!;
    descriptionController.text = widget.todo.description!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modifier une todo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Modifier une todo",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Titre"),
                        validator: (String? value) {
                          return value == null || value == ""
                              ? "Ce champ est obligatoire"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: 5,
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Description"),
                        validator: (String? value) {
                          return value == null || value == ""
                              ? "Ce champ est obligatoire"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await updateTodo();
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "Valider",
                                  style: TextStyle(fontSize: 20),
                                ))
                    ],
                  )),
            ],
          )),
    );
  }
}
