import 'dart:convert';

class Brew {
  String icon;
  String name;
  String type;
  int originalGravity;
  int finalGravity;
  double abv;
  String review;
  String notes;
  DateTime began;

  Brew(this.icon, this.name);
  Brew.fromFields(List<String> fields) {
    // "Icon","Name","Type","OriginalGravity","FinalGravity","ABV","Review","Notes",
    icon = fields[0];
    name = fields[1];
    type = fields[2];
    originalGravity = int.parse(fields[3]);
    finalGravity = int.parse(fields[4]);
    abv = double.parse(fields[5]);
    review = fields[6];
    notes = fields[7];
  }
  int gravityDiff() {
    return (this.originalGravity - this.finalGravity).abs();
  }
}

class BrrrData {
  BrrrData(this._data);

  final List<List<String>> _data;

  void appendTo(Map<String, Brew> brews, List<String> icons) {
    for (List<String> fields in _data) {
      final Brew brew = new Brew.fromFields(fields);
      icons.add(brew.icon);
      brews[brew.icon] = brew;
    }
    icons.sort();
  }
}

typedef void BrewDataCallback(BrrrData data);

class BrrrDataFetcher {
  BrrrDataFetcher(this.callback) {
    _fetch();
  }

  final BrewDataCallback callback;
  static bool actuallyFetchData = true;

  void _fetch() {
    final String json = '[["L","Bad Lager","Lager","1042","1022","1.00","Bad.","Dead yeast"],'
        '["S","Choc Stout","Stout","1067","1023","100.00","Tastes good","Did the thing well"]]';
    final JsonDecoder decoder = const JsonDecoder();
    callback(new BrrrData(decoder.convert(json)));
  }
}
