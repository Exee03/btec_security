import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    updateUserData(firebaseUser);
    return firebaseUser;
  }

  Future<void> signInWithCredentials(String email, String password) async {
    FirebaseUser firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    updateUserData(firebaseUser);
    return firebaseUser;
  }

  Future<void> signUp({String email, String password}) async {
    FirebaseUser firebaseUser =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    updateUserData(firebaseUser);
    return firebaseUser;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<dynamic> getUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    updateUserData(firebaseUser);
    return (firebaseUser);
  }

  void updateUserData(FirebaseUser user) async {
    final Firestore _db = Firestore.instance;
    final FirebaseMessaging _messaging = FirebaseMessaging();
    final String token = await _messaging.getToken();
    DocumentReference ref = _db.collection('users').document(user.uid);
    if (user.displayName != null) {
      ref.setData({
        'provider': user.providerData[1].providerId,
        'displayName': user.displayName,
        'photoURL': user.photoUrl,
      }, merge: true);
    }
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'token': token,
      'lastSeen': DateTime.now()
    }, merge: true);
  }
}
