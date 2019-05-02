import 'package:btec_security/ui/widgets/card/CardMenu.dart';
import 'package:flutter/material.dart';
import 'package:btec_security/data.dart';
import 'package:btec_security/utils/CustomColors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTeC Security',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'BTeC Security'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List menu;

  @override
  void initState() {
    menu = getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            header(),
            cardMenu(),
          ],
        ),
      ),
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
                  'Ahmad Bin Abu',
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
}
