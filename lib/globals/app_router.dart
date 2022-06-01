import 'package:flutter/material.dart';

class AppRouter {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
        PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => page));
  }

  static void pushWithThen(
      BuildContext context, Widget page, Function() thenFunction) {
    Navigator.of(context)
        .push(PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) => page))
        .then((value) {
      thenFunction();
    });
  }

  static void replace(BuildContext context, Widget page,
      {bool bottomToUp = false}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          fullscreenDialog: bottomToUp, builder: (context) => page),
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void removeAllprevious(BuildContext context) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
  }

  static void bottomSheetOpen(BuildContext context, Widget sheet,
      {isDismissible = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return sheet;
      },
      isDismissible: isDismissible,
      isScrollControlled: true,
    );
  }

  static void bottomSheetOpenWithThen(
      BuildContext context, Widget sheet, Function() thenFunction,
      {isDismissible = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return sheet;
      },
      isDismissible: isDismissible,
      isScrollControlled: true,
    ).then((value) {
      thenFunction();
    });
  }
}
