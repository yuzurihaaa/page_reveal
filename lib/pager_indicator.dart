import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/pages.dart';

final color = const Color(0X88FFFFFF);

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  const PagerIndicator({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      /// we need to find percent active

      var percentActive;


      /// Set percentActive according to slide percentage and direction
      if (i == viewModel.activeIndex) {

        percentActive = 1.0 - viewModel.slidePercent;

      } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {

        percentActive = viewModel.slidePercent;

      } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {

        percentActive = viewModel.slidePercent;


      } else {
        percentActive = 0.0;
      }

      bool isHollow = i >= viewModel.activeIndex;

      bubbles.add(new PageBubble(
        viewModel: new PageBubbleViewModel(
            page.iconAssetPath,
            Colors.green,
            isHollow,
            percentActive),
      ));
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: bubbles)
      ],
    );
  }
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  const PageBubble({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Container(

        /// Lets make a min and max size change according for activePercent
        width: lerpDouble(20.0, 45.0, viewModel.activePercent),
        height: lerpDouble(20.0, 45.0, viewModel.activePercent),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: viewModel.isHollow ? color.withAlpha((0x88 * viewModel.activePercent).round()) : color,
          border: new Border.all(
            color: viewModel.isHollow ? color.withAlpha((0x88 * (1.0 - viewModel.activePercent)).round()) : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: new Opacity(
          opacity: viewModel.activePercent,
          child: new Image.asset(
            viewModel.iconAssetPath,
            color: viewModel.color,
          ),
        ),
      ),
    );
  }
}

enum SlideDirection { leftToRight, rightToLeft, none }

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.pages, this.activeIndex, this.slideDirection, this.slidePercent);
}

/// Viewmodel of each bubble
class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
      this.iconAssetPath, this.color, this.isHollow, this.activePercent);
}
