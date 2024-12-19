import 'package:composition/data/models/comment.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:composition/data/dio_instance.dart';
import 'package:composition/data/models/post.dart';

class CommentService {
  Dio api = configureDio();

  Future<Comment> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('comments', data: data);

    return Comment.fromJson(response.data);
  }

  Future<List<Comment>> getCommentsPost(String postId) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('comments?post_id=$postId');

    return (response.data as List).map((e) => Comment.fromJson(e)).toList();
  }
}
