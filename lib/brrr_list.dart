import 'package:flutter/material.dart';

import 'brrr_data.dart';
import 'brrr_row.dart';

class BrewList extends StatelessWidget {
  const BrewList({Key key, this.brews, this.onOpen, this.onShow, this.onAction})
      : super(key: key);

  final List<Brew> brews;
  final BrewRowActionCallback onOpen;
  final BrewRowActionCallback onShow;
  final BrewRowActionCallback onAction;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: const ValueKey<String>('brew-list'),
      itemExtent: BrewRow.kHeight,
      itemCount: brews.length,
      itemBuilder: (BuildContext context, int index) {
        return new BrewRow(
            brew: brews[index],
            onPressed: onOpen,
            onDoubleTap: onShow,
            onLongPressed: onAction);
      },
    );
  }
}
