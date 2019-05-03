import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class Menu {
  int index;
  String title;
  Color colors;
  AssetImage image;
  String content;

  Menu({this.index, this.title, this.colors, this.image, this.content});
}

List getMenu() {
  return [
    Menu(
      index: 1,
      title: "Office",
      colors: CustomColors.office,
      image: AssetImage('assets/icons/desk.png'),
      content:
          "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.",
    ),
    Menu(
      index: 2,
      title: "Attendance",
      colors: CustomColors.attendance,
      image: AssetImage('assets/icons/fingerprint.png'),
      content:
          "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.",
    ),
    Menu(
      index: 1,
      title: "History",
      colors: CustomColors.history,
      image: AssetImage('assets/icons/history.png'),
      content:
          "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.",
    ),
  ];
}