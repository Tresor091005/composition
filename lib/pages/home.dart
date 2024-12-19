import 'package:composition/data/models/todo.dart';
import 'package:composition/data/services/todo_service.dart';
import 'package:composition/pages/about.dart';
import 'package:composition/pages/list_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int total = 0;
  int b = 0;
  int c = 0;
  int f = 0;
  List<Todo> todos = [];

  loadTodos() async {
    try {
      TodoService todoService = TodoService();
      todos = await todoService.getAll();
      total = todos.length;
      for (Todo todo in todos) {
        if (todo.begined_at == null) {
          b += 1;
        } else if (todo.finished_at != null) {
          f += 1;
        } else {
          c += 1;
        }
      }
      setState(() {});
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    } finally {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiques"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Nbr total tâches : "),
                Text("$total"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Nbr total tâches non commencées : "),
                Text("$b"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Nbr total tâches en cours : "),
                Text("$c"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Nbr total tâches finis : "),
                Text("$f"),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListPage()));
                },
                child: Text(
                  "Liste des tâches",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
                child: Text(
                  "A propos",
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }
}
