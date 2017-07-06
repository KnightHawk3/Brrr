import 'dart:async';
import 'package:flutter/material.dart';
import 'brrr_types.dart';
import 'brrr_data.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/*
 Make route point at this and create a stateful form widget.
 */
class BrewCreateScreen extends StatefulWidget {
  const BrewCreateScreen(this.configuration, this.configUpdater, this.brewUpdater);

  final BrrrConfiguration configuration;
  final ValueChanged<BrrrConfiguration> configUpdater;
  final ValueChanged<Brew> brewUpdater;

  @override
  BrewCreateScreenState createState() => new BrewCreateScreenState();
}

// Work out why this is what your using ya?
class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
        ),
      ],
    );
  }
}


class BrewCreateScreenState extends State<BrewCreateScreen> {
  Brew brew = new Brew('');
  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // If it fails validate every time
      showInSnackBar('Fix the invalid input to continue');
    } else {
      form.save();
      showInSnackBar('Brew created!');
      widget.brewUpdater(brew);
    }
  }

  Future<bool> _warnUserAboutInvalidData() async {
    return true;
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('New Brew'));
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateStyle(String value) {
    // FIXME implement this properly.
    return null;
  }

  String _validateOG(String value) {
    // FIXME implement this properly.
    return null;
  }

  String _validateFG(String value) {
    // FIXME implement this properly.
    return null;
  }

  String _validateABV(String value) {
    return null;
  }

  String _validateReview(String value) {
    return null;
  }

  String _validateNotes(String value) {
    return null;
  }

  String _validateBrewDate(String value) {
    return null;
  }

  Widget buildCreatePane(context) {
    return new Form(
        key: _formKey,
        autovalidate: _autovalidate,
        onWillPop: _warnUserAboutInvalidData,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            // im going to comment this once,
            // its basically the same here on out.
            // Name
            new TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.ac_unit), // TODO Get a better icon.
                hintText: 'Try and make it funny!', // Text when you click
                labelText: 'Name', // Text before you click
              ),
              onSaved: (String value) { brew.name = value; }, // Assign it
              validator: _validateName, // A function that returns the error
            ),
            new TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.stars), // TODO Get a better icon
                hintText: 'Style',
                labelText: 'Russian Imperial Stout',
              ),
              onSaved: (String value) { brew.style = value; },
              validator: _validateStyle,
            ),
            new _DateTimePicker(
              labelText: 'Begin Date',
              selectedDate: brew.brewDate,
              selectDate: (DateTime date) {
                setState(() {
                  brew.brewDate = date;
                });
              },
            ),
            new TextFormField(
              decoration: const InputDecoration(
                hintText: 'Smell, taste, good, bad?', // TODO Write this better
                labelText: 'Review',
              ),
              maxLines: 5,
              onSaved: (String value) { brew.review = value; },
            ),
            new TextFormField(
              decoration: const InputDecoration(
                hintText: 'What did you do to make this?',
                labelText: 'Notes',
              ),
              maxLines: 5,
              onSaved: (String value) { brew.notes = value; },
            ),
            new Container(
              padding: const EdgeInsets.all(20.0),
              alignment: const FractionalOffset(0.5, 0.5),
              child: new RaisedButton(
                child: const Text('SUBMIT'),
                onPressed: _handleSubmitted,
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: new Text('Italics indicates required field',
              style: Theme.of(context).textTheme.caption),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: buildCreatePane(context));
  }
}
