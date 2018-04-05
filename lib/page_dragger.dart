import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/pager_indicator.dart';

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  /// We need a StreamController to send out data!
  final StreamController<SlideUpdate> slideUpdateStream;

  const PageDragger(
      {Key key,
      this.slideUpdateStream,
      this.canDragLeftToRight,
      this.canDragRightToLeft})
      : super(key: key);

  @override
  _PageDraggerState createState() => new _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300.0;

  /// We wanna report where we start dragging
  Offset dragStart;

  /// We need to know which direction
  SlideDirection slideDirection;

  /// We need to remember how far we slid left or right
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    /// Assign first place
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;

      final dx = dragStart.dx - newPosition.dx;

      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(
          new SlideUpdate(slideDirection, slidePercent, UpdateType.dragging));

      print('Dragging $slideDirection at $slidePercent%');
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(
        new SlideUpdate(SlideDirection.none, 0.0, UpdateType.doneDragging));

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

enum UpdateType {
  dragging,
  doneDragging,
}

/// We need to tell other widget the slide event!
class SlideUpdate {
  final updateType;
  final direction;
  final slidePercent;

  SlideUpdate(this.direction, this.slidePercent, this.updateType);
}
