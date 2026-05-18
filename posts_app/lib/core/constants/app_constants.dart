class AppConstants {
  // API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int connectTimeout = 15000; // ms
  static const int receiveTimeout = 15000;

  // Hive Boxes
  static const String postsBox = 'posts_box';
  static const String authBox = 'auth_box';

  // Hive Keys
  static const String tokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String cachedPostsKey = 'cached_posts';

  // Mock credentials
  static const String mockEmail = 'test@example.com';
  static const String mockPassword = 'password123';
  static const String mockToken = 'mock_jwt_token_xyz';

  // Misc
  static const int postsPerPage = 10;
}