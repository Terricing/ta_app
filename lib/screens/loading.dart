import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ta_app/services/courseinfo.dart';
import 'dart:developer';

class Loading extends StatefulWidget {
  Auth user;
  Loading(this.user);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var webView = HeadlessViewController();
  var getCourses = GetCourses();

  @override
  void initState() {
    super.initState();
    webView.init(getCourses.GenUrl(widget.user));
    webView.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('test'),
          onPressed: () async {
            var val =
                await webView.headlessWebView?.webViewController.getHtml();
            if (val != null) {
              log(getCourses.GetCourseMap(val).toString());
            }
          },
        ),
      ),
    );
  }
}
