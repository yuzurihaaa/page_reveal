import 'package:flutter/material.dart';
import 'package:material_page_reveal/common/assets_all.dart';
import 'package:material_page_reveal/page_reveal.dart';
import 'package:material_page_reveal/pager_indicator.dart';
import 'package:material_page_reveal/pages.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          /// Stack can have multiple children relative to the edge of the box
          /// doc here: https://docs.flutter.io/flutter/widgets/Stack-class.html
          children: <Widget>[
            new PageReveal(
              revealPercent: 1.0,
              child: new Page(
                viewmodel: pages[1],
                percentVisible: 0.5,
              ),
            ),
            new PagerIndicator(
              viewModel: new PagerIndicatorViewModel(
                  pages,
                  1,
                  SlideDirection.leftToRight,
                  0.1),
            )
          ],
        )
    );
  }
}
