import 'dart:math';
import '../errors/exceptions.dart';
import 'mock_data.dart';

class MockService {
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal();

  final _random = Random();

  // Tracks created posts so they appear in the list during the session
  final List<Map<String, dynamic>> _createdPosts = [];
  int _nextId = 201;

  /// Simulates network latency between [min] and [max] milliseconds.
  Future<void> _simulateLatency({int min = 400, int max = 900}) async {
    final ms = min + _random.nextInt(max - min);
    await Future.delayed(Duration(milliseconds: ms));
  }

  // Auth 

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await _simulateLatency(min: 600, max: 1200);

    if (username == MockData.mockUsername &&
        password == MockData.mockPassword) {
      return {
        'id': 1,
        'username': MockData.mockUsername,
        'email': 'emily.smith@example.com',
        'firstName': 'Emily',
        'lastName': 'Smith',
        'token': MockData.mockToken,
        'refreshToken': 'mock_refresh_token_abc',
      };
    }

    throw const AuthException(message: 'Invalid username or password');
  }

  // Posts 

  Future<List<Map<String, dynamic>>> getPosts() async {
    await _simulateLatency();
    // Merge static posts + any posts created this session
    return [...MockData.posts, ..._createdPosts];
  }

  Future<Map<String, dynamic>> getPost(int id) async {
    await _simulateLatency(min: 300, max: 700);

    // Check session-created posts first
    final sessionPost = _createdPosts.where((p) => p['id'] == id).firstOrNull;
    if (sessionPost != null) return sessionPost;

    final post = MockData.posts.where((p) => p['id'] == id).firstOrNull;
    if (post == null) {
      throw ServerException(message: 'Post with id $id not found');
    }
    return post;
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    await _simulateLatency(min: 500, max: 1000);

    final newPost = {
      'id': _nextId++,
      'userId': userId,
      'title': title,
      'body': body,
    };

    _createdPosts.add(newPost); // Persist in session
    return newPost;
  }
}