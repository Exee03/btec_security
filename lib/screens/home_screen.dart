import 'package:btec_security/app_state_container.dart';
import 'package:btec_security/models/app_state.dart';
import 'package:btec_security/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/card/card_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppState appState;
  List menu;

  Widget get _pageToDisplay {
    print('_pageToDisplay');
    if (appState.isLoading) {
      return _loadingView;
    } else if (!appState.isLoading && appState.user == null) {
      print('!appState.isLoading && appState.user == null');
      return new AuthScreen();
    } else {
      return _homeView;
    }
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget get _homeView {
    return new SingleChildScrollView(
      child: Column(
        children: <Widget>[
          header(),
          cardMenu(),
          logoutButton(),
        ],
      ),
    );
  }

  @override
  void initState() {
    menu = getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This is the InheritedWidget in action.
    // You can reference the StatefulWidget that
    // wraps it like this, which allows you to access any
    // public method or property on it.
    var container = AppStateContainer.of(context);
    // For example, get grab its property called state!
    appState = container.state;
    // Everything this build method is called, which is when the state
    // changes, Flutter will 'get' the _pageToDisplay widget, which will
    // return the screen we want based on the appState.isLoading
    Widget body = _pageToDisplay;
    return new Scaffold(
      // Replace the hardcoded widget
      // with our widget that switches.
      body: body,
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'BTeC',
                  style: TextStyle(color: Colors.orange, fontSize: 50.0),
                ),
                Text(
                  'Security',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Syok Sdn. Bhd.',
                  style: TextStyle(color: Colors.white70, fontSize: 20.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  appState.user.displayName,
                  style: TextStyle(color: Colors.white30, fontSize: 15.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding cardMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        height: MediaQuery.of(context).size.height / 2,
        child: Swiper(
          scrollDirection: Axis.horizontal,
          itemCount: menu.length,
          viewportFraction: 0.6,
          scale: 0.6,
          loop: true,
          itemBuilder: (context, index) => MenuCard(index, menu[index]),
          pagination: new SwiperPagination(),
        ),
      ),
    );
  }

  Future logOuttoFirebase() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    final String uid = appState.user.uid;
    print(uid + ' has successfully signed out.');
    print(appState.isLoading);
    setState(() {
      appState.isLoading = false;
      print(appState.isLoading);
      appState.user = null;
      print(appState.user);
    });       
  }

  Padding logoutButton() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        height: 50,
        child: RaisedButton(
          onPressed: () => logOuttoFirebase(),
          color: Colors.white,
          child: new Container(
            width: 230.0,
            height: 50.0,
            alignment: Alignment.center,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new Image.network(
                    'https://image.flaticon.com/teams/slug/google.jpg',
                    width: 30.0,
                  ),
                ),
                new Text(
                  'Sign in With Google',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
