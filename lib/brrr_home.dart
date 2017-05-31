import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show debugDumpRenderTree, debugDumpLayerTree, debugDumpSemanticsTree;
import 'package:flutter/scheduler.dart' show timeDilation;
import 'brrr_data.dart';
import 'brrr_list.dart';
import 'brrr_strings.dart';
import 'brew_detail.dart';
import 'brrr_types.dart';

typedef void ModeUpdater(BrrrMode mode);

enum _BrrrMenuItem { autorefresh, refresh, speedUp, speedDown }
enum BrewHomeTab { market, portfolio }

class _NotImplementedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Not Implemented'),
      content: const Text('This feature has not yet been implemented.'),
      actions: <Widget>[
        new FlatButton(
          onPressed: debugDumpApp,
          child: new Row(
            children: <Widget>[
              const Icon(
                Icons.dvr,
                size: 18.0,
              ),
              new Container(
                width: 8.0,
              ),
              const Text('DUMP APP TO CONSOLE'),
            ],
          ),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('OH WELL'),
        ),
      ],
    );
  }
}

class BrrrHome extends StatefulWidget {
  const BrrrHome(this.brews, this.symbols, this.configuration, this.updater);

  final Map<String, Brew> brews;
  final List<String> symbols;
  final BrrrConfiguration configuration;
  final ValueChanged<BrrrConfiguration> updater;

  @override
  BrrrHomeState createState() => new BrrrHomeState();
}

class BrrrHomeState extends State<BrrrHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  final TextEditingController _searchQuery = new TextEditingController();
  bool _autorefresh = false;

  void _handleSearchBegin() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(
      onRemove: () {
        setState(() {
          _isSearching = false;
          _searchQuery.clear();
        });
      },
    ));
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    Navigator.pop(context);
  }

  void _handleBrrrModeChange(BrrrMode value) {
    if (widget.updater != null)
      widget.updater(widget.configuration.copyWith(brrrMode: value));
  }

  void _handleBrrrMenu(BuildContext context, _BrrrMenuItem value) {
    switch (value) {
      case _BrrrMenuItem.autorefresh:
        setState(() {
          _autorefresh = !_autorefresh;
        });
        break;
      case _BrrrMenuItem.refresh:
        showDialog<Null>(context: context, child: new _NotImplementedDialog());
        break;
      case _BrrrMenuItem.speedUp:
        timeDilation /= 5.0;
        break;
      case _BrrrMenuItem.speedDown:
        timeDilation *= 5.0;
        break;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          const DrawerHeader(child: const Center(child: const Text('Brews'))),
          const ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Brew List'),
            selected: true,
          ),
          const ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Account Balance'),
            enabled: false,
          ),
          new ListTile(
            leading: const Icon(Icons.dvr),
            title: const Text('Dump App to Console'),
            onTap: () {
              try {
                debugDumpApp();
                debugDumpRenderTree();
                debugDumpLayerTree();
                debugDumpSemanticsTree();
              } catch (e, stack) {
                debugPrint('Exception while dumping app:\n$e\n$stack');
              }
            },
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.thumb_up),
            title: const Text('Optimistic'),
            trailing: new Radio<BrrrMode>(
              value: BrrrMode.optimistic,
              groupValue: widget.configuration.brrrMode,
              onChanged: _handleBrrrModeChange,
            ),
            onTap: () {
              _handleBrrrModeChange(BrrrMode.optimistic);
            },
          ),
          new ListTile(
            leading: const Icon(Icons.thumb_down),
            title: const Text('Pessimistic'),
            trailing: new Radio<BrrrMode>(
              value: BrrrMode.pessimistic,
              groupValue: widget.configuration.brrrMode,
              onChanged: _handleBrrrModeChange,
            ),
            onTap: () {
              _handleBrrrModeChange(BrrrMode.pessimistic);
            },
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: _handleShowSettings,
          ),
          new ListTile(
            leading: const Icon(Icons.help),
            title: const Text('About'),
            onTap: _handleShowAbout,
          ),
        ],
      ),
    );
  }

  void _handleShowSettings() {
    Navigator.popAndPushNamed(context, '/settings');
  }

  void _handleShowAbout() {
    showAboutDialog(context: context);
  }

  Widget buildAppBar() {
    return new AppBar(
      elevation: 0.0,
      title: new Text(BrrrStrings.of(context).title()),
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearchBegin,
          tooltip: 'Search',
        ),
        new PopupMenuButton<_BrrrMenuItem>(
          onSelected: (_BrrrMenuItem value) {
            _handleBrrrMenu(context, value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<_BrrrMenuItem>>[
                new CheckedPopupMenuItem<_BrrrMenuItem>(
                  value: _BrrrMenuItem.autorefresh,
                  checked: _autorefresh,
                  child: const Text('Autorefresh'),
                ),
                const PopupMenuItem<_BrrrMenuItem>(
                  value: _BrrrMenuItem.refresh,
                  child: const Text('Refresh'),
                ),
                const PopupMenuItem<_BrrrMenuItem>(
                  value: _BrrrMenuItem.speedUp,
                  child: const Text('Increase animation speed'),
                ),
                const PopupMenuItem<_BrrrMenuItem>(
                  value: _BrrrMenuItem.speedDown,
                  child: const Text('Decrease animation speed'),
                ),
              ],
        ),
      ],
      bottom: new TabBar(
        tabs: <Widget>[
          new Tab(text: BrrrStrings.of(context).market()),
          new Tab(text: BrrrStrings.of(context).portfolio()),
        ],
      ),
    );
  }

  Iterable<Brew> _getBrewList(Iterable<String> symbols) {
    return symbols
        .map((String symbol) => widget.brews[symbol])
        .where((Brew brew) => brew != null);
  }

  Iterable<Brew> _filterBySearchQuery(Iterable<Brew> brews) {
    if (_searchQuery.text.isEmpty) return brews;
    final RegExp regexp = new RegExp(_searchQuery.text, caseSensitive: false);
    return brews.where((Brew brew) => brew.icon.contains(regexp));
  }

  Widget _buildBrewList(
      BuildContext context, Iterable<Brew> brews, BrewHomeTab tab) {
    return new BrewList(
      brews: brews.toList(),
      onOpen: (Brew brew) {
        Navigator.pushNamed(context, '/brew/${brew.icon}');
      },
      onShow: (Brew brew) {
        _scaffoldKey.currentState.showBottomSheet<Null>(
            (BuildContext context) => new BrewDetailBottomSheet(brew: brew));
      },
    );
  }

  Widget _buildBrewTab(
      BuildContext context, BrewHomeTab tab, List<String> brewIcons) {
    return new Container(
      key: new ValueKey<BrewHomeTab>(tab),
      child: _buildBrewList(
          context, _filterBySearchQuery(_getBrewList(brewIcons)).toList(), tab),
    );
  }

  static const List<String> portfolioSymbols = const <String>[
    "AAPL",
    "FIZZ",
    "FIVE",
    "FLAT",
    "ZINC",
    "ZNGA"
  ];

  // TODO(abarth): Should we factor this into a SearchBar in the framework?
  Widget buildSearchBar() {
    return new AppBar(
      leading: new IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).accentColor,
        onPressed: _handleSearchEnd,
        tooltip: 'Back',
      ),
      title: new TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search brews',
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  void _handleCreateCompany() {
    showModalBottomSheet<Null>(
      context: context,
      builder: (BuildContext context) => new _CreateCompanySheet(),
    );
  }

  Widget buildFloatingActionButton() {
    return new FloatingActionButton(
      tooltip: 'Create company',
      child: const Icon(Icons.add),
      backgroundColor: Colors.redAccent,
      onPressed: _handleCreateCompany,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: _isSearching ? buildSearchBar() : buildAppBar(),
        floatingActionButton: buildFloatingActionButton(),
        drawer: _buildDrawer(context),
        body: new TabBarView(
          children: <Widget>[
            _buildBrewTab(context, BrewHomeTab.market, widget.symbols),
            _buildBrewTab(context, BrewHomeTab.portfolio, portfolioSymbols),
          ],
        ),
      ),
    );
  }
}

class _CreateCompanySheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO(ianh): Fill this out.
    return new Column(
      children: <Widget>[
        const TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Company Name',
          ),
        ),
      ],
    );
  }
}
