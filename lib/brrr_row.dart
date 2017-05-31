import 'package:flutter/material.dart';

import 'brrr_data.dart';

typedef void BrewRowActionCallback(Brew brew);

class BrewRow extends StatelessWidget {
  BrewRow({this.brew, this.onPressed, this.onDoubleTap, this.onLongPressed})
      : super(key: new ObjectKey(brew));

  final Brew brew;
  final BrewRowActionCallback onPressed;
  final BrewRowActionCallback onDoubleTap;
  final BrewRowActionCallback onLongPressed;

  static const double kHeight = 79.0;

  GestureTapCallback _getHandler(BrewRowActionCallback callback) {
    return callback == null ? null : () => callback(brew);
  }

  @override
  Widget build(BuildContext context) {
    String changeInPrice = "${brew.gravityDiff().toStringAsFixed(2)}";
    if (brew.gravityDiff() > 10) changeInPrice = "+" + changeInPrice;
    return new InkWell(
        onTap: _getHandler(onPressed),
        onDoubleTap: _getHandler(onDoubleTap),
        onLongPress: _getHandler(onLongPressed),
        child: new Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom:
                        new BorderSide(color: Theme.of(context).dividerColor))),
            child: new Row(children: <Widget>[
              new Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  child: new Hero(
                      tag: brew,
                      child: new CircleAvatar(
                          child: new Text(brew.name[0])
                      )
                  )
              ),
              new Expanded(
                  child: new Row(
                      children: <Widget>[
                    new Expanded(
                        child: new Text(brew.name, textAlign: TextAlign.right)),
                    new Expanded(
                        child: new Text(changeInPrice,
                            textAlign: TextAlign.right)),
                  ],
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline:
                          DefaultTextStyle.of(context).style.textBaseline)),
            ])));
  }
}
