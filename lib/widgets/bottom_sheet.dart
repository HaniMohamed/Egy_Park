import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

class BottomBookingSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomSheetState();
  }
}

class _BottomSheetState extends State<BottomBookingSheet> {
  TimeRange _result;
  List<String> payMethods = ["Bank Card", "Vodafone Cash", "Smart Wallet"];
  String _dropdownValue ;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          AppBar(
            title: Text(
              "Booking Slot A ",
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    TimeRange result = await showTimeRangePicker(
                      context: context,
                      interval: Duration(minutes: 15),
                      labels: [
                        "12 pm",
                        "3 am",
                        "6 am",
                        "9 am",
                        "12 am",
                        "3 pm",
                        "6 pm",
                        "9 pm"
                      ].asMap().entries.map((e) {
                        return ClockLabel.fromIndex(
                            idx: e.key, length: 8, text: e.value);
                      }).toList(),
                    );
                    setState(() {
                      _result = result;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _result != null
                          ? "Duration (from: " +
                              _result.startTime.hour.toString() +
                              ":" +
                              _result.startTime.minute.toString() +
                              " - to: " +
                              _result.endTime.hour.toString() +
                              ":" +
                              _result.endTime.minute.toString() +
                              ")"
                          : "Duration",
                      style: TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey.shade300,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: DropdownButton(
                    value: _dropdownValue,
                    icon: Icon(Icons.payment),
                    isExpanded: true,
                    items: payMethods
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String data) {
                      setState(() {
                        _dropdownValue = data;
                      });
                    },
                    hint: Text("Payment Method"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed("/booked");
                    },
                    child: Text("Book")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
