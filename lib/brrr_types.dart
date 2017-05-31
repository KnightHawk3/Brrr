import 'package:flutter/foundation.dart';

enum BrrrMode { optimistic, pessimistic }
enum BackupMode { enabled, disabled }

class BrrrConfiguration {
  BrrrConfiguration(
      {@required this.brrrMode,
      @required this.backupMode,
      @required this.debugShowGrid,
      @required this.debugShowSizes,
      @required this.debugShowBaselines,
      @required this.debugShowLayers,
      @required this.debugShowPointers,
      @required this.debugShowRainbow,
      @required this.showPerformanceOverlay,
      @required this.showSemanticsDebugger}) {
    assert(brrrMode != null);
    assert(backupMode != null);
    assert(debugShowGrid != null);
    assert(debugShowSizes != null);
    assert(debugShowBaselines != null);
    assert(debugShowLayers != null);
    assert(debugShowPointers != null);
    assert(debugShowRainbow != null);
    assert(showPerformanceOverlay != null);
    assert(showSemanticsDebugger != null);
  }

  final BrrrMode brrrMode;
  final BackupMode backupMode;
  final bool debugShowGrid;
  final bool debugShowSizes;
  final bool debugShowBaselines;
  final bool debugShowLayers;
  final bool debugShowPointers;
  final bool debugShowRainbow;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;

  BrrrConfiguration copyWith(
      {BrrrMode brrrMode,
      BackupMode backupMode,
      bool debugShowGrid,
      bool debugShowSizes,
      bool debugShowBaselines,
      bool debugShowLayers,
      bool debugShowPointers,
      bool debugShowRainbow,
      bool showPerformanceOverlay,
      bool showSemanticsDebugger}) {
    return new BrrrConfiguration(
        brrrMode: brrrMode ?? this.brrrMode,
        backupMode: backupMode ?? this.backupMode,
        debugShowGrid: debugShowGrid ?? this.debugShowGrid,
        debugShowSizes: debugShowSizes ?? this.debugShowSizes,
        debugShowBaselines: debugShowBaselines ?? this.debugShowBaselines,
        debugShowLayers: debugShowLayers ?? this.debugShowLayers,
        debugShowPointers: debugShowPointers ?? this.debugShowPointers,
        debugShowRainbow: debugShowRainbow ?? this.debugShowRainbow,
        showPerformanceOverlay:
            showPerformanceOverlay ?? this.showPerformanceOverlay,
        showSemanticsDebugger:
            showSemanticsDebugger ?? this.showSemanticsDebugger);
  }
}
