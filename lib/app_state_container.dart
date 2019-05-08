import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:btec_security/models/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppStateContainer extends StatefulWidget {
  // Your apps state is managed by the container
  final AppState state;
  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  // Just padding the state through so we don't have to
  // manipulate it with widget.state.
  AppState state;
  // This is used to sign into Google, not Firebase.
  GoogleSignInAccount googleUser; // new
  // This class handles signing into Google.
  // It comes from the Firebase plugin.
  final googleSignIn = new GoogleSignIn(); // new

  bool authorized;

  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // You'll almost certainly want to do some logic
    // in InitState of your AppStateContainer. In this example, we'll eventually
    // write the methods to check the local state
    // for existing users and all that.
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
      initUser();
    }
  }

  // All new:
  // This method is called on start up no matter what.
  Future<Null> initUser() async {
    // First, check if a user exists.
    googleUser = await _ensureLoggedInOnStartUp();
    // If the user is null, we aren't loading anyhting
    // because there isn't anything to load.
    // This will force the homepage to navigate to the auth page.
    if (googleUser == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      // Do some other stuff, handle later.
      firebaseUser = await logIntoFirebase();
    }
  }

  logIntoFirebase() async {
    if (googleUser == null) {
      googleUser = await googleSignIn.signIn();
    }

    try {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      firebaseUser = await _auth.signInWithCredential(credential);

      print('Logged in: ${firebaseUser.displayName}');
      await checkData(firebaseUser);
      if (authorized == false) {
        setState(() {
          state.isLoading = false;
          state.authorized = false;
          state.user = firebaseUser;
        });
      } else {
        updateUserData(firebaseUser);
        setState(() {
          state.isLoading = false;
          state.authorized = true;
          state.user = firebaseUser;
        });
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  checkData(FirebaseUser user) async {
    await Firestore.instance
        .collection('admin')
        .where('email', isEqualTo: user.email)
        .getDocuments()
        .then((onValue) {
      if (onValue.documents.isEmpty) {
        authorized = false;
      }
    });
  }

  void updateUserData(FirebaseUser user) async {
    final Firestore _db = Firestore.instance;
    final FirebaseMessaging _messaging = FirebaseMessaging();
    final String token = await _messaging.getToken();
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'provider': user.providerData[1].providerId,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoUrl,
      'token': token,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future<dynamic> _ensureLoggedInOnStartUp() async {
    // That class has a currentUser if there's already a user signed in on
    // this device.
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      // but if not, Google should try to sign one in whos previously signed in
      // on this phone.
      user = await googleSignIn.signInSilently();
    }
    // NB: This could still possibly be null.
    googleUser = user;
    return user;
  }

  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedStateContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppStateContainerState data;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a better way to do this, which you'll see later.
  // But basically, Flutter automatically calls this method when any data
  // in this widget is changed.
  // You can use this method to make sure that flutter actually should
  // repaint the tree, or do nothing.
  // It helps with performance.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
