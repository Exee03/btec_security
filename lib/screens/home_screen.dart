import 'package:btec_security/app_state_container.dart';
import 'package:btec_security/models/app_state.dart';
import 'package:btec_security/models/message.dart';
import 'package:btec_security/screens/auth_screen.dart';
import 'package:btec_security/ui/widgets/dialog/unauthorised_user.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/card/card_menu.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.messages});
  List<Message> messages = [];
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AppState appState;
  List menu;
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration durationAnimation = const Duration(milliseconds: 300);

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
    } else if (!appState.isLoading && appState.user == null) {
      return new AuthScreen();
    } else if (!appState.authorized) {
      return new Unauthorised(email: appState.user.email);
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
    return Stack(
      children: <Widget>[sideMenu(context), homePage(context)],
    );
  }

  Widget homePage(context) {
    return AnimatedPositioned(
      duration: durationAnimation,
      top: isCollapsed ? 0 : 0.05 * screenHeight,
      bottom: isCollapsed ? 0 : 0.05 * screenHeight,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: Material(
        shadowColor: Colors.grey,
        animationDuration: durationAnimation,
        elevation: 8,
        color: CustomColors.background,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              header(),
              cardMenu(),
              messageCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sideMenu(context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = true;
                });
              },
              child: Text(
                'Dashboard',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            logoutButton(),
          ],
        ),
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
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isCollapsed = !isCollapsed;
                      });
                    },
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
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'BTeC',
                    style: TextStyle(color: Colors.orange, fontSize: 50.0),
                  ),
                  Text(
                    'Security',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
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
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        width: screenWidth,
        height: screenHeight / 2,
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
    print('attent to logout');
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    final String uid = appState.user.uid;
    print(uid + ' has successfully signed out.');
    setState(() {
      appState.isLoading = false;
      appState.user = null;
    });
  }

  Padding logoutButton() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () => logOuttoFirebase(),
        child: new Container(
          width: 150.0,
          height: 50.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
              new Text(
                'Sign Out',
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding messageCard() {
    Widget buildMessage(Message message) => ListTile(
          title: Text(
            message.title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            message.body,
            style: TextStyle(color: Colors.white),
          ),
        );
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                color: CustomColors.front,
                height: MediaQuery.of(context).size.height / 2,
                child: ListView(
                  children: widget.messages.map(buildMessage).toList(),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height / 2,
          )
        ],
      ),
    );
  }
}
