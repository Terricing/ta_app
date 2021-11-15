import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ta_app/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart' show parse;
import 'dart:developer';

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
    // log(html);
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

    // add block and room number
    for (int i = 0; i < coursesJson.length; i++) {
      temp =
          table[i + 1].outerHtml.split("</td>")[0].split("<br>")[1].split("-");
      coursesJson[i]["block"] = temp[0].trim();
      coursesJson[i]["roomNum"] = temp[1].split(".")[1].trim();
    }

    // obtain marks and link
    for (int i = 0; i < coursesJson.length; i++) {
      temp = table[i + 1]
          .outerHtml
          .split("</tr>")[0]
          .split("<!--td></td-->")[1]
          .split("</a>")[0]
          .split('<td align="right">')[1];

      if (temp.contains("href")) {
        coursesJson[i]["url"] = temp.split("href=")[1].split(">")[0];
        coursesJson[i]["mark"] = temp.split(">")[1].trim();
        coursesJson[i]["isLink"] = true;
      } else {
        coursesJson[i]["mark"] = temp.split("<")[0].trim();
        coursesJson[i]["isLink"] = temp.split("<")[0].trim();
      }
    }

    // uncomment to log course map
    // coursesJson.forEach((element) {
    //   log(element.toString());
    // });

    return coursesJson;
  }
}

class HeadlessViewController {
  HeadlessInAppWebView? _headlessWebView;

  HeadlessInAppWebView? get headlessWebView => _headlessWebView;

  set headlessWebView(HeadlessInAppWebView? headlessWebView) {
    _headlessWebView = headlessWebView;
  }

  bool __isLoading = false;

  Future<String?> init(String url) async {
    bool _isLoading = true;
    headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        onLoadStop: (controller, url) async {
          _isLoading = false;
        });

    // while (true) {
    //   Future.delayed(Duration(microseconds: 333333));

    //   if (!_isLoading) {
    //
    //   }
    // }
    headlessWebView?.run();

    while (_isLoading) {
      await Future.delayed(Duration(milliseconds: 250));
    }
    return headlessWebView?.webViewController.getHtml();
  }

  void start() {
    headlessWebView?.dispose();
    headlessWebView?.run();
  }

  void stop() {
    headlessWebView?.dispose();
  }

  bool isRunning() {
    return headlessWebView?.isRunning() ?? false;
  }
}
