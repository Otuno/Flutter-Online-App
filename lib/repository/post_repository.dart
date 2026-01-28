import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:remote_demo/model/post.dart';

class PostRepository {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load posts: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('fetchPosts error: $e');
      rethrow;
    }
  }

  Future<Post> createPost(Post post) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/posts'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to create post: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('createPost error: $e');
      rethrow;
    }
  }
}
