import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:composition/data/dio_instance.dart';
import 'package:composition/data/models/post.dart';

class PostService {
  Dio api = configureDio();

  Future<Post> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('posts', data: data);

    return Post.fromJson(response.data);
  }

  Future<Post> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('posts/$id');

    return Post.fromJson(response.data);
  }

  Future<List<Post>> getAll() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('posts');

    return (response.data as List).map((e) => Post.fromJson(e)).toList();
  }
}
