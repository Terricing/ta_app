import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ta_app/services/courseinfo.dart';
import 'dart:developer';

class Loading extends StatefulWidget {
  Auth user;
  HeadlessViewController webView;
  Loading(this.user, this.webView);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // pass this in
  var _getCourses = GetCourses();
  var _courseMap;

  @override
  void initState() {
    super.initState();
    // widget.webView.start();
    // log(widget.webView.isRunning().toString());
    // widget.webView.headlessWebView?.webViewController.getHtml().then((val) {
    // courseMap = _getCourses.GetCourseMap(val ?? "");
    // log(courseMap.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: widget.webView.init(_getCourses.GenUrl(widget.user)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _courseMap = (_getCourses.GetCourseMap(snapshot.data.toString()));
            return ListView.builder(
              itemCount: _courseMap.length,
              itemBuilder: (context, index) {
                return Course(_courseMap[index]["courseName"], 0.7);
              },
            );
          } else {
            return Text("Loading");
          }
        },
      ),
    ));
  }
}

class Course extends StatelessWidget {
  final String name;
  final double grade;
  const Course(this.name, this.grade);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: grade,
              backgroundColor: Colors.grey,
              strokeWidth: 6,
            ),
          ),
          Text((grade * 100).toString() + "%")
        ],
      ),
      CourseText(name),
    ]));
  }
}

class CourseText extends StatelessWidget {
  final String text;
  const CourseText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
    );
  }
}
