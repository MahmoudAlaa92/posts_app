import '../errors/exceptions.dart';
import '../utils/hive_helper.dart';
import 'mock_data.dart';

/// Simulates a real backend API with realistic latency.
/// Created posts are now persisted to Hive — they survive app restarts.
class MockService {
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal();

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await _delay(600, 1200);

    if (username == MockData.mockUsername &&
        password == MockData.mockPassword) {
      return {
        'id': 1,
        'username': MockData.mockUsername,
        'email': 'Mahmoud.Alaa@example.com',
        'firstName': 'Mahmoud',
        'lastName': 'Alaa',
        'token': MockData.mockToken,
      };
    }

    throw const AuthException(message: 'Invalid username or password');
  }

  // ─── Posts ────────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPosts() async {
    await _delay(400, 900);

    // Load persisted created posts from Hive
    final created = HiveHelper.getCreatedPosts();

    // Merge: static mock data + user-created posts
    return [...MockData.posts, ...created];
  }

  Future<Map<String, dynamic>> getPost(int id) async {
    await _delay(300, 700);

    // Check persisted created posts first
    final created = HiveHelper.getCreatedPosts();
    final fromCreated = created.where((p) => p['id'] == id).firstOrNull;
    if (fromCreated != null) return fromCreated;

    // Check static mock data
    final fromStatic =
        MockData.posts.where((p) => p['id'] == id).firstOrNull;
    if (fromStatic != null) return fromStatic;

    throw ServerException(message: 'Post with id $id not found');
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    await _delay(500, 1000);

    // Generate a unique ID that won't collide with static posts (which go up to 20)
    final existing = HiveHelper.getCreatedPosts();
    final nextId = existing.isEmpty
        ? 201
        : (existing.map((p) => p['id'] as int).reduce(
                (a, b) => a > b ? a : b) +
            1);

    final newPost = {
      'id': nextId,
      'userId': userId,
      'title': title,
      'body': body,
    };

    // ✅ Persist to Hive — survives app restarts
    await HiveHelper.saveCreatedPost(newPost);

    return newPost;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _delay(int minMs, int maxMs) async {
    final ms = minMs +
        (DateTime.now().millisecondsSinceEpoch % (maxMs - minMs));
    await Future.delayed(Duration(milliseconds: ms));
  }
}