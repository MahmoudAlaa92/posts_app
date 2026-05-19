class AppConstants {
  // API — swap baseUrl to switch between mock and real
  static const bool useMockBackend = true; // set false to use real API
  static const String baseUrl = 'https://dummyjson.com'; // used when useMockBackend = false

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Hive Boxes
  static const String postsBox = 'posts_box';
  static const String authBox = 'auth_box';

  // Hive Keys
  static const String tokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String cachedPostsKey = 'cached_posts';

  // Credentials (for demo hint in UI)
  static const String mockUsername = 'emilys';
  static const String mockPassword = 'emilyspass';
}