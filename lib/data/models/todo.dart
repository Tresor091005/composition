// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  String? id;
  String? description;
  String? title;
  DateTime? begined_at;
  DateTime? finished_at;
  DateTime? deadline_at;
  String? user_id;
  String? priority;
  DateTime? created_at;
  DateTime? updated_at;
  User? user;

  Todo({
    this.id,
    this.description,
    this.title,
    this.begined_at,
    this.finished_at,
    this.deadline_at,
    this.user_id,
    this.priority,
    this.created_at,
    this.updated_at,
    this.user,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        description: json["description"],
        title: json["title"],
        begined_at: json["begined_at"] == null
            ? null
            : DateTime.parse(json["begined_at"]),
        deadline_at: json["deadline_at"] == null
            ? null
            : DateTime.parse(json["deadline_at"]),
        finished_at: json["finished_at"] == null
            ? null
            : DateTime.parse(json["finished_at"]),
        priority: json["priority"],
        user_id: json["user_id"],
        created_at: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updated_at: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "title": title,
        "begined_at": begined_at?.toIso8601String(),
        "finished_at": finished_at?.toIso8601String(),
        "deadline_at": deadline_at?.toIso8601String(),
        "priority": priority,
        "user_id": user_id,
        "created_at": created_at?.toIso8601String(),
        "updated_at": updated_at?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? email;
  String? fullname;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.email,
    this.fullname,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        fullname: json["fullname"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "fullname": fullname,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
