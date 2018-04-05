import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/common/assets_all.dart';
import 'package:material_page_reveal/page_dragger.dart';
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
  StreamController<SlideUpdate> slideUpdateStream;

  /// These are all we need to controll the widgets
  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if(slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if(slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            activeIndex = slideDirection == SlideDirection.leftToRight
                ? activeIndex - 1
                : activeIndex + 1;
          }

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      /// Stack can have multiple children relative to the edge of the box
      /// doc here: https://docs.flutter.io/flutter/widgets/Stack-class.html
      children: <Widget>[
        new Page(
          viewmodel: pages[activeIndex],
          percentVisible: 1.0,
        ),
        new PageReveal(
          revealPercent: slidePercent,
          child: new Page(
            viewmodel: pages[nextPageIndex],
            percentVisible: slidePercent,
          ),
        ),
        new PagerIndicator(
          viewModel: new PagerIndicatorViewModel(
              pages, activeIndex, slideDirection, slidePercent),
        ),
        new PageDragger(
          canDragLeftToRight: activeIndex > 0,
          canDragRightToLeft: activeIndex < pages.length - 1,
          slideUpdateStream: this.slideUpdateStream,
        )
      ],
    ));
  }
}
