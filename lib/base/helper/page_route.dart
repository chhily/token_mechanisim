import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future openPage(Widget page, context, {isReplace = false}) async {
  isReplace
      ? await Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => page))
      : await Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => page));
}

void openPageAndRemoveAllRoute(Widget page, context) {
  Navigator.pushAndRemoveUntil(
      context,
      // CupertinoPageRoute(builder: (context) => page),
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false);
}

Future openPageWithBack(Widget page, context, onBack(conID)) async {
  await Navigator.push(context, CupertinoPageRoute(builder: (context) => page))
      .then((value) {
    if (value != null) {
      onBack(value);
    }
  });
}

Future openPageDelay(Widget page, context, {int duration = 350}) async {
  Future.delayed(Duration(milliseconds: duration), () async {
    final route = CupertinoPageRoute(builder: (context) => page);
    await Navigator.of(context).push(route);
  });
}

Future<dynamic> openPageMaterial(Widget page, context) async {
  return await Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
}

void closePageDelay(context, String request, {int duration = 350}) {
  Future.delayed(Duration(milliseconds: duration), () async {
    if (request != "") {
      Navigator.of(context).pop(request);
    } else {
      Navigator.of(context).pop();
    }
  });
}

void closePage(BuildContext context) {
  Navigator.of(context).pop();
}

void logOut() {}

onExit() {
  return SystemNavigator.pop();
}
