import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/pages.dart';

final color = const Color(0X88FFFFFF);

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  const PagerIndicator({Key key, this.viewModel}) : super(key: key);

  getPercentValue (int i) {
    if (i == viewModel.activeIndex) {
      return 1.0 - viewModel.slidePercent;
    } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {
      return viewModel.slidePercent;
    } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {
      return viewModel.slidePercent;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      /// we need to find percent active

      var percentActive;


      /// Set percentActive according to slide percentage and direction
      percentActive = getPercentValue(i);

      bool isHollow = i >= viewModel.activeIndex
          || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(new PageBubble(
        viewModel: new PageBubbleViewModel(
            page.iconAssetPath,
            Colors.green,
            isHollow,
            percentActive),
      ));
    }

    final bubbleWidth = 55.0;

    final baseTranslation = (viewModel.pages.length * bubbleWidth / 2) - (bubbleWidth / 2);

    var translation = baseTranslation - (viewModel.activeIndex * bubbleWidth);

    /// We wanna offset to how much we're sliding

    switch(viewModel.slideDirection) {
      case SlideDirection.leftToRight:
        translation += bubbleWidth * viewModel.slidePercent;
        break;
      case SlideDirection.rightToLeft:
        translation -= bubbleWidth * viewModel.slidePercent;
        break;
      default:
    }
    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Transform(
          /// Now let's move the position so that the main will always stay mid
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bubbles),
          ),
        )
      ],
    );
  }
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  const PageBubble({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 55.0,
      height: 55.0,
      child: new Center(
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
            // ignore: conflicting_dart_import
            child: new Image.asset(
              viewModel.iconAssetPath,
              color: viewModel.color,
            ),
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

/// ViewModel of each bubble
class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
      this.iconAssetPath, this.color, this.isHollow, this.activePercent);
}
