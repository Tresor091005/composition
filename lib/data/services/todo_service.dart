import 'package:composition/data/models/todo.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:composition/data/dio_instance.dart';

class TodoService {
  Dio api = configureDio();

  Future<Todo> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('todos', data: data);

    return Todo.fromJson(response.data);
  }

  Future<Todo> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('todos/$id');

    return Todo.fromJson(response.data);
  }

  Future<List<Todo>> getAll() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('todos');

    return (response.data as List).map((e) => Todo.fromJson(e)).toList();
  }

  Future<Todo> update(String id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.patch('todos/${id}', data: data);

    return Todo.fromJson(response.data);
  }
}
