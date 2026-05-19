# 📱 Posts App

A Flutter mobile application built as part of a technical internship task.  
Demonstrates Clean Architecture, BLoC state management, Hive local storage,  
offline-first caching, and a fully working mock backend.

---

## 🗂 Project Overview

**What the app does:**  
A posts management app where users can log in, browse a list of posts, view post details, and create new posts. All created posts are persisted locally and survive app restarts. The app works fully offline using Hive cache.

**Architecture used:** Clean Architecture with feature-based modular structure.

---

## 🏗 Architecture Explanation

The project is split into `core` (shared utilities) and `features` (auth, posts).  
Each feature has three layers:

- **Domain** — pure Dart. Contains `Entities` (plain data classes), abstract `Repository` interfaces, and `UseCases` (one action per class). No Flutter or third-party imports. This is the business logic core and the most testable layer.

- **Data** — implements the domain repository. Contains `Models` (entities + JSON parsing), `RemoteDatasource` (API or MockService calls), and `LocalDatasource` (Hive read/write). Converts raw data into domain entities.

- **Presentation** — Flutter widgets and BLoC. Dispatches events, reacts to states, renders UI. Zero business logic here.

This separation means you can swap the mock backend for a real API by changing one flag (`useMockBackend = false` in `app_constants.dart`) without touching a single widget or use case.

```
lib/
├── core/
│   ├── constants/       # App-wide strings, keys, config flag
│   ├── di/              # GetIt dependency injection container
│   ├── errors/          # Failure & Exception sealed classes
│   ├── mock/            # MockService + MockData (built-in backend)
│   ├── network/         # Dio client + NetworkInfo (connectivity)
│   ├── router/          # GoRouter with auth redirect guard
│   ├── theme/           # Light & dark MaterialTheme
│   ├── utils/           # HiveHelper (all local storage ops)
│   └── widgets/         # Shared: ErrorWidget, LoadingWidget, EmptyWidget
└── features/
    ├── auth/
    │   ├── data/         # UserModel, AuthLocalDS, AuthRemoteDS, RepoImpl
    │   ├── domain/       # UserEntity, AuthRepository, LoginUsecase, LogoutUsecase
    │   └── presentation/ # AuthBloc, SplashScreen, LoginScreen
    └── posts/
        ├── data/         # PostModel, PostsLocalDS, PostsRemoteDS, RepoImpl
        ├── domain/       # PostEntity, PostsRepository, 3 UseCases
        └── presentation/ # PostsBloc, ListScreen, DetailScreen, CreateScreen, PostCard
```

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK ≥ 3.0.0 — verify with `flutter --version`
- Android Studio / VS Code with Flutter & Dart plugins
- A connected device or emulator

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/MahmoudAlaa92/posts_app
cd posts_app

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters (if any)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run

# 5. Build release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Demo Login Credentials
```
Username: Mahmoud Alaa
Password: 12345678
```

---

## 📦 Libraries Used

| Library | Version | Why |
|---|---|---|
| `flutter_bloc` | ^8.1.6 | BLoC pattern — separates business logic from UI completely |
| `equatable` | ^2.0.5 | Value equality for BLoC states/events without boilerplate |
| `dio` | ^5.4.0 | HTTP client with interceptors, timeouts, error handling |
| `connectivity_plus` | ^5.0.2 | Detect network state for offline-first behavior |
| `hive_flutter` | ^1.1.0 | Fast NoSQL local storage — caches posts and persists created posts |
| `get_it` | ^7.6.7 | Service locator for dependency injection across all layers |
| `go_router` | ^13.2.0 | Declarative routing with auth redirect guard and path params |
| `dartz` | ^0.10.1 | `Either<Failure, T>` for clean, explicit error propagation |

---

## ✅ Features

| Feature | Status |
|---|---|
| Splash screen with auth redirect | ✅ |
| Login with form validation | ✅ |
| Posts list with search & pull-to-refresh | ✅ |
| Post detail screen | ✅ |
| Create post (persisted to Hive) | ✅ |
| Offline cache — works without internet | ✅ |
| Created posts survive app restarts | ✅ |
| Dark mode (system-aware) | ✅ |
| Loading / error / empty states | ✅ |
| Logout with confirmation | ✅ |

---

## 🏛 BLoC Data Flow

```
User Action (tap / submit)
        │
        ▼
  Widget dispatches Event
  e.g. FetchPostsRequested
        │
        ▼
  PostsBloc receives Event
  emits PostsLoading  ──────────────→  UI shows CircularProgressIndicator
        │
        ▼
  GetPostsUsecase.call()
        │
        ▼
  PostsRepositoryImpl
  ┌─── Online? ────┐
  │ YES            │ NO
  ▼                ▼
Remote DS      Local DS
(MockService)  (Hive cache)
  │                │
  └────────┬───────┘
           ▼
  emits PostsLoaded(posts)  ───────→  UI rebuilds with ListView
```

---

## 📡 API Reference (MockService & JSONPlaceholder-compatible)

Base URL when using real API: `https://dummyjson.com`

| Action | Method | Endpoint | Notes |
|---|---|---|---|
| Login | POST | `/auth/login` | Body: `{ username, password }` |
| Get all posts | GET | `/posts?limit=30` | Returns `{ posts: [...] }` |
| Get single post | GET | `/posts/{id}` | Returns post object |
| Create post | POST | `/posts/add` | Body: `{ title, body, userId }` |

To switch from mock to real API, open `lib/core/constants/app_constants.dart` and set:
```dart
static const bool useMockBackend = false;
```

---

## 🧪 Testing the Offline Cache

1. Open the app and go to the Posts screen — wait for posts to load
2. Create a new post
3. Enable **Airplane Mode** on your device/emulator
4. Force-close and reopen the app
5. All posts (including your created one) will load from Hive ✅

---

## 📋 Postman / API Test Notes

| Action | Method | URL | Example Body |
|---|---|---|---|
| Login | POST | `https://dummyjson.com/auth/login` | `{"username":"emilys","password":"emilyspass"}` |
| Get Posts | GET | `https://dummyjson.com/posts?limit=30` | — |
| Get Post | GET | `https://dummyjson.com/posts/1` | — |
| Create Post | POST | `https://dummyjson.com/posts/add` | `{"title":"Test","body":"Body text","userId":1}` |

**Login Response:**
```json
{
  "id": 1,
  "username": "Mahmoud Alaa",
  "email": "Mahmoud.Alaa@x.dummyjson.com",
  "token": "eyJhbGci..."
}
```

**Create Post Response:**
```json
{
  "id": 251,
  "title": "Test",
  "body": "Body text",
  "userId": 1
}
```

---

## 👤 Author

Built by **[Mahmoud Alaa]** as part of the UNITS Flutter Internship Technical Task.
