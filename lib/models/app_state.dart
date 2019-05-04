import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  bool authorized;
  FirebaseUser user;

  // Constructor
  AppState({
    this.isLoading = false,
    this.authorized = false,
    this.user,
  });

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
} 