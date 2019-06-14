import 'package:btec_security/data.dart';
import 'package:btec_security/screens/sidemenu/attendance_sidemenu.dart';
import 'package:btec_security/screens/sidemenu/history_sidemenu.dart';
import 'package:btec_security/screens/sidemenu/office_sidemenu.dart';
import 'package:btec_security/screens/sidemenu/profile_sidemenu.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btec_security/auth/bloc.dart';
import 'package:btec_security/repository/user_repo.dart';
import 'package:btec_security/screens/home_screen.dart';
import 'package:btec_security/login/login_screen.dart';
import 'package:btec_security/splash.dart';
import 'package:btec_security/simple_bloc_delegate.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';

main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new App());
  });
}

class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  List<ScreenHiddenDrawer> itens = new List();
  List<Menu> menu;

  ThemeData get _themeData => new ThemeData(
      primaryColor: CustomColors.splashBackground,
      accentColor: CustomColors.splashBackground,
      bottomAppBarColor: CustomColors.front,
      scaffoldBackgroundColor: CustomColors.background,
      fontFamily: 'Open_Sans');

  @override
  void initState() {
    super.initState();
    menu = getMenu();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _themeData,
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
              itens.clear();
              itens.add(
                new ScreenHiddenDrawer(
                  new ItemHiddenMenu(
                    name: "Home",
                    colorLineSelected: Theme.of(context).primaryColor,
                    baseStyle: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 25.0),
                    selectedStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  HomeScreen(user: state.user, company: state.company),
                ),
              );
              Widget widgetMenu;
              for (int i = 0; i < menu.length; i++) {
                if (i == 0) {
                  widgetMenu = OfficeScreenSidemenu(
                    menu: menu[i],
                    user: state.user,
                  );
                } else if (i == 1) {
                  print('state.totalEmployee = ${state.totalEmployee}');
                  widgetMenu = AttendanceScreenSidemenu(
                    menu: menu[i],
                    user: state.user,
                    totalEmployee: state.totalEmployee,
                  );
                } else if (i == 2) {
                  widgetMenu =
                      HistoryScreenSidemenu(menu: menu[i], uid: state.user.uid);
                } else if (i == 3) {
                  widgetMenu = Profile(
                    menu: menu[i],
                    user: state.user,
                    company: state.company,
                  );
                }
                itens.add(
                  new ScreenHiddenDrawer(
                    new ItemHiddenMenu(
                      name: menu[i].title,
                      colorLineSelected: menu[i].colors,
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 25.0),
                      selectedStyle: TextStyle(color: menu[i].colors),
                    ),
                    widgetMenu,
                  ),
                );
              }
              return HiddenDrawerMenu(
                initPositionSelected: 0,
                screens: itens,
                backgroundColorMenu: Theme.of(context).scaffoldBackgroundColor,
                iconMenuAppBar: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                whithAutoTittleName: false,
                backgroundColorContent:
                    Theme.of(context).scaffoldBackgroundColor,
                backgroundColorAppBar: Theme.of(context).bottomAppBarColor,
                elevationAppBar: 0,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
