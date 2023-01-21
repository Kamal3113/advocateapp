import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqladvocate/color.dart';


class Dateselect1 extends StatefulWidget {
  DateTime appointment_datetime1;
  Dateselect1({this.appointment_datetime1});
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<Dateselect1> {
  DateTime _selectedDate;
  DateTime _dateTime = DateTime.now();
  @override
    String _timer;
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RaisedButton(
                                    onPressed: () {
                                      if (_selectedDate == null) {
                                        setState(() {
                                          _timer =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_dateTime);
                                        });
                                      } else {
                                        setState(() {
                                          _timer = _selectedDate.year
                                                  .toString() +
                                              '-' +
                                              _selectedDate.month.toString() +
                                              '-' +
                                              _selectedDate.day.toString() ;
                                           
                                        });
                                      }

                                      Navigator.pop(
                                        context,
                                        widget.appointment_datetime1,
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: topcenterlogin,
                                    child: Text(
                                      'DONE',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
      appBar: AppBar(title: Text('Select date',),backgroundColor: topcenterlogin,),
        body:
          Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 80, left: 35, right: 35),
                      child: DatePickerWidget(
                        looping: false,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2040, 1, 1),
                        initialDate: widget.appointment_datetime1,
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        onChange: (DateTime newDate, _) {
                          widget.appointment_datetime1 = new DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              widget.appointment_datetime1.hour,
                              widget.appointment_datetime1.minute,
                              widget.appointment_datetime1.second,
                              widget.appointment_datetime1.millisecond,
                              widget.appointment_datetime1.microsecond);
                        },
                        pickerTheme: DateTimePickerTheme(
                          backgroundColor: Colors.white,
                          itemTextStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          dividerColor: Colors.blue,
                        ),
                      ),
                    ),
    );
  }


}
