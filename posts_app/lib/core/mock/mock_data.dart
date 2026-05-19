class MockData {
  // Auth
  static const mockUsername = 'Mahmoud Alaa';
  static const mockPassword = '12345678';
  static const mockToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpZCI6MSwidXNlcm5hbWUiOiJlbWlseXMiLCJpYXQiOjE3MDAwMDAwMDB9'
      '.mock_signature_xyz';

  // Posts
  static const List<Map<String, dynamic>> posts = [
    {
      'id': 1,
      'userId': 1,
      'title': 'Introduction to Clean Architecture in Flutter',
      'body':
          'Clean Architecture separates your app into layers: Domain, Data, and Presentation. '
          'Each layer has a single responsibility and depends only on the layer inside it. '
          'This makes your code testable, maintainable, and easy to scale over time.',
    },
    {
      'id': 2,
      'userId': 1,
      'title': 'Why BLoC is the Best State Management for Large Apps',
      'body':
          'BLoC (Business Logic Component) enforces a strict separation between UI and logic. '
          'Events trigger state changes, and widgets react to states — never directly to business logic. '
          'This makes debugging, testing, and scaling Flutter apps significantly easier.',
    },
    {
      'id': 3,
      'userId': 2,
      'title': 'Hive vs SharedPreferences: When to Use Which',
      'body':
          'SharedPreferences is best for simple key-value pairs like user settings. '
          'Hive is a fast NoSQL database ideal for caching lists, objects, and structured data. '
          'For offline post caching, Hive is the clear winner due to its speed and flexibility.',
    },
    {
      'id': 4,
      'userId': 2,
      'title': 'Dio vs http Package: A Practical Comparison',
      'body':
          'The http package is simple and lightweight, perfect for basic GET/POST requests. '
          'Dio shines when you need interceptors, request cancellation, file uploads, and timeout handling. '
          'For production apps, Dio is the standard choice among Flutter developers.',
    },
    {
      'id': 5,
      'userId': 3,
      'title': 'Getting Started with GoRouter in Flutter',
      'body':
          'GoRouter is Flutter\'s recommended declarative navigation library. '
          'It supports deep linking, path parameters, redirects, and nested navigation. '
          'Replacing Navigator 1.0 with GoRouter makes route management clean and predictable.',
    },
    {
      'id': 6,
      'userId': 3,
      'title': 'Dependency Injection with GetIt',
      'body':
          'GetIt is a lightweight service locator for Dart and Flutter. '
          'It allows you to register dependencies once and inject them anywhere in your app. '
          'Combined with Clean Architecture, GetIt keeps your layers properly decoupled.',
    },
    {
      'id': 7,
      'userId': 1,
      'title': 'Flutter Dark Mode: System-Aware Theming',
      'body':
          'Flutter makes dark mode easy with ThemeMode.system. '
          'Define a lightTheme and a darkTheme in MaterialApp.router, and Flutter automatically '
          'switches based on the device system setting. Users appreciate apps that respect their preference.',
    },
    {
      'id': 8,
      'userId': 4,
      'title': 'Offline-First Apps: Caching Strategies',
      'body':
          'A great offline-first strategy: always try the network first, cache on success, '
          'and fall back to cache when offline. This gives users a seamless experience '
          'regardless of connectivity. Hive makes this pattern simple and fast.',
    },
    {
      'id': 9,
      'userId': 4,
      'title': 'Form Validation Best Practices in Flutter',
      'body':
          'Always use a GlobalKey<FormState> with the Form widget. '
          'Validate on submit, not on every keystroke, to avoid overwhelming the user. '
          'Provide clear, actionable error messages that help users correct their input.',
    },
    {
      'id': 10,
      'userId': 2,
      'title': 'Understanding Either Type from the Dartz Package',
      'body':
          'Either<Failure, Success> is a functional programming concept for clean error handling. '
          'Left holds the failure case, Right holds the success. This eliminates try-catch '
          'scattered across your app and makes the happy path and error path explicit.',
    },
    {
      'id': 11,
      'userId': 5,
      'title': 'Writing Clean Dart Code: Tips & Patterns',
      'body':
          'Use final by default, avoid late unless necessary, and prefer const constructors. '
          'Keep functions small and focused. Name variables and methods clearly — '
          'good code reads like a story, not a puzzle.',
    },
    {
      'id': 12,
      'userId': 5,
      'title': 'Flutter Performance: Avoiding Unnecessary Rebuilds',
      'body':
          'Use const widgets wherever possible to avoid rebuilds. '
          'Prefer BlocBuilder with buildWhen to limit rebuild scope. '
          'Profile with Flutter DevTools to spot jank before it becomes a problem.',
    },
    {
      'id': 13,
      'userId': 3,
      'title': 'Unit Testing BLoC in Flutter',
      'body':
          'The bloc_test package makes testing BLoC a breeze. '
          'Use blocTest() to declare the event, expected states, and verify them. '
          'Mock your repository with Mocktail or Mockito for full isolation.',
    },
    {
      'id': 14,
      'userId': 6,
      'title': 'Equatable: Stop Writing Boilerplate Equality',
      'body':
          'Equatable overrides == and hashCode automatically based on the props you define. '
          'This is critical for BLoC to detect state changes correctly. '
          'Without Equatable, two identical state objects may be treated as different.',
    },
    {
      'id': 15,
      'userId': 6,
      'title': 'RESTful API Design Principles Every Developer Should Know',
      'body':
          'Use nouns for resource names, HTTP verbs for actions, and proper status codes. '
          'GET /posts fetches all posts. POST /posts creates one. GET /posts/1 fetches one. '
          'Consistent, predictable APIs make integration faster and less error-prone.',
    },
    {
      'id': 16,
      'userId': 1,
      'title': 'Splash Screen & Auth Redirect Pattern',
      'body':
          'A splash screen gives you a moment to check auth state before deciding where to route. '
          'Check the stored token in Hive, then redirect to home or login accordingly. '
          'Animate the splash for a polished first impression.',
    },
    {
      'id': 17,
      'userId': 7,
      'title': 'Pull-to-Refresh: A UX Must-Have',
      'body':
          'RefreshIndicator is the Flutter way to implement pull-to-refresh. '
          'On refresh, dispatch a new fetch event to your BLoC. '
          'This pattern keeps users in control of their data freshness.',
    },
    {
      'id': 18,
      'userId': 7,
      'title': 'Search Functionality: Filter vs API Query',
      'body':
          'For small datasets, client-side filtering is fast and avoids extra API calls. '
          'For large datasets, debounce user input and query the API. '
          'Always show the result count so users know their filter is working.',
    },
    {
      'id': 19,
      'userId': 2,
      'title': 'Error States Done Right',
      'body':
          'Every screen should handle three states: loading, success, and error. '
          'Always provide a Retry button on error screens so users are never stuck. '
          'Show empty states with helpful messages, not just a blank screen.',
    },
    {
      'id': 20,
      'userId': 8,
      'title': 'CI/CD for Flutter with GitHub Actions',
      'body':
          'A basic GitHub Actions workflow can run flutter analyze, flutter test, '
          'and flutter build apk on every push. This catches regressions early '
          'and gives reviewers confidence in your code quality.',
    },
  ];
}