import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqladvocate/color.dart';
import 'package:sqladvocate/contactlist.dart';
import 'package:sqladvocate/contactscreen.dart';
import 'package:sqladvocate/database.dart';
import 'package:sqladvocate/datetimepicker.dart';
import 'package:sqladvocate/eventcalendar.dart';
import 'package:sqladvocate/historydatabase.dart';
import 'package:sqladvocate/recurring.dart';

enum RecurrenceRuleEndType { Indefinite, MaxOccurrences, SpecifiedEndDate }

// ignore: must_be_immutable
class ClientAddScreen2 extends StatefulWidget {
  final Client getclientdata;
  final ConatctList contact;
  final int appointid;
  DateTime dateTime;
  final Calendar _calendar;
  final Event _event;
  final RecurringEventDialog _recurringEventDialog;

  ClientAddScreen2(this.getclientdata, this.contact, this.appointid,
      this.dateTime, this._calendar,
      [this._event, this._recurringEventDialog]);

  @override
  _CalendarEventPageState createState() {
    return _CalendarEventPageState(
        getclientdata, dateTime, _calendar, _event, _recurringEventDialog);
  }
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class _CalendarEventPageState extends State<ClientAddScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Calendar _calendar;
  DateTime dateTime;
  final Client getclientdata;
  Event _event;
  DeviceCalendarPlugin _deviceCalendarPlugin;
  RecurringEventDialog _recurringEventDialog;
  TextEditingController clientname = new TextEditingController();
  TextEditingController clientphonenumber = new TextEditingController();
  TextEditingController clientaddress = new TextEditingController();
  TextEditingController clientage = new TextEditingController();
  TextEditingController clientappointdate = new TextEditingController();
  DateTime _startDate;
  TimeOfDay _startTime = TimeOfDay.now();

  DateTime _endDate;
  TimeOfDay _endTime;

  bool _autovalidate = false;
  DayOfWeekGroup _dayOfWeekGroup = DayOfWeekGroup.None;

  bool _isRecurringEvent = false;
  bool _isByDayOfMonth = false;
  RecurrenceRuleEndType _recurrenceRuleEndType;
  int _totalOccurrences;
  int _interval;
  DateTime _recurrenceEndDate;

  RecurrenceFrequency _recurrenceFrequency = RecurrenceFrequency.Daily;
  // ignore: deprecated_member_use
  List<DayOfWeek> _daysOfWeek = List<DayOfWeek>();
  int _dayOfMonth;
  // ignore: deprecated_member_use
  List<int> _validDaysOfMonth = List<int>();
  MonthOfYear _monthOfYear;
  WeekNumber _weekOfMonth;
  DayOfWeek _selectedDayOfWeek = DayOfWeek.Monday;

  // ignore: deprecated_member_use
  List<Attendee> _attendees = List<Attendee>();
  // ignore: deprecated_member_use
  List<Reminder> _reminders = List<Reminder>();

  _CalendarEventPageState(this.getclientdata, this.dateTime, this._calendar,
      this._event, this._recurringEventDialog) {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    _recurringEventDialog = this._recurringEventDialog;

    // ignore: deprecated_member_use
    _attendees = List<Attendee>();
    // ignore: deprecated_member_use
    _reminders = List<Reminder>();
    _recurrenceRuleEndType = RecurrenceRuleEndType.Indefinite;

    if (this._event == null) {
      // _startDate = DateTime.now();
      _startDate = getclientdata == null
          ? dateTime
          : DateTime.parse(getclientdata.startdate);
      _endDate = getclientdata == null
          ? dateTime
          : DateTime.parse(getclientdata.startdate);
      //_endDate =dateTime.add(Duration(hours: 1));
      _event = Event(this._calendar.id, start: _startDate, end: _endDate);

      _recurrenceEndDate = _endDate;
      _dayOfMonth = 1;
      _monthOfYear = MonthOfYear.January;
      _weekOfMonth = WeekNumber.First;
    } else {
      _startDate = _event.start;
      _endDate = _event.end;
      _isRecurringEvent = _event.recurrenceRule != null;

      if (_event.attendees.isNotEmpty) {
        _attendees.addAll(_event.attendees);
      }

      if (_event.reminders.isNotEmpty) {
        _reminders.addAll(_event.reminders);
      }

      if (_isRecurringEvent) {
        _interval = _event.recurrenceRule.interval;
        _totalOccurrences = _event.recurrenceRule.totalOccurrences;
        _recurrenceFrequency = _event.recurrenceRule.recurrenceFrequency;

        if (_totalOccurrences != null) {
          _recurrenceRuleEndType = RecurrenceRuleEndType.MaxOccurrences;
        }

        if (_event.recurrenceRule.endDate != null) {
          _recurrenceRuleEndType = RecurrenceRuleEndType.SpecifiedEndDate;
          _recurrenceEndDate = _event.recurrenceRule.endDate;
        }

        _isByDayOfMonth = _event.recurrenceRule.weekOfMonth == null;
        // ignore: deprecated_member_use
        _daysOfWeek = _event.recurrenceRule.daysOfWeek ?? List<DayOfWeek>();
        _monthOfYear = _event.recurrenceRule.monthOfYear ?? MonthOfYear.January;
        _weekOfMonth = _event.recurrenceRule.weekOfMonth ?? WeekNumber.First;
        _selectedDayOfWeek =
            _daysOfWeek.isNotEmpty ? _daysOfWeek.first : DayOfWeek.Monday;
        _dayOfMonth = _event.recurrenceRule.dayOfMonth ?? 1;

        if (_daysOfWeek.isNotEmpty) {
          _updateDaysOfWeekGroup();
        }
      }
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

// Getting days of the current month (or a selected month for the yearly recurrence) as a default
    _getValidDaysOfMonth(_recurrenceFrequency);
  }
  String dropdownValue = 'Highcourt';
  @override
  void initState() {
    super.initState();
    getText();
    getlocaldata();
  }

  String name;
  List users = [
    const Item(
        'Highcourt',
        Icon(
          Icons.circle,
          color: Colors.green,
        )),
    const Item(
        'Supreme Court',
        Icon(
          Icons.circle,
          color: Colors.red,
        )),
    const Item(
        'Dist.court/Tribunals/Commissions',
        Icon(
          Icons.circle,
          color: Colors.blue,
        )),
    const Item(
        'Appointments/Meetings/Time',
        Icon(
          Icons.circle,
          color: Colors.purple,
        )),
  ];
  getlocaldata() async {
    SharedPreferences _localstorage = await SharedPreferences.getInstance();

    userId = _localstorage.getString('userid');
    print(userId);
  }

  var phone = '';
  setphonenumber() {
    if (widget.getclientdata != null) {
      return widget.getclientdata.clientphonenumber;
    } else if (widget.contact == null) {
      return phone;
    } else {
      return widget.contact.phone;
    }
  }

  void getText() async {
    setState(() {
      // clientphonenumber = new TextEditingController(
      //     text:
      //      widget.contact == null
      //         ? widget.getclientdata.clientphonenumber
      //         : widget.contact.phone);

      clientphonenumber = new TextEditingController(text: setphonenumber());
      clientname = new TextEditingController(
          text: widget.getclientdata == null
              ? ''
              : widget.getclientdata.clientname);
      clientaddress = new TextEditingController(
          text: widget.getclientdata == null
              ? ''
              : widget.getclientdata.clientaddress);
      clientage = new TextEditingController(
          text: widget.getclientdata == null
              ? ''
              : widget.getclientdata.clientage);
      clientappointdate = new TextEditingController(
          text: widget.getclientdata == null
              ? ''
              : widget.getclientdata.startdate);
    });
  }

  checkcolor(String courtname) {
    if (courtname == 'Highcourt') {
      return TextStyle(color: Colors.green);
    } else if (courtname == 'Supreme Court') {
      return TextStyle(color: Colors.red);
    } else if (courtname == 'Dist.court/Tribunals/Commissions') {
      return TextStyle(color: Colors.blue);
    } else if (courtname == 'Appointments/Meetings/Time') {
      return TextStyle(color: Colors.purple);
    }
  }

  checksimplecolor() {
    if (dropdownValue == 'Highcourt') {
      return TextStyle(color: Colors.green);
    } else if (dropdownValue == 'Supreme Court') {
      return TextStyle(color: Colors.red);
    } else if (dropdownValue == 'Dist.court/Tribunals/Commissions') {
      return TextStyle(color: Colors.blue);
    } else if (dropdownValue == 'Appointments/Meetings/Time') {
      return TextStyle(color: Colors.purple);
    }
  }

  void printAttendeeDetails(Attendee attendee) {
    print(
        'attendee name: ${attendee.name}, email address: ${attendee.emailAddress}, type: ${attendee.iosAttendeeDetails?.role?.enumToString}');
    print(
        'ios specifics - status: ${attendee.iosAttendeeDetails?.attendanceStatus}, type: ${attendee.iosAttendeeDetails?.role?.enumToString}');
    print(
        'android specifics - status ${attendee.androidAttendeeDetails?.attendanceStatus}, type: ${attendee.androidAttendeeDetails?.role?.enumToString}');
  }

  dialogbox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Column(
              children: <Widget>[
                Container(
                  child: Text('CONFIRMATION'),
                ),
                Divider(color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 200.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(67),
                    ),
                    child: Text(
                      'Are you sure to delete this appointment',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // ignore: deprecated_member_use
                RaisedButton(
                    color: Colors.grey,
                    child: Text(
                      'YES',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      dbclientManager.deleteClient(widget.appointid);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => EventScreen()),
                          (Route<dynamic> route) => false);
                    }),
                // ignore: deprecated_member_use
                RaisedButton(
                    color: topcenterlogin,
                    child: Text(
                      'NO',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        bottomNavigationBar:  RaisedButton(
                  color: topcenterlogin,
                  child: Text('save'),
                  onPressed: () async {
                    final FormState form = _formKey.currentState;
                    if (!form.validate()) {
                      _autovalidate = true; // Start validating on every change.
                      showInSnackBar(
                          'Please fix the errors in red before submitting.');
                    } else {
                      form.save();
                      submitStudent(context);
                      if (_isRecurringEvent) {
                        if (!_isByDayOfMonth &&
                            (_recurrenceFrequency ==
                                    RecurrenceFrequency.Monthly ||
                                _recurrenceFrequency ==
                                    RecurrenceFrequency.Yearly)) {
                          _daysOfWeek.clear();
                          _daysOfWeek.add(_selectedDayOfWeek);
                        } else {
                          _weekOfMonth = null;
                        }

                        _event.recurrenceRule = RecurrenceRule(
                            _recurrenceFrequency,
                            interval: _interval,
                            totalOccurrences: _totalOccurrences,
                            endDate: _recurrenceRuleEndType ==
                                    RecurrenceRuleEndType.SpecifiedEndDate
                                ? _recurrenceEndDate
                                : null,
                            daysOfWeek: _daysOfWeek,
                            dayOfMonth: _dayOfMonth,
                            monthOfYear: _monthOfYear,
                            weekOfMonth: _weekOfMonth);
                      }
                      _event.attendees = _attendees;
                      _event.reminders = _reminders;
                      var createEventResult = await _deviceCalendarPlugin
                          .createOrUpdateEvent(_event);
                      if (createEventResult.isSuccess) {
                      } else {
                        showInSnackBar(
                            createEventResult.errorMessages.join(' | '));
                      }
                    }
                  },
                ),
        appBar: AppBar(
          backgroundColor: topcenterlogin,
          title: Text('Case details'),
          actions: <Widget>[
            widget.appointid == null
                ? Container()
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      dialogbox();
                    })
          ],
        ),
        body: SingleChildScrollView(
          child:
           Form(
            // ignore: deprecated_member_use
            autovalidate: _autovalidate,
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: clientphonenumber,
                    keyboardType: TextInputType.number,
                    style: widget.getclientdata == null
                        ? TextStyle(color: Colors.black)
                        : checkcolor(widget.getclientdata.clientcourt),
                    maxLength: 15,
                    decoration: new InputDecoration(
                        //                              focusedBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black, width: 1.0),
                        // ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.call,
                            color: Colors.grey[600],
                          ),
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactScreen(
                                        getclientdata: widget.getclientdata,
                                        datetime: widget.dateTime,
                                      ))),
                        ),
                        filled: true,
                        labelText: 'Phone Number',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.vertical(),
                        )),
                    validator: (value) {
                      if (value.length == 0) {
                        return "Please enter phonenumber";
                      } else if (value.length <= 9) {
                        return "Please enter valid phonenumber";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => name = value,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      //  key: Key('titleField'),
                      controller: clientname,
                      key: Key('titleField'),
                      style: widget.getclientdata == null
                          ? TextStyle(color: Colors.black)
                          : checkcolor(widget.getclientdata.clientcourt),
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                          //                                    focusedBorder: OutlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black, width: 1.0),
                          // ),
                          filled: true,
                          labelText: 'Title',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.vertical(),
                          )),
                      validator: (value) {
                        if (value.length == 0) {
                          return "Please enter title";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value) {
                        _event.title = value;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: clientage,
                      style: widget.getclientdata == null
                          ? TextStyle(color: Colors.black)
                          : checkcolor(widget.getclientdata.clientcourt),
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 5,
                      maxLength: 350,
                      decoration: new InputDecoration(
                          filled: true,
                          labelText: 'Proceeding',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.vertical(),
                          )),
                      validator: (value) {
                        if (value.length == 0) {
                          return "Please enter Proceeding";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => name = value,
                    )),
                _dateFormatchange(widget.dateTime),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: 370,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: widget.getclientdata == null
                              ? dropdownValue
                              : widget.getclientdata.clientcourt,
                          items: users.map((user) {
                            return DropdownMenuItem(
                              value: user.name,
                              // widget.getclientdata==null? user.name: widget.getclientdata.clientcourt,
                              child: Row(
                                children: [
                                  user.icon,
                                  SizedBox(width: 10),
                                  Text(user.name, style: checkcolor(user.name)
                                      //  TextStyle(
                                      //     color: Colors.red),
                                      ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value;
                              if (widget.getclientdata != null) {
                                widget.getclientdata.clientcourt =
                                    dropdownValue;
                              }
                            });
                          },
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(height: 2, color: Colors.black),
                ),
                _getdateText(),
                SizedBox(
                  height: 20,
                ),
                // ignore: deprecated_member_use
                // RaisedButton(
                //   color: topcenterlogin,
                //   child: Text('save'),
                //   onPressed: () async {
                //     final FormState form = _formKey.currentState;
                //     if (!form.validate()) {
                //       _autovalidate = true; // Start validating on every change.
                //       showInSnackBar(
                //           'Please fix the errors in red before submitting.');
                //     } else {
                //       form.save();
                //       submitStudent(context);
                //       if (_isRecurringEvent) {
                //         if (!_isByDayOfMonth &&
                //             (_recurrenceFrequency ==
                //                     RecurrenceFrequency.Monthly ||
                //                 _recurrenceFrequency ==
                //                     RecurrenceFrequency.Yearly)) {
                //           _daysOfWeek.clear();
                //           _daysOfWeek.add(_selectedDayOfWeek);
                //         } else {
                //           _weekOfMonth = null;
                //         }

                //         _event.recurrenceRule = RecurrenceRule(
                //             _recurrenceFrequency,
                //             interval: _interval,
                //             totalOccurrences: _totalOccurrences,
                //             endDate: _recurrenceRuleEndType ==
                //                     RecurrenceRuleEndType.SpecifiedEndDate
                //                 ? _recurrenceEndDate
                //                 : null,
                //             daysOfWeek: _daysOfWeek,
                //             dayOfMonth: _dayOfMonth,
                //             monthOfYear: _monthOfYear,
                //             weekOfMonth: _weekOfMonth);
                //       }
                //       _event.attendees = _attendees;
                //       _event.reminders = _reminders;
                //       var createEventResult = await _deviceCalendarPlugin
                //           .createOrUpdateEvent(_event);
                //       if (createEventResult.isSuccess) {
                //       } else {
                //         showInSnackBar(
                //             createEventResult.errorMessages.join(' | '));
                //       }
                //     }
                //   },
                // ),
                if (_isRecurringEvent) ...[
                  ListTile(
                    leading: Text('Select a Recurrence Type'),
                    trailing: DropdownButton<RecurrenceFrequency>(
                      onChanged: (selectedFrequency) {
                        setState(() {
                          _recurrenceFrequency = selectedFrequency;
                          _getValidDaysOfMonth(_recurrenceFrequency);
                        });
                      },
                      value: _recurrenceFrequency,
                      items: RecurrenceFrequency.values
                          .map((frequency) => DropdownMenuItem(
                                value: frequency,
                                child: _recurrenceFrequencyToText(frequency),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: Row(
                      children: <Widget>[
                        Text('Repeat Every '),
                        Flexible(
                          child: TextFormField(
                            initialValue: _interval?.toString() ?? '1',
                            decoration: const InputDecoration(hintText: '1'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              // ignore: deprecated_member_use
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],
                            validator: _validateInterval,
                            textAlign: TextAlign.right,
                            onSaved: (String value) {
                              _interval = int.tryParse(value);
                            },
                          ),
                        ),
                        _recurrenceFrequencyToIntervalText(
                            _recurrenceFrequency),
                      ],
                    ),
                  ),
                  if (_recurrenceFrequency == RecurrenceFrequency.Weekly) ...[
                    Column(
                      children: [
                        ...DayOfWeek.values.map((day) {
                          return CheckboxListTile(
                            title: Text(day.enumToString),
                            value:
                                _daysOfWeek?.any((dow) => dow == day) ?? false,
                            onChanged: (selected) {
                              setState(() {
                                if (selected) {
                                  _daysOfWeek.add(day);
                                } else {
                                  _daysOfWeek.remove(day);
                                }
                                _updateDaysOfWeekGroup(selectedDay: day);
                              });
                            },
                          );
                        }),
                        Divider(color: Colors.black),
                        ...DayOfWeekGroup.values.map((group) {
                          return RadioListTile(
                              title: Text(group.enumToString),
                              value: group,
                              groupValue: _dayOfWeekGroup,
                              onChanged: (selected) {
                                setState(() {
                                  _dayOfWeekGroup = selected;
                                  _updateDaysOfWeek();
                                });
                              },
                              controlAffinity:
                                  ListTileControlAffinity.trailing);
                        }),
                      ],
                    )
                  ],
                  if (_recurrenceFrequency == RecurrenceFrequency.Monthly ||
                      _recurrenceFrequency == RecurrenceFrequency.Yearly) ...[
                    SwitchListTile(
                      value: _isByDayOfMonth,
                      onChanged: (value) =>
                          setState(() => _isByDayOfMonth = value),
                      title: Text('By day of the month'),
                    )
                  ],
                  if (_recurrenceFrequency == RecurrenceFrequency.Yearly &&
                      _isByDayOfMonth) ...[
                    ListTile(
                      leading: Text('Month of the year'),
                      trailing: DropdownButton<MonthOfYear>(
                        onChanged: (value) {
                          setState(() {
                            _monthOfYear = value;
                            _getValidDaysOfMonth(_recurrenceFrequency);
                          });
                        },
                        value: _monthOfYear,
                        items: MonthOfYear.values
                            .map((month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(month.enumToString),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  if (_isByDayOfMonth &&
                      (_recurrenceFrequency == RecurrenceFrequency.Monthly ||
                          _recurrenceFrequency ==
                              RecurrenceFrequency.Yearly)) ...[
                    ListTile(
                      leading: Text('Day of the month'),
                      trailing: DropdownButton<int>(
                        onChanged: (value) {
                          setState(() {
                            _dayOfMonth = value;
                          });
                        },
                        value: _dayOfMonth,
                        items: _validDaysOfMonth
                            .map((day) => DropdownMenuItem(
                                  value: day,
                                  child: Text(day.toString()),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  if (!_isByDayOfMonth &&
                      (_recurrenceFrequency == RecurrenceFrequency.Monthly ||
                          _recurrenceFrequency ==
                              RecurrenceFrequency.Yearly)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              _recurrenceFrequencyToText(_recurrenceFrequency)
                                      .data +
                                  ' on the ')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: DropdownButton<WeekNumber>(
                              onChanged: (value) {
                                setState(() {
                                  _weekOfMonth = value;
                                });
                              },
                              value: _weekOfMonth ?? WeekNumber.First,
                              items: WeekNumber.values
                                  .map((weekNum) => DropdownMenuItem(
                                        value: weekNum,
                                        child: Text(weekNum.enumToString),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Flexible(
                            child: DropdownButton<DayOfWeek>(
                              onChanged: (value) {
                                setState(() {
                                  _selectedDayOfWeek = value;
                                });
                              },
                              value: DayOfWeek.values[_selectedDayOfWeek.index],
                              items: DayOfWeek.values
                                  .map((day) => DropdownMenuItem(
                                        value: day,
                                        child: Text(day.enumToString),
                                      ))
                                  .toList(),
                            ),
                          ),
                          if (_recurrenceFrequency ==
                              RecurrenceFrequency.Yearly) ...[
                            Text('of'),
                            Flexible(
                              child: DropdownButton<MonthOfYear>(
                                onChanged: (value) {
                                  setState(() {
                                    _monthOfYear = value;
                                  });
                                },
                                value: _monthOfYear,
                                items: MonthOfYear.values
                                    .map((month) => DropdownMenuItem(
                                          value: month,
                                          child: Text(month.enumToString),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                  ListTile(
                    leading: Text('Event ends'),
                    trailing: DropdownButton<RecurrenceRuleEndType>(
                      onChanged: (value) {
                        setState(() {
                          _recurrenceRuleEndType = value;
                        });
                      },
                      value: _recurrenceRuleEndType,
                      items: RecurrenceRuleEndType.values
                          .map((frequency) => DropdownMenuItem(
                                value: frequency,
                                child: _recurrenceRuleEndTypeToText(frequency),
                              ))
                          .toList(),
                    ),
                  ),
                  if (_recurrenceRuleEndType ==
                      RecurrenceRuleEndType.MaxOccurrences)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Row(
                        children: <Widget>[
                          Text('For the next '),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  _totalOccurrences?.toString() ?? '1',
                              decoration: const InputDecoration(hintText: '1'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: _validateTotalOccurrences,
                              textAlign: TextAlign.right,
                              onSaved: (String value) {
                                _totalOccurrences = int.tryParse(value);
                              },
                            ),
                          ),
                          Text(' occurrences'),
                        ],
                      ),
                    ),
                  if (_recurrenceRuleEndType ==
                      RecurrenceRuleEndType.SpecifiedEndDate)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DateTimePicker(
                        labelText: 'Date',
                        enableTime: false,
                        selectedDate: _recurrenceEndDate,
                        selectDate: (DateTime date) {
                          setState(() {
                            _recurrenceEndDate = date;
                          });
                        },
                      ),
                    ),
                ],
//                 if (!_calendar.isReadOnly &&
//                     (_event.eventId?.isNotEmpty ?? false)) ...[
// // ignore: deprecated_member_use
//                   RaisedButton(
//                     key: Key('deleteEventButton'),
//                     textColor: Colors.white,
//                     color: Colors.red,
//                     child: Text('Delete'),
//                     onPressed: () async {
//                       var result = true;
//                       if (!_isRecurringEvent) {
//                         await _deviceCalendarPlugin.deleteEvent(
//                             _calendar.id, _event.eventId);
//                       } else {
//                         result = await showDialog<bool>(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (BuildContext context) {
//                               return _recurringEventDialog;
//                             });
//                       }

//                       if (result) {
//                         Navigator.pop(context, true);
//                       }
//                     },
//                   ),
//                 ]
              ],
            ),
         
           ),
        ),
        //   ),
      );
    } catch (e) {
      return Scaffold(
          body: Container(
        height: 400,
        child: Text(e),
      ));
    }

//     try{
//          return Scaffold(
//       // ignore: deprecated_member_use
//       bottomNavigationBar: RaisedButton(
//         color: topcenterlogin,
//         child: Text('save'),
//         onPressed: () async {
//           final FormState form = _formKey.currentState;
//           if (!form.validate()) {
//             _autovalidate = true; // Start validating on every change.
//             showInSnackBar('Please fix the errors in red before submitting.');
//           } else {
//             form.save();
//             submitStudent(context);
//             if (_isRecurringEvent) {
//               if (!_isByDayOfMonth &&
//                   (_recurrenceFrequency == RecurrenceFrequency.Monthly ||
//                       _recurrenceFrequency == RecurrenceFrequency.Yearly)) {
// // Setting day of the week parameters for WeekNumber to avoid clashing with the weekly recurrence values
//                 _daysOfWeek.clear();
//                 _daysOfWeek.add(_selectedDayOfWeek);
//               } else {
//                 _weekOfMonth = null;
//               }

//               _event.recurrenceRule = RecurrenceRule(_recurrenceFrequency,
//                   interval: _interval,
//                   totalOccurrences: _totalOccurrences,
//                   endDate: _recurrenceRuleEndType ==
//                           RecurrenceRuleEndType.SpecifiedEndDate
//                       ? _recurrenceEndDate
//                       : null,
//                   daysOfWeek: _daysOfWeek,
//                   dayOfMonth: _dayOfMonth,
//                   monthOfYear: _monthOfYear,
//                   weekOfMonth: _weekOfMonth);
//             }
//             _event.attendees = _attendees;
//             _event.reminders = _reminders;
//             var createEventResult =
//                 await _deviceCalendarPlugin.createOrUpdateEvent(_event);
//             if (createEventResult.isSuccess) {
//               // Navigator.pop(context, true);
//             } else {
//               showInSnackBar(createEventResult.errorMessages.join(' | '));
//             }
//           }
//         },
//       ),
//       //  key: _scaffoldKey,
//       appBar: AppBar(
//           // centerTitle: true,
//           // flexibleSpace: Container(
//           //   decoration: BoxDecoration(color: topcenterlogin),
//           // ),
//           backgroundColor: topcenterlogin,
//           title: Text('Case details'),actions: <Widget>[
//              widget.appointid == null
//                                           ? Container()
//                                           : IconButton(
//                                               icon: Icon(
//                                                 Icons.delete,
//                                                 color: Colors.white,
//                                               ),
//                                               onPressed: () {
//                                                 dialogbox();

//                                               })
//           ],

//           ),
//       body: SingleChildScrollView(
//         child:
//         // AbsorbPointer(
//         //   absorbing: _calendar.isReadOnly,
//         //   child:
//           Column(
//             children: [
//               Form(
//                 // ignore: deprecated_member_use
//                 autovalidate: _autovalidate,
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: TextFormField(
//                         controller: clientphonenumber,
//                         keyboardType: TextInputType.number,
//                         style: widget.getclientdata == null
//                             ? TextStyle(color:Colors.black)
//                             : checkcolor(widget.getclientdata.clientcourt),
//                         maxLength: 15,
//                         decoration: new InputDecoration(
//                             //                              focusedBorder: OutlineInputBorder(
//                             //     borderSide: BorderSide(color: Colors.black, width: 1.0),
//                             // ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 Icons.call,
//                                 color: Colors.grey[600],
//                               ),
//                               onPressed: () => Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => ContactScreen(
//                                             getclientdata: widget.getclientdata,
//                                             datetime: widget.dateTime,
//                                           ))),
//                             ),
//                             filled: true,
//                             labelText: 'Phone Number',
//                             border: new OutlineInputBorder(
//                               borderRadius: new BorderRadius.vertical(),
//                             )),
//                         validator: (value) {
//                           if (value.length == 0) {
//                             return "Please enter phonenumber";
//                           } else if (value.length <= 9) {
//                             return "Please enter valid phonenumber";
//                           } else {
//                             return null;
//                           }
//                         },
//                         onSaved: (value) => name = value,
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: TextFormField(
//                           //  key: Key('titleField'),
//                           controller: clientname,
//                           key: Key('titleField'),
//                           style: widget.getclientdata == null
//                               ? TextStyle(color:Colors.black)
//                               : checkcolor(widget.getclientdata.clientcourt),
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: new InputDecoration(
//                               //                                    focusedBorder: OutlineInputBorder(
//                               //     borderSide: BorderSide(color: Colors.black, width: 1.0),
//                               // ),
//                               filled: true,
//                               labelText: 'Title',
//                               border: new OutlineInputBorder(
//                                 borderRadius: new BorderRadius.vertical(),
//                               )),
//                           validator: (value) {
//                             if (value.length == 0) {
//                               return "Please enter title";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onSaved: (String value) {
//                             _event.title = value;
//                           },
//                         )),
//                     Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: TextFormField(
//                           controller: clientage,
//                           style: widget.getclientdata == null
//                               ? TextStyle(color:Colors.black)
//                               : checkcolor(widget.getclientdata.clientcourt),
//                           keyboardType: TextInputType.emailAddress,
//                           maxLines: 5,
//                           maxLength: 350,
//                           decoration: new InputDecoration(
//                               filled: true,

//                               labelText: 'Proceeding',
//                               border: new OutlineInputBorder(
//                                 borderRadius: new BorderRadius.vertical(),
//                               )),
//                           validator: (value) {
//                             if (value.length == 0) {
//                               return "Please enter Proceeding";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onSaved: (value) => name = value,
//                         )),
//                          _dateFormatchange(widget.dateTime),
//                         Padding(padding: EdgeInsets.all(5),
//                         child:
//                         Container(
//                           width: 370,
//                           child:
//                      DropdownButtonHideUnderline(child:
//                     DropdownButton(
//                       value: widget.getclientdata == null
//                           ? dropdownValue
//                           : widget.getclientdata.clientcourt,
//                       items: users.map((user) {
//                         return DropdownMenuItem(
//                           value: user.name,
//                           // widget.getclientdata==null? user.name: widget.getclientdata.clientcourt,
//                           child: Row(
//                             children: [
//                               user.icon,
//                               SizedBox(width: 10),
//                               Text(user.name, style: checkcolor(user.name)
//                                   //  TextStyle(
//                                   //     color: Colors.red),
//                                   ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           dropdownValue = value;
//                           if (widget.getclientdata != null) {
//                             widget.getclientdata.clientcourt = dropdownValue;
//                           }
//                         });
//                       },
//                     ),),
//                         )
//                         ),
//                         Padding(padding: EdgeInsets.only(left: 10,right: 10),
//                         child:
//   Divider(
//                                                               height: 2,
//                                                               color:
//                                                                   Colors.black),),

//  _getdateText(),

//                     if (_isRecurringEvent) ...[
//                       ListTile(
//                         leading: Text('Select a Recurrence Type'),
//                         trailing: DropdownButton<RecurrenceFrequency>(
//                           onChanged: (selectedFrequency) {
//                             setState(() {
//                               _recurrenceFrequency = selectedFrequency;
//                               _getValidDaysOfMonth(_recurrenceFrequency);
//                             });
//                           },
//                           value: _recurrenceFrequency,
//                           items: RecurrenceFrequency.values
//                               .map((frequency) => DropdownMenuItem(
//                                     value: frequency,
//                                     child:
//                                         _recurrenceFrequencyToText(frequency),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//                         child: Row(
//                           children: <Widget>[
//                             Text('Repeat Every '),
//                             Flexible(
//                               child: TextFormField(
//                                 initialValue: _interval?.toString() ?? '1',
//                                 decoration:
//                                     const InputDecoration(hintText: '1'),
//                                 keyboardType: TextInputType.number,
//                                 inputFormatters: [
//                                   // ignore: deprecated_member_use
//                                   WhitelistingTextInputFormatter.digitsOnly,
//                                   LengthLimitingTextInputFormatter(2)
//                                 ],
//                                 validator: _validateInterval,
//                                 textAlign: TextAlign.right,
//                                 onSaved: (String value) {
//                                   _interval = int.tryParse(value);
//                                 },
//                               ),
//                             ),
//                             _recurrenceFrequencyToIntervalText(
//                                 _recurrenceFrequency),
//                           ],
//                         ),
//                       ),
//                       if (_recurrenceFrequency ==
//                           RecurrenceFrequency.Weekly) ...[
//                         Column(
//                           children: [
//                             ...DayOfWeek.values.map((day) {
//                               return CheckboxListTile(
//                                 title: Text(day.enumToString),
//                                 value: _daysOfWeek?.any((dow) => dow == day) ??
//                                     false,
//                                 onChanged: (selected) {
//                                   setState(() {
//                                     if (selected) {
//                                       _daysOfWeek.add(day);
//                                     } else {
//                                       _daysOfWeek.remove(day);
//                                     }
//                                     _updateDaysOfWeekGroup(selectedDay: day);
//                                   });
//                                 },
//                               );
//                             }),
//                             Divider(color: Colors.black),
//                             ...DayOfWeekGroup.values.map((group) {
//                               return RadioListTile(
//                                   title: Text(group.enumToString),
//                                   value: group,
//                                   groupValue: _dayOfWeekGroup,
//                                   onChanged: (selected) {
//                                     setState(() {
//                                       _dayOfWeekGroup = selected;
//                                       _updateDaysOfWeek();
//                                     });
//                                   },
//                                   controlAffinity:
//                                       ListTileControlAffinity.trailing);
//                             }),
//                           ],
//                         )
//                       ],
//                       if (_recurrenceFrequency == RecurrenceFrequency.Monthly ||
//                           _recurrenceFrequency ==
//                               RecurrenceFrequency.Yearly) ...[
//                         SwitchListTile(
//                           value: _isByDayOfMonth,
//                           onChanged: (value) =>
//                               setState(() => _isByDayOfMonth = value),
//                           title: Text('By day of the month'),
//                         )
//                       ],
//                       if (_recurrenceFrequency == RecurrenceFrequency.Yearly &&
//                           _isByDayOfMonth) ...[
//                         ListTile(
//                           leading: Text('Month of the year'),
//                           trailing: DropdownButton<MonthOfYear>(
//                             onChanged: (value) {
//                               setState(() {
//                                 _monthOfYear = value;
//                                 _getValidDaysOfMonth(_recurrenceFrequency);
//                               });
//                             },
//                             value: _monthOfYear,
//                             items: MonthOfYear.values
//                                 .map((month) => DropdownMenuItem(
//                                       value: month,
//                                       child: Text(month.enumToString),
//                                     ))
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                       if (_isByDayOfMonth &&
//                           (_recurrenceFrequency ==
//                                   RecurrenceFrequency.Monthly ||
//                               _recurrenceFrequency ==
//                                   RecurrenceFrequency.Yearly)) ...[
//                         ListTile(
//                           leading: Text('Day of the month'),
//                           trailing: DropdownButton<int>(
//                             onChanged: (value) {
//                               setState(() {
//                                 _dayOfMonth = value;
//                               });
//                             },
//                             value: _dayOfMonth,
//                             items: _validDaysOfMonth
//                                 .map((day) => DropdownMenuItem(
//                                       value: day,
//                                       child: Text(day.toString()),
//                                     ))
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                       if (!_isByDayOfMonth &&
//                           (_recurrenceFrequency ==
//                                   RecurrenceFrequency.Monthly ||
//                               _recurrenceFrequency ==
//                                   RecurrenceFrequency.Yearly)) ...[
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                           child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(_recurrenceFrequencyToText(
//                                           _recurrenceFrequency)
//                                       .data +
//                                   ' on the ')),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Flexible(
//                                 child: DropdownButton<WeekNumber>(
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _weekOfMonth = value;
//                                     });
//                                   },
//                                   value: _weekOfMonth ?? WeekNumber.First,
//                                   items: WeekNumber.values
//                                       .map((weekNum) => DropdownMenuItem(
//                                             value: weekNum,
//                                             child: Text(weekNum.enumToString),
//                                           ))
//                                       .toList(),
//                                 ),
//                               ),
//                               Flexible(
//                                 child: DropdownButton<DayOfWeek>(
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedDayOfWeek = value;
//                                     });
//                                   },
//                                   value: DayOfWeek
//                                       .values[_selectedDayOfWeek.index],
//                                   items: DayOfWeek.values
//                                       .map((day) => DropdownMenuItem(
//                                             value: day,
//                                             child: Text(day.enumToString),
//                                           ))
//                                       .toList(),
//                                 ),
//                               ),
//                               if (_recurrenceFrequency ==
//                                   RecurrenceFrequency.Yearly) ...[
//                                 Text('of'),
//                                 Flexible(
//                                   child: DropdownButton<MonthOfYear>(
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _monthOfYear = value;
//                                       });
//                                     },
//                                     value: _monthOfYear,
//                                     items: MonthOfYear.values
//                                         .map((month) => DropdownMenuItem(
//                                               value: month,
//                                               child: Text(month.enumToString),
//                                             ))
//                                         .toList(),
//                                   ),
//                                 ),
//                               ]
//                             ],
//                           ),
//                         ),
//                       ],
//                       ListTile(
//                         leading: Text('Event ends'),
//                         trailing: DropdownButton<RecurrenceRuleEndType>(
//                           onChanged: (value) {
//                             setState(() {
//                               _recurrenceRuleEndType = value;
//                             });
//                           },
//                           value: _recurrenceRuleEndType,
//                           items: RecurrenceRuleEndType.values
//                               .map((frequency) => DropdownMenuItem(
//                                     value: frequency,
//                                     child:
//                                         _recurrenceRuleEndTypeToText(frequency),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
//                       if (_recurrenceRuleEndType ==
//                           RecurrenceRuleEndType.MaxOccurrences)
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//                           child: Row(
//                             children: <Widget>[
//                               Text('For the next '),
//                               Flexible(
//                                 child: TextFormField(
//                                   initialValue:
//                                       _totalOccurrences?.toString() ?? '1',
//                                   decoration:
//                                       const InputDecoration(hintText: '1'),
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: [
//                                     // ignore: deprecated_member_use
//                                     WhitelistingTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                   ],
//                                   validator: _validateTotalOccurrences,
//                                   textAlign: TextAlign.right,
//                                   onSaved: (String value) {
//                                     _totalOccurrences = int.tryParse(value);
//                                   },
//                                 ),
//                               ),
//                               Text(' occurrences'),
//                             ],
//                           ),
//                         ),
//                       if (_recurrenceRuleEndType ==
//                           RecurrenceRuleEndType.SpecifiedEndDate)
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: DateTimePicker(
//                             labelText: 'Date',
//                             enableTime: false,
//                             selectedDate: _recurrenceEndDate,
//                             selectDate: (DateTime date) {
//                               setState(() {
//                                 _recurrenceEndDate = date;
//                               });
//                             },
//                           ),
//                         ),
//                     ],
//                   ],
//                 ),
//               ),
// // ignore: sdk_version_ui_as_code
//               if (!_calendar.isReadOnly &&
//                   (_event.eventId?.isNotEmpty ?? false)) ...[
//                 // ignore: deprecated_member_use
//                 RaisedButton(
//                   key: Key('deleteEventButton'),
//                   textColor: Colors.white,
//                   color: Colors.red,
//                   child: Text('Delete'),
//                   onPressed: () async {
//                     var result = true;
//                     if (!_isRecurringEvent) {
//                       await _deviceCalendarPlugin.deleteEvent(
//                           _calendar.id, _event.eventId);
//                     } else {
//                       result = await showDialog<bool>(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (BuildContext context) {
//                             return _recurringEventDialog;
//                           });
//                     }

//                     if (result) {
//                       Navigator.pop(context, true);
//                     }
//                   },
//                 ),
//               ]
//             ],
//           ),
//         ),
//    //   ),

//     );

//     }
//     catch(e){
// return Scaffold(
//   body:Container(height: 400,
//   child: Text(e),)
// );
//     }
  }

  TimeOfDay todaydate = TimeOfDay.now();

  _getdateText() {
    if (widget.getclientdata == null) {
      return Text('');
    } else {
      return widget.getclientdata.lastappointdate == null
          ? Text('')
          : Text('Previous date :' + widget.getclientdata.lastappointdate);
    }
  }

  _dateFormatchange(DateTime datefr) {
    if (widget.getclientdata == null) {
      return
          //  Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Widget>[
          Padding(
        padding: const EdgeInsets.all(10.0),
        child: DateTimePicker(
          // labelText: 'From',
          enableTime: !_event.allDay,
          selectedDate: widget.getclientdata == null
              ? widget.dateTime
              : DateTime.parse(widget.getclientdata.startdate),
          // widget.dateTime,
          selectedTime:
              // widget.getclientdata == null
              //     ?   _startTime
              //     : TimeOfDay(
              //         hour: int.parse(widget.getclientdata.starttime
              //             .split(":")[0]),
              //         minute: int.parse(widget.getclientdata.starttime
              //             .split(":")[1]
              //             .split(" ")[0])),
              _startTime,

          selectDate: (DateTime date) {
            setState(() {
              //  _endDate = date;
              if (widget.getclientdata != null) {
                widget.getclientdata.startdate = date.toString();
                _startDate = DateTime.parse(widget.getclientdata.startdate);
                _endDate = DateTime.parse(widget.getclientdata.enddate);
              } else {
                widget.dateTime = date;
                _startDate = widget.dateTime;
                _endDate = widget.dateTime;
              }
              //   widget.dateTime = date;
              // _startDate=widget.dateTime;
              //    _endDate = widget.dateTime;
              _event.start = _combineDateWithTime(_startDate, _startTime);
              _event.end = _combineDateWithTime(_endDate, _endTime);
            });
          },
          selectTime: (TimeOfDay time) {
            setState(
              () {
                _endTime = time;
                _startTime = time;

                _event.start = _combineDateWithTime(_startDate, _startTime);
              },
            );
          },
        ),
      );
      //   ],
      // );
    } else {
      if (DateFormat("yyyy-MM-dd").format(currentdate) !=
          widget.getclientdata.startdate) {
        return
            //           Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // children: <Widget>[
            Padding(
          padding: const EdgeInsets.all(10.0),
          child: DateTimePicker(
            // labelText: 'From',
            enableTime: !_event.allDay,
            selectedDate: widget.getclientdata == null
                ? widget.dateTime
                : DateTime.parse(widget.getclientdata.startdate),
            // widget.dateTime,
            selectedTime:
                // widget.getclientdata == null
                //     ?   _startTime
                //     : TimeOfDay(
                //         hour: int.parse(widget.getclientdata.starttime
                //             .split(":")[0]),
                //         minute: int.parse(widget.getclientdata.starttime
                //             .split(":")[1]
                //             .split(" ")[0])),
                _startTime,

            selectDate: (DateTime date) {
              setState(() {
                //  _endDate = date;
                if (widget.getclientdata != null) {
                  widget.getclientdata.startdate = date.toString();
                  _startDate = DateTime.parse(widget.getclientdata.startdate);
                  _endDate = DateTime.parse(widget.getclientdata.enddate);
                } else {
                  widget.dateTime = date;
                  _startDate = widget.dateTime;
                  _endDate = widget.dateTime;
                }
                //   widget.dateTime = date;
                // _startDate=widget.dateTime;
                //    _endDate = widget.dateTime;
                _event.start = _combineDateWithTime(_startDate, _startTime);
                _event.end = _combineDateWithTime(_endDate, _endTime);
              });
            },
            selectTime: (TimeOfDay time) {
              setState(
                () {
                  _endTime = time;
                  _startTime = time;

                  _event.start = _combineDateWithTime(_startDate, _startTime);
                },
              );
            },
          ),
        );
        //   ],

        // );

      } else {
        setState(() {
          lastdate = DateFormat("yyyy-MM-dd").format(currentdate);
        });
        print(lastdate);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  enabled: false,
                  style: widget.getclientdata == null
                      ? TextStyle(color: Colors.black)
                      : checkcolor(widget.getclientdata.clientcourt),
                  decoration: new InputDecoration(
                    labelText:
                        DateFormat.yMMMMd().format(DateTime.parse(lastdate)),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )),
            //             Container(
            //               padding: EdgeInsets.all(10),
            //          child:       Text('Current date :' + lastdate

            //  )

            //             ),
            //  Padding(padding: EdgeInsets.all(10),
            //             child:
            //               DateTimePicker(

            //                  // labelText: 'From',
            //                   enableTime: !_event.allDay,
            //                   selectedDate:DateTime.parse(lastdate) ,

            //                   selectedTime:

            //                    _startTime,

            //                 )
            //             ),
            SizedBox(
              height: 5,
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: DateTimePicker(
                  labelText: 'Next date',
                  enableTime: !_event.allDay,
                  selectedDate: widget.getclientdata == null
                      ? widget.dateTime
                      : DateTime.parse(widget.getclientdata.startdate),
                  // widget.dateTime,
                  selectedTime:
                      // widget.getclientdata == null
                      //     ?   _startTime
                      //     : TimeOfDay(
                      //         hour: int.parse(widget.getclientdata.starttime
                      //             .split(":")[0]),
                      //         minute: int.parse(widget.getclientdata.starttime
                      //             .split(":")[1]
                      //             .split(" ")[0])),
                      _startTime,

                  selectDate: (DateTime date) {
                    setState(() {
                      //  _endDate = date;
                      if (widget.getclientdata != null) {
                        widget.getclientdata.startdate = date.toString();
                        _startDate =
                            DateTime.parse(widget.getclientdata.startdate);
                        _endDate = DateTime.parse(widget.getclientdata.enddate);
                      } else {
                        widget.dateTime = date;
                        _startDate = widget.dateTime;
                        _endDate = widget.dateTime;
                      }
                      //   widget.dateTime = date;
                      // _startDate=widget.dateTime;
                      //    _endDate = widget.dateTime;
                      _event.start =
                          _combineDateWithTime(_startDate, _startTime);
                      _event.end = _combineDateWithTime(_endDate, _endTime);
                    });
                  },
                  selectTime: (TimeOfDay time) {
                    setState(
                      () {
                        _endTime = time;
                        _startTime = time;

                        _event.start =
                            _combineDateWithTime(_startDate, _startTime);
                      },
                    );
                  },
                ))
          ],
        );
        //   Text('Current date :' + lastdate
        //   // DateFormat("yyyy-MM-dd").format(lastdate)
        //  );
      }
    }
  }

  String lastdate;
  var currentdate = new DateTime.now();
  Text _recurrenceFrequencyToIntervalText(
      RecurrenceFrequency recurrenceFrequency) {
    switch (recurrenceFrequency) {
      case RecurrenceFrequency.Daily:
        return Text(' Day(s)');
      case RecurrenceFrequency.Weekly:
        return Text(' Week(s) on');
      case RecurrenceFrequency.Monthly:
        return Text(' Month(s)');
      case RecurrenceFrequency.Yearly:
        return Text(' Year(s)');
      default:
        return Text('');
    }
  }

  Text _recurrenceRuleEndTypeToText(RecurrenceRuleEndType endType) {
    switch (endType) {
      case RecurrenceRuleEndType.Indefinite:
        return Text('Indefinitely');
      case RecurrenceRuleEndType.MaxOccurrences:
        return Text('After a set number of times');
      case RecurrenceRuleEndType.SpecifiedEndDate:
        return Text('Continues until a specified date');
      default:
        return Text('');
    }
  }

  Text _recurrenceFrequencyToText(RecurrenceFrequency recurrenceFrequency) {
    switch (recurrenceFrequency) {
      case RecurrenceFrequency.Daily:
        return Text('Daily');
      case RecurrenceFrequency.Weekly:
        return Text('Weekly');
      case RecurrenceFrequency.Monthly:
        return Text('Monthly');
      case RecurrenceFrequency.Yearly:
        return Text('Yearly');
      default:
        return Text('');
    }
  }

// Get total days of a month
  void _getValidDaysOfMonth(RecurrenceFrequency frequency) {
    _validDaysOfMonth.clear();
    var totalDays = 0;

// Year frequency: Get total days of the selected month
    if (frequency == RecurrenceFrequency.Yearly) {
      totalDays = DateTime(DateTime.now().year, _monthOfYear.value + 1, 0).day;
    } else {
      // Otherwise, get total days of the current month
      var now = DateTime.now();
      totalDays = DateTime(now.year, now.month + 1, 0).day;
    }

    for (var i = 1; i <= totalDays; i++) {
      _validDaysOfMonth.add(i);
    }
  }

  void _updateDaysOfWeek() {
    var days = _dayOfWeekGroup.getDays;

    switch (_dayOfWeekGroup) {
      case DayOfWeekGroup.Weekday:
      case DayOfWeekGroup.Weekend:
      case DayOfWeekGroup.AllDays:
        _daysOfWeek.clear();
        _daysOfWeek.addAll(days.where((a) => _daysOfWeek.every((b) => a != b)));
        break;
      case DayOfWeekGroup.None:
        _daysOfWeek.clear();
        break;
    }
  }

  void _updateDaysOfWeekGroup({DayOfWeek selectedDay}) {
    var deepEquality = const DeepCollectionEquality.unordered().equals;

// If _daysOfWeek contains nothing
    if (_daysOfWeek.isEmpty && _dayOfWeekGroup != DayOfWeekGroup.None) {
      _dayOfWeekGroup = DayOfWeekGroup.None;
    }
// If _daysOfWeek contains Monday to Friday
    else if (deepEquality(_daysOfWeek, DayOfWeekGroup.Weekday.getDays) &&
        _dayOfWeekGroup != DayOfWeekGroup.Weekday) {
      _dayOfWeekGroup = DayOfWeekGroup.Weekday;
    }
// If _daysOfWeek contains Saturday and Sunday
    else if (deepEquality(_daysOfWeek, DayOfWeekGroup.Weekend.getDays) &&
        _dayOfWeekGroup != DayOfWeekGroup.Weekend) {
      _dayOfWeekGroup = DayOfWeekGroup.Weekend;
    }
// If _daysOfWeek contains all days
    else if (deepEquality(_daysOfWeek, DayOfWeekGroup.AllDays.getDays) &&
        _dayOfWeekGroup != DayOfWeekGroup.AllDays) {
      _dayOfWeekGroup = DayOfWeekGroup.AllDays;
    }
// Otherwise null
    else {
      _dayOfWeekGroup = null;
    }
  }

  final DBClientManager dbclientManager = new DBClientManager();
  // final DBClienthistoryManager dbclienthistoryManager =
  //     new DBClienthistoryManager();
  List<Client> clientlist;
  int updateindex;
  Client client;
  String userId;
  int getclientid;
  void submitStudent(BuildContext context) {
    _formKey.currentState.validate();
    // if (clientname.text.length == 0 ||
    //     clientage.text.length == 0 ||
    //     clientaddress.text.length == 0 ||
    //     clientphonenumber.text.length == 0) {
    //   return null;
    // }
    if (widget.getclientdata == null) {
      Client st = new Client(
        clientname: clientname.text,
        clientaddress: clientaddress.text,
        clientphonenumber: clientphonenumber.text,
        clientage: clientage.text,
        startdate: DateFormat("yyyy-MM-dd").format(_startDate),
        starttime: _startTime.format(context),
        enddate: DateFormat("yyyy-MM-dd").format(_endDate),
        endtime: _endTime.format(context),
        clientcourt: dropdownValue,
        userid: userId,
      );
      dbclientManager.insertClient(st).then((value1) {
        print("client Data Add to database $value1");

        Clienthistory ht = new Clienthistory(
            clienttitle: clientname.text,
            clientphonenumber: clientphonenumber.text,
            appointdate: DateFormat("yyyy-MM-dd").format(_startDate),
            //DateFormat("yyyy-MM-dd").format(widget.dateTime),
            clientcourt: dropdownValue,
            clientid: value1
            //lastappointdate: ''
            );
              dbclientManager.insertClient1(ht).then((value) {
          clientname.clear();
          clientaddress.clear();
          clientphonenumber.clear();
          clientage.clear();

          print("history Data Add to database $value");
        });
        // dbclienthistoryManager.insertClient(ht).then((value) {
        //   clientname.clear();
        //   clientaddress.clear();
        //   clientphonenumber.clear();
        //   clientage.clear();

        //   print("history Data Add to database $value");
        // });
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => EventScreen()),
          (Route<dynamic> route) => false);
    } else {
      widget.getclientdata.clientname = clientname.text;
      widget.getclientdata.clientaddress = clientaddress.text;
      widget.getclientdata.clientphonenumber = clientphonenumber.text;
      widget.getclientdata.clientage = clientage.text;
      // widget.getclientdata.startdate =
      //     DateFormat("yyyy-MM-dd").format(widget.dateTime);
      widget.getclientdata.clientcourt = widget.getclientdata.clientcourt;
      widget.getclientdata.startdate =
          DateFormat("yyyy-MM-dd").format(_startDate);
      widget.getclientdata.enddate = DateFormat("yyyy-MM-dd").format(_endDate);
      widget.getclientdata.starttime = _startTime.format(context);
      widget.getclientdata.endtime = _endTime.format(context);
      widget.getclientdata.lastappointdate = lastdate;
      //  widget.getclientdata.userId = userId;
      Clienthistory ht = new Clienthistory(
          clienttitle: clientname.text,
          clientphonenumber: clientphonenumber.text,
          appointdate: DateFormat("yyyy-MM-dd").format(_startDate),
          clientcourt: widget.getclientdata.clientcourt,
          clientid: widget.getclientdata.id);
           dbclientManager.insertClient1(ht).then((value) {
        clientname.clear();
        clientphonenumber.clear();

        print("history Data Add to database $value");
      });
      // dbclienthistoryManager.insertClient(ht).then((value) {
      //   clientname.clear();
      //   clientphonenumber.clear();

      //   print("history Data Add to database $value");
      // });
      dbclientManager.updateClient(widget.getclientdata).then((value) {
        setState(() {
          clientlist[updateindex].clientname = clientname.text;
          clientlist[updateindex].clientaddress = clientaddress.text;
          clientlist[updateindex].clientphonenumber = clientphonenumber.text;
          clientlist[updateindex].clientage = clientage.text;
          clientlist[updateindex].startdate =
              DateFormat("yyyy-MM-dd").format(_startDate);
          clientlist[updateindex].enddate =
              DateFormat("yyyy-MM-dd").format(_endDate);
          clientlist[updateindex].starttime = _startTime.format(context);
          clientlist[updateindex].endtime = _endTime.format(context);
          // clientlist[updateindex].startdate =
          //     DateFormat("yyyy-MM-dd").format(widget.dateTime);
          clientlist[updateindex].clientcourt =
              widget.getclientdata.clientcourt;
          clientlist[updateindex].lastappointdate = lastdate;
          // clientlist[updateindex].userId = userId;
        });
        clientname.clear();
        clientaddress.clear();
        clientphonenumber.clear();
        clientage.clear();
        client = null;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => EventScreen()),
          (Route<dynamic> route) => false);
    }
  }

  String _validateTotalOccurrences(String value) {
    if (value.isNotEmpty && int.tryParse(value) == null) {
      return 'Total occurrences needs to be a valid number';
    }
    return null;
  }

  String _validateInterval(String value) {
    if (value.isNotEmpty && int.tryParse(value) == null) {
      return 'Interval needs to be a valid number';
    }
    return null;
  }

  String _validateTitle(String value) {
    if (value.isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  DateTime _combineDateWithTime(DateTime date, TimeOfDay time) {
    if (date == null && time == null) {
      return null;
    }
    final dateWithoutTime =
        DateTime.parse(DateFormat("y-MM-dd 00:00:00").format(date));
    return dateWithoutTime
        .add(Duration(hours: time.hour, minutes: time.minute));
  }

  void showInSnackBar(String value) {
    // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
