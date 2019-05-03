import 'package:btec_security/app.dart';
import 'package:btec_security/app_state_container.dart';
import 'package:flutter/material.dart';

void main() {
  // Wrap your App in your new storage container
  runApp(new AppStateContainer(
    child: new AppRootWidget(),
  ));
}