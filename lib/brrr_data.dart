import 'dart:convert';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class Brew {
  String name = null;
  String style = null;
  int originalGravity = null;
  int finalGravity = null;
  double abv = null;
  String review = null;
  String notes = null;
  DateTime brewDate = new DateTime.now();
  DateTime bottleDate = null;
  DateTime sampleDate = null;
  Brew(this.name);

  String shortName() {
    return name.substring(0, 1);
  }

  Brew.fromJson(LinkedHashMap<String, String> json) {
    // See below for initial json example.
    // FUTURE: rewrite this to be less crap.
    if (json.containsKey("name")) {
      this.name = json["name"];
    }
    if (json.containsKey("style")) {
      this.style = json["style"];
    }
    if (json.containsKey("originalGravity")) {
      this.originalGravity = int.parse(json["originalGravity"]);
    }
    if (json.containsKey("finalGravity")) {
      this.finalGravity = int.parse(json["finalGravity"]);
    }
    if (json.containsKey("review")) {
      this.review = json["review"];
    }
    if (json.containsKey("notes")) {
      this.notes = json["notes"];
    }
    if (json.containsKey("brewDate")) {
      this.brewDate = DateTime.parse(json["brewDate"]);
    }
    if (json.containsKey("bottleDate")) {
      this.bottleDate = DateTime.parse(json["bottleDate"]);
    }
    if (json.containsKey("sampleDate")) {
      this.sampleDate = DateTime.parse(json["sampleDate"]);
    }
  }

  String toJson() {
    String json = "{"
        '"name": "${this.name}",'
        '"style": "${this.style}",';
    if (this.originalGravity != null) {
      json += '"originalGravity": "${this.originalGravity}",';
    }
    if (this.finalGravity != null) {
      json += '"finalGravity": "${this.finalGravity}",';
    }
    if (this.abv != null) {
      json += '"abv": "${this.abv}",';
    }
    if (this.review != null) {
      json += '"review": "${this.review}",';
    }
    if (this.notes != null) {
      json += '"notes": "${this.notes}",';
    }
    if (this.brewDate != null) {
      json += '"brewDate": "${this.brewDate.toIso8601String()}",';
    }
    if (this.sampleDate != null) {
      json += '"sampleDate": "${this.sampleDate.toIso8601String()}",';
    }
    if (this.bottleDate != null) {
      json += '"bottleDate": "${this.bottleDate.toIso8601String()}",';
    }
    json = json.substring(0, json.length - 1);
    json += "}";
    return json;
  }

  int gravityDiff() {
    return (this.originalGravity - this.finalGravity).abs();
  }
}

class BrrrData {
  BrrrData(this._data);

  final List<LinkedHashMap<String, String>> _data;

  static String serialise(Map<String, Brew> brews) {
    String json = "[";
    brews.forEach((String _, Brew brew) {
      json += brew.toJson() + ',';
    });
    json = json.substring(0, json.length - 1);
    return json + ']';
  }

  // This takes the data string, it then appends it to the arguments.
  void appendTo(Map<String, Brew> brews, List<String> urls) {
    for (LinkedHashMap<String, String> brewJson in _data) {
      final Brew brew = new Brew.fromJson(brewJson);

      brews[brew.shortName()] = brew;
      urls.add(brew.shortName());
    }
    urls.sort();
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
    String init = "butt";
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      print(prefs.getString("brews"));
      if (prefs.getString("brews") != null) {
        init = prefs.getString("brews");
      } else {
        init = "[]";
      }
      final JsonDecoder decoder = const JsonDecoder();
      callback(new BrrrData(decoder.convert(init)));
    });
  }
}
