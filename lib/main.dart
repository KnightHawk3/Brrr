library brrr;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show
        debugPaintSizeEnabled,
        debugPaintBaselinesEnabled,
        debugPaintLayerBordersEnabled,
        debugPaintPointersEnabled,
        debugRepaintRainbowEnabled;
import 'package:intl/intl.dart';

import 'i18n/brrr_messages_all.dart';
import 'brrr_data.dart';
import 'brrr_home.dart';
import 'brrr_settings.dart';
import 'brrr_strings.dart';
import 'brew_detail.dart';
import 'brrr_types.dart';

class BrrrApp extends StatefulWidget {
  @override
  BrrrAppState createState() => new BrrrAppState();
}

class BrrrAppState extends State<BrrrApp> {
  final Map<String, Brew> _brews = <String, Brew>{};
  final List<String> _icons = <String>[];

  BrrrConfiguration _configuration = new BrrrConfiguration(
      brrrMode: BrrrMode.optimistic,
      backupMode: BackupMode.enabled,
      debugShowGrid: false,
      debugShowSizes: false,
      debugShowBaselines: false,
      debugShowLayers: false,
      debugShowPointers: false,
      debugShowRainbow: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false);

  @override
  void initState() {
    super.initState();
    new BrrrDataFetcher((BrrrData data) {
      setState(() {
        data.appendTo(_brews, _icons);
      });
    });
  }

  void configurationUpdater(BrrrConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  ThemeData get theme {
    switch (_configuration.brrrMode) {
      case BrrrMode.optimistic:
        return new ThemeData(
            brightness: Brightness.light, primarySwatch: Colors.purple);
      case BrrrMode.pessimistic:
        return new ThemeData(
            brightness: Brightness.dark, accentColor: Colors.redAccent);
    }
    assert(_configuration.brrrMode != null);
    return null;
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    if (path[0] != '') return null;
    if (path[1] == 'brew') {
      if (path.length != 3) return null;
      if (_brews.containsKey(path[2])) {
        return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) =>
                new BrewDetailPage(brew: _brews[path[2]]));
      }
    }
    return null;
  }

  Future<LocaleQueryData> _onLocaleChanged(Locale locale) async {
    final String localeString = locale.toString();
    await initializeMessages(localeString);
    Intl.defaultLocale = localeString;
    return BrrrStrings.instance;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      debugPaintSizeEnabled = _configuration.debugShowSizes;
      debugPaintBaselinesEnabled = _configuration.debugShowBaselines;
      debugPaintLayerBordersEnabled = _configuration.debugShowLayers;
      debugPaintPointersEnabled = _configuration.debugShowPointers;
      debugRepaintRainbowEnabled = _configuration.debugShowRainbow;
      return true;
    });
    return new MaterialApp(
        title: 'Brrr',
        theme: theme,
        debugShowMaterialGrid: _configuration.debugShowGrid,
        showPerformanceOverlay: _configuration.showPerformanceOverlay,
        showSemanticsDebugger: _configuration.showSemanticsDebugger,
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => new BrrrHome(
              _brews, _icons, _configuration, configurationUpdater),
          '/settings': (BuildContext context) =>
              new BrrrSettings(_configuration, configurationUpdater)
        },
        onGenerateRoute: _getRoute,
        onLocaleChanged: _onLocaleChanged);
  }
}

void main() {
  runApp(new BrrrApp());
}
