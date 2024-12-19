import 'package:composition/data/services/post_service.dart';
import 'package:composition/data/services/todo_service.dart';
import 'package:composition/pages/home.dart';
import 'package:composition/pages/list_page.dart';
import 'package:composition/pages/signup_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final prioriteController = TextEditingController();
  bool isLoading = false;
  PostService postService = PostService();

  createTodo() async {
    setState(() {
      isLoading = true;
    });
    try {
      DateTime now = DateTime(2025, 01, 01);
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      Map<String, dynamic> data = {
        'title': titleController.text,
        'description': descriptionController.text,
        'priority': prioriteController.text,
        'deadline_at': formatter.format(now)
      };

      TodoService todoService = TodoService();
      await todoService.create(data);

      prioriteController.text = "";
      titleController.text = "";
      descriptionController.text = "";

      Fluttertoast.showToast(msg: "Todo créé avec succès");

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ajouter une todo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Ajouter une todo",
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
                      TextFormField(
                        controller: prioriteController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Priorité"),
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
                              await createTodo();
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
