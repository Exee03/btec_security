import 'package:btec_security/auth/bloc.dart';
import 'package:btec_security/data.dart';
import 'package:btec_security/models/message.dart';
import 'package:btec_security/ui/widgets/card/card_menu.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;

  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String displayName;
  List menu;
  final Duration durationAnimation = const Duration(milliseconds: 300);
  double screenWidth, screenHeight;
  bool isCollapsed = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> messages = [];
  String _time =
      formatDate(DateTime.now(), [dd, '/', mm, ' - ', h, ':', nn, ' ', am]);

  @override
  void initState() {
    print(widget.user);
    menu = getMenu();
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'],
              body: '$_time\n${notification['body']}'));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        setState(() {
          messages.add(Message(
            title: 'onLaunch',
            body: '$message',
          ));
        });
        final notification = message['data'];
        setState(() {
          messages.add(Message(
              title: 'onLaunch : ${notification['title']}',
              body: 'onLaunch : ${notification['body']}'));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        final notification = message['data'];
        setState(() {
          messages.add(Message(
              title: 'onResume : ${notification['title']}',
              body: 'onResume : ${notification['body']}'));
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user.displayName == null) {
      displayName = widget.user.email;
    } else {
      displayName = widget.user.displayName;
    }
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          sideMenu(context),
          homePage(context),
        ],
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
            Text(
              displayName,
              style: CustomFonts.invTextStyle,
            ),
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

  Padding logoutButton() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () =>
            BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut()),
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

  Padding header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    iconSize: 30,
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
                    style: TextStyle(
                        color: CustomColors.splashBackground, fontSize: 50.0),
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
                  displayName,
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
                  children: messages.map(buildMessage).toList(),
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
