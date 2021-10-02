import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ta_app/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart' show parse;

class Auth {
  String username;
  String pass;

  Auth(this.username, this.pass);
}

class GetCourses {
  String GenUrl(Auth user) {
    return "https://ta.yrdsb.ca/yrdsb?username=${user.username}&password=${user.pass}";
  }

  //RETURN COURSES
  List<Map> GetCourseMap(String html) {
    // get and store table containing course info
    var table =
        parse(html).getElementsByTagName('div')[2].getElementsByTagName('tr');

    // store individual course html
    List<String> courses = [];

    // obtain individual course html
    for (int i = 1; i < table.length; i++) {
      courses.add(table[i]
          .getElementsByTagName('td')[0]
          .outerHtml
          .split('<br>')[0]
          .split('<td>')[1]
          .toString());
    }

    var temp; //temporarily store array of coursename and coursecodes
    List<Map> coursesJson = [];
    courses.forEach((element) {
      // create map for every course that stores name and course code
      var tempMap = Map();
      temp = element.split(':');
      // store course code and name
      tempMap['courseCode'] = temp[0].trim();
      tempMap['courseName'] = temp[1].trim();

      // add course codes and name to array of maps
      coursesJson.add(tempMap);
    });

    return coursesJson;
  }
}

class HeadlessViewController {
  HeadlessInAppWebView? headlessWebView;

  void init(String url) {
    headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        onWebViewCreated: (controller) {
          final snackBar = SnackBar(
            content: Text("Webview created"),
            duration: Duration(seconds: 2),
          );
        },
        onLoadStart: (controller, url) async {
          final snackBar = SnackBar(
            content: Text('$url'),
            duration: Duration(seconds: 2),
          );
        });
  }

  void start() {
    headlessWebView?.dispose();
    headlessWebView?.run();
  }

  void stop() {
    headlessWebView?.dispose();
  }
}
