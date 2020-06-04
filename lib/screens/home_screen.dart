import 'package:btec_security/auth/bloc.dart';
import 'package:btec_security/data.dart';
import 'package:btec_security/repository/status_repo.dart';
import 'package:btec_security/screens/message.dart';
import 'package:btec_security/screens/add_details.dart';
import 'package:btec_security/ui/widgets/stream/status_stream.dart';
import 'package:btec_security/status/bloc.dart';
import 'package:btec_security/ui/widgets/card/card_menu.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;
  final String company;

  HomeScreen({Key key, @required this.user, this.company}) : super(key: key);

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
  String dateNow =
      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
  StatusBloc _statusBloc;
  final StatusRepository _statusRepository = StatusRepository();

  @override
  void initState() {
    menu = getMenu();
    super.initState();
    _statusBloc = StatusBloc(statusRepository: _statusRepository);
    _statusBloc.add(ListStarted(user: widget.user));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _dialog(message['data']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _dialog(message['data']);
      },
      onResume: (Map<String, dynamic> message) async {
        _dialog(message['data']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  _dialog(notification) {
    print(notification['body']);
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            title: Text(notification['title'],
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor)),
            content: Container(
              height: 250,
              child: Column(
                children: <Widget>[
                  new Image(
                    image: new CachedNetworkImageProvider(notification['url']),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Did you recognize?',
                    style: CustomFonts.invTextStyle,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.white30,
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).push(
                      PageRouteBuilder<Null>(
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (
                              BuildContext context,
                              Widget child,
                            ) {
                              return Opacity(
                                opacity: animation.value,
                                child: DetailsEvent(
                                  context: context,
                                  user: widget.user,
                                  time: notification['time'],
                                  date: notification['date'],
                                  titleOld: notification['title'],
                                ),
                              );
                            },
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    ),
              ),
              RaisedButton(
                color: Colors.white30,
                child: Text('No'),
                onPressed: () => Navigator.of(context).push(
                      PageRouteBuilder<Null>(
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (
                              BuildContext context,
                              Widget child,
                            ) {
                              return Opacity(
                                opacity: animation.value,
                                child: SendSms(
                                  uid: widget.user.uid,
                                  state: notification['state'],
                                  address: notification['address'],
                                ),
                              );
                            },
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    ),
              )
            ],
          ),
    );
  }

  @override
  void dispose() {
    _statusBloc.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    return BlocProvider<StatusBloc>(
      create: (context) => _statusBloc,
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
              SizedBox(
                height: 5,
                child: Container(color: Theme.of(context).primaryColor),
              ),
              cardMenu(),
              messageCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding logoutButton() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () =>
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
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

  Container header() {
    return Container(
      color: CustomColors.front,
      height: MediaQuery.of(context).size.height / 4.5,
      child: Column(
        children: <Widget>[
          Row(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.company,
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
    );
  }

  Padding cardMenu() {
    int menuLength = menu.length - 1;
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Container(
        color: CustomColors.front,
        width: screenWidth,
        height: screenHeight / 2,
        child: Swiper(
          scrollDirection: Axis.horizontal,
          itemCount: menuLength,
          viewportFraction: 0.6,
          scale: 0.6,
          loop: true,
          itemBuilder: (context, index) =>
              MenuCard(index, menu[index], widget.user),
          pagination: new SwiperPagination(),
        ),
      ),
    );
  }

  Padding messageCard(context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: CustomColors.front,
                height: MediaQuery.of(context).size.height / 2,
                child: BlocBuilder(
                  bloc: _statusBloc,
                  builder: (BuildContext context, StatusState state) {
                    if (state is InitialStatusState) {
                      return Center(
                          child: Text("Stating...",
                              style: CustomFonts.logBigText));
                    } else if (state is StatusLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is StatusEmpty) {
                      return Center(
                          child:
                              Text("Empty...", style: CustomFonts.logBigText));
                    } else if (state is StatusLoaded) {
                      return StatusStream(
                        uid: widget.user.uid,
                        date: dateNow,
                      );
                    }
                  },
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
