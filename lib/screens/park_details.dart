import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egy_park/widgets/bottom_sheet.dart';
import 'package:egy_park/widgets/floating_appbar.dart';
import 'package:egy_park/widgets/park_slot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ParkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParkScreenState();
  }
}

class _ParkScreenState extends State<ParkScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String email;
  bool isLoading = false;
  int floor = 0;

  bool pressed = true;
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  Map<dynamic, dynamic> data;

  void getData() {
    setState(() {
      isLoading = true;
    });
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        data = snapshot.value;
        log(data.toString());
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      print(auth.currentUser.email);
      email = auth.currentUser.email;
      getData();
    } else {
      Navigator.popAndPushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 80),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                      Text(
                        "First Example Park",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            Image.asset(
                              floor == 0
                                  ? "./assets/images/first_floor.png"
                                  : "./assets/images/second_floor.png",
                              height: 500,
                              width: 380,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                                top: 40,
                                left: 120,
                                child: Center(
                                  child: Text(
                                    floor == 0 ? "ground" : "underground",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                )),
                            floor == 0
                                ? Positioned(
                                    top: 135,
                                    left: 80,
                                    child: isBooked(
                                            data["slots"]["A"]['booked by']
                                                .toString(),
                                            data["slots"]["A"]['from']
                                                .toString(),
                                            data["slots"]["A"]['to'].toString())
                                        ? ParkSlot("A", Colors.transparent,
                                            "A" + "\nOccupied", null)
                                        : ParkSlot(
                                            "A",
                                            Colors.transparent,
                                            "A" + "\nAvailable",
                                            displayBottomSheet),
                                  )
                                : Positioned(
                                    top: 135,
                                    left: 80,
                                    child: isBooked(
                                            data["slots"]["C"]['booked by']
                                                .toString(),
                                            data["slots"]["C"]['from']
                                                .toString(),
                                            data["slots"]["C"]['to'].toString())
                                        ? ParkSlot("C", Colors.transparent,
                                            "C" + "\nOccupied", null)
                                        : ParkSlot(
                                            "C",
                                            Colors.transparent,
                                            "C" + "\nAvailable",
                                            displayBottomSheet),
                                  ),
                            floor == 0
                                ? Positioned(
                                    top: 280,
                                    left: 80,
                                    child: isBooked(
                                            data["slots"]["B"]['booked by']
                                                .toString(),
                                            data["slots"]["B"]['from']
                                                .toString(),
                                            data["slots"]["B"]['to'].toString())
                                        ? ParkSlot("B", Colors.transparent,
                                            "B" + "\nOccupied", null)
                                        : ParkSlot(
                                            "B",
                                            Colors.transparent,
                                            "B" + "\nAvailable",
                                            displayBottomSheet),
                                  )
                                : Positioned(
                                    top: 280,
                                    left: 80,
                                    child: isBooked(
                                            data["slots"]["D"]['booked by']
                                                .toString(),
                                            data["slots"]["D"]['from']
                                                .toString(),
                                            data["slots"]["D"]['to'].toString())
                                        ? ParkSlot("D", Colors.transparent,
                                            "D" + "\nOccupied", null)
                                        : ParkSlot(
                                            "D",
                                            Colors.transparent,
                                            "D" + "\nAvailable",
                                            displayBottomSheet),
                                  ),
                          ],
                        ),
                  Text(
                    "Press on the Available slot to book it",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 100,
              child: SizedBox(
                child: ToggleSwitch(
                  initialLabelIndex: floor,
                  minWidth: 100.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.cyan],
                    [Colors.redAccent]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  icons: [Icons.car_rental, Icons.electrical_services],
                  onToggle: (index) {
                    print('switched to: $index');
                    setState(() {
                      floor = index;
                    });
                    print("########### $floor");
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: FloatingAppBar(),
            )
          ],
        ),
      ),
    );
  }

  bool isBooked(String bookedBy, String from, String to) {
    DateTime now = DateTime.now();
    print(
        "############# ${bookedBy.toString()} /  ${from.toString()} /  ${to.toString()} /");

    if (bookedBy == null || from == null || to == null) {
      print("############# heeeeeeeereeeeeeeee");

      return false;
    } else if (now.hour < int.parse(from) || now.hour > int.parse(to)) {
      print("############# " + now.hour.toString());

      print("$bookedBy=> $from : $to");

      return false;
    }
    return true;
  }

  void displayBottomSheet(BuildContext context, slot) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BottomBookingSheet(
            slotId: slot,
          );
        });
  }
}
