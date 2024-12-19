import 'package:composition/data/models/todo.dart';
import 'package:composition/data/services/post_service.dart';
import 'package:composition/data/services/todo_service.dart';
import 'package:composition/pages/create_page.dart';
import 'package:composition/pages/details_page.dart';
import 'package:composition/pages/modify_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../data/models/post.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Todo> todos = [];
  TodoService todoService = TodoService();

  loadTodos() async {
    try {
      todos = await todoService.getAll();
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
        title: Text(
          "Liste des todos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    todos[index].title!,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    todos[index].description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => DetailsPage(
                    //           post: todos[index],
                    //         )));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    todos[index].begined_at == null
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ModifyPage(
                                        todo: todos[index],
                                      )));
                            },
                            child: const Text('Modifier'),
                          )
                        : SizedBox(),
                    const SizedBox(
                      width: 8,
                    ),
                    todos[index].begined_at == null
                        ? TextButton(
                            onPressed: () async {
                              await beginTodo(todos[index].id);
                            },
                            child: const Text('Commencer'),
                          )
                        : SizedBox(),
                    const SizedBox(
                      width: 8,
                    ),
                    todos[index].begined_at != null &&
                            todos[index].finished_at == null
                        ? TextButton(
                            onPressed: () async {
                              await finishTodo(todos[index].id);
                            },
                            child: const Text('Finir'))
                        : SizedBox(),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                    todo: todos[index],
                                  )));
                        },
                        child: const Text('Détail')),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreatePage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  beginTodo(id) async {
    try {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      await todoService.update(id, {"begined_at": formatter.format(now)});
      setState(() {});
      Fluttertoast.showToast(msg: "Lancement");
      loadTodos();
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
    } finally {}
  }

  finishTodo(id) async {
    try {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      await todoService.update(id, {"finished_at": formatter.format(now)});
      setState(() {});
      Fluttertoast.showToast(msg: "Fin");
      loadTodos();
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
    } finally {}
  }
}
