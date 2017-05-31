import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

// Wrappers for strings that are shown in the UI.  The strings can be
// translated for different locales using the Dart intl package.
//
// Locale-specific values for the strings live in the i18n/*.arb files.
//
// To generate the brrr_messages_*.dart files from the ARB files, run:
//   pub run intl:generate_from_arb --output-dir=lib/i18n --generated-file-prefix=brrr_ --no-use-deferred-loading lib/brrr_strings.dart lib/i18n/brrr_*.arb

class BrrrStrings extends LocaleQueryData {
  static BrrrStrings of(BuildContext context) {
    return LocaleQuery.of(context);
  }

  static final BrrrStrings instance = new BrrrStrings();

  String title() => Intl.message('Brrr',
      name: 'title', desc: 'Title for the Brrr application');

  String market() => Intl.message('FERMENTING',
      name: 'fermenting', desc: 'Label for the Market tab');

  String portfolio() => Intl.message('FINISHED',
      name: 'finished', desc: 'Label for the Finished tab');
}
