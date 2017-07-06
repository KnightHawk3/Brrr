import 'package:flutter/material.dart';

import 'brrr_data.dart';

class _BrewDetailView extends StatelessWidget {
  const _BrewDetailView({this.brew, this.arrow});

  final Brew brew;
  final Widget arrow;

  @override
  Widget build(BuildContext context) {
    String originalGravity = "";
    String abv = "";
    String changeInGravity = "";
    if (brew.originalGravity != null && brew.originalGravity > 0) {
      originalGravity = "${(brew.originalGravity / 1000.0).toStringAsFixed(3)}";
      abv = "${(((brew.originalGravity / 1000.0) - (brew.finalGravity / 1000.0)
      ) * 131.25).toStringAsFixed(2)}%";
      // TODO: Probably shouldn't have this be here
      changeInGravity = "-${brew.gravityDiff().toStringAsFixed(2)}";
    }

    final TextStyle headings = Theme.of(context).textTheme.body2;
    return new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Column(children: <Widget>[
          new Row(children: <Widget>[
            new Text('${brew.name.substring(0, 1)}',
                style: Theme.of(context).textTheme.display2),
            arrow,
          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          new Text('Brew Date', style: headings),
          //new Text('$brewDate'),
          new Container(height: 8.0),
          new Text('Style', style: headings),
          new Text('${brew.style}'),
          new Container(height: 8.0),
          // TODO: Probably want to make final gravity easy to read
          new Text('Original Gravity', style: headings),
           new Text('$originalGravity ($changeInGravity)'),
          new Container(height: 8.0),

          new Text('ABV', style: headings),
          new Text('$abv'),
          new Container(height: 8.0),

          new Text('Notes', style: headings),
          new Text('${brew.notes}'),
          new Container(height: 8.0),
          new Text('Review', style: headings),
          new Text('${brew.review}'),
          new Container(height: 8.0),
        ], mainAxisSize: MainAxisSize.min));
  }
}

class BrewDetailPage extends StatelessWidget {
  const BrewDetailPage({this.brew});

  final Brew brew;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(brew.name)),
        body: new SingleChildScrollView(
            child: new Container(
                margin: const EdgeInsets.all(20.0),
                child: new Card(
                    child: new _BrewDetailView(
                        brew: brew,
                        arrow: new Hero(
                            tag: brew,
                            child: new CircleAvatar(
                                child: new Text(brew.name[0]))))))));
  }
}

class BrewDetailBottomSheet extends StatelessWidget {
  const BrewDetailBottomSheet({this.brew});

  final Brew brew;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
            border: const Border(top: const BorderSide(color: Colors.black26))),
        child: new _BrewDetailView(
            brew: brew,
            arrow: new CircleAvatar(child: new Text(brew.name[0]))));
  }
}
