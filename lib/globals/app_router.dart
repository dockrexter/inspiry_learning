import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static dynamic push(BuildContext context, Widget page) {
    closeKeyboard(context);
    return Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static void pushWithThen(
      BuildContext context, Widget page, Function() thenFunction) {
    closeKeyboard(context);
    Navigator.of(context)
        .push(
      CupertinoPageRoute(builder: (context) => page),
    )
        .then((value) {
      thenFunction();
    });
  }

  static dynamic replace(BuildContext context, Widget page,
      {Object? data, bool bottomToUp = false}) {
    return Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
          fullscreenDialog: bottomToUp, builder: (context) => page),
      result: data,
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static void removeAllprevious(BuildContext context) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
  }

  static void pop(BuildContext context, [Object? result]) {
    Navigator.of(context).pop(result);
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  static closeKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
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
