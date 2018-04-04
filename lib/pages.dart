import 'package:flutter/material.dart';
import 'package:material_page_reveal/common/assets_all.dart';

final pages = [
  new PageViewModel(
      const Color(0xFF678FB4),
      hotelImage,
      'Hotels',
      'All hotels and hostels are sorted by hospitality rating',
      'assets/key.png'),
  new PageViewModel(
      const Color(0xFF65B0B4),
      bankImage,
      'Banks',
      'We carefully verify all banks before adding them into the app',
      'assets/wallet.png'),
  new PageViewModel(
    const Color(0xFF9B90BC),
    storeImage,
    'Store',
    'All local stores are categorized for your convenience',
    'assets/shopping_cart.png',
  ),
];

class Page extends StatelessWidget {
  final PageViewModel viewmodel;

  /// This is gonna control the widget visibility
  final double percentVisible;

  const Page({Key key, this.viewmodel, this.percentVisible = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      color: viewmodel.color,
      child: new Opacity(
        /// This widget control the visibility
        opacity: percentVisible,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Transform(
              /// Widget for handling position (x, y, z)
              /// Right now we only interested to move it from bottom to top, hence we are only
              /// going to use position y
              transform: new Matrix4.translationValues(0.0, 50.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                /// Widget for padding
                padding: new EdgeInsets.only(bottom: 25.0),
                child: new Image.asset(
                  viewmodel.heroAssetPath,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ),
            new Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new Text(
                  viewmodel.title,
                  style: new TextStyle(
                      color: Colors.white,
                      fontFamily: 'FlamanteRoma',
                      fontSize: 34.0),
                ),
              ),
            ),
            new Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                padding: const EdgeInsets.only(bottom: 75.0),
                child: new Text(
                  viewmodel.body,
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Let's make our widget more flexible!
class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPath;

  PageViewModel(this.color, this.heroAssetPath, this.title, this.body,
      this.iconAssetPath);
}
