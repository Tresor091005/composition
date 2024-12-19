import 'package:composition/data/models/todo.dart';
import 'package:composition/data/services/comment_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/models/comment.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({super.key, required this.todo});

  final Todo todo;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.todo.title!,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                title: Text("ID"),
                subtitle: Text(widget.todo.id!),
              ),
              ListTile(
                title: Text("Titre"),
                subtitle: Text(widget.todo.title!),
              ),
              ListTile(
                title: Text("Description"),
                subtitle: Text(widget.todo.description!),
              ),
              ListTile(
                title: Text("Priorité"),
                subtitle: Text(widget.todo.priority!),
              ),
              widget.todo.begined_at == null
                  ? SizedBox()
                  : ListTile(
                      title: Text("Début"),
                      subtitle: Text("${widget.todo.begined_at!}"),
                    ),
              widget.todo.finished_at == null
                  ? SizedBox()
                  : ListTile(
                      title: Text("Fin"),
                      subtitle: Text("${widget.todo.finished_at!}"),
                    ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
