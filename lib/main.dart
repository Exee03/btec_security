import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btec_security/auth/bloc.dart';
import 'package:btec_security/repository/user_repo.dart';
import 'package:btec_security/screens/home_screen.dart';
import 'package:btec_security/login/login_screen.dart';
import 'package:btec_security/splash.dart';
import 'package:btec_security/simple_bloc_delegate.dart';

main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  ThemeData get _themeData => new ThemeData(
      primaryColor: CustomColors.splashBackground,
      accentColor: Colors.amberAccent,
      scaffoldBackgroundColor: CustomColors.background,
      fontFamily: 'Open_Sans');

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
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
              return HomeScreen(user: state.user);
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
