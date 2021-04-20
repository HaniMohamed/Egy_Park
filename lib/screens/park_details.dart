import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egy_park/widgets/bottom_sheet.dart';
import 'package:egy_park/widgets/floating_appbar.dart';
import 'package:egy_park/widgets/park_slot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ParkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParkScreenState();
  }
}

class _ParkScreenState extends State<ParkScreen> {
  String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (auth.currentUser != null) {
      print(auth.currentUser.email);
      email = auth.currentUser.email;
    } else {
      Navigator.popAndPushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('slots');

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
                  FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection("slots").get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot documents = snapshot.data;
                          List<DocumentSnapshot> docs = documents.docs;
                          return Stack(
                            children: [
                              Image.asset(
                                "./assets/images/parking_slot.png",
                                height: 500,
                                width: 380,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                top: 180,
                                left: 20,
                                child: isBooked(docs[0]['booked_by'],
                                        docs[0]['from'], docs[0]['to'])
                                    ? ParkSlot(docs[0].id, Colors.red,
                                        docs[0].id + "\nOccupied", null)
                                    : ParkSlot(
                                        docs[0].id,
                                        Colors.green,
                                        docs[0].id + "\nAvailable",
                                        displayBottomSheet),
                              ),
                              Positioned(
                                top: 260,
                                left: 20,
                                child: isBooked(docs[1]['booked_by'],
                                        docs[1]['from'], docs[1]['to'])
                                    ? ParkSlot(docs[1].id, Colors.red,
                                        docs[1].id + "\nOccupied", null)
                                    : ParkSlot(
                                        docs[1].id,
                                        Colors.green,
                                        docs[1].id + "\nAvailable",
                                        displayBottomSheet),
                              ),
                              Positioned(
                                top: 180,
                                right: 20,
                                child: isBooked(docs[2]['booked_by'],
                                        docs[2]['from'], docs[2]['to'])
                                    ? ParkSlot(docs[2].id, Colors.red,
                                        docs[2].id + "\nOccupied", null)
                                    : ParkSlot(
                                        docs[2].id,
                                        Colors.green,
                                        docs[2].id + "\nAvailable",
                                        displayBottomSheet),
                              ),
                              Positioned(
                                top: 260,
                                right: 20,
                                child: isBooked(docs[3]['booked_by'],
                                        docs[3]['from'], docs[3]['to'])
                                    ? ParkSlot(docs[3].id, Colors.red,
                                        docs[3].id + "\nOccupied", null)
                                    : ParkSlot(
                                        docs[3].id,
                                        Colors.green,
                                        docs[3].id + "\nAvailable",
                                        displayBottomSheet),
                              ),
                            ],
                          );
                        } else {
                          print("nodata");
                        }
                        return Container();
                      }),
                  Text(
                    "Press on the Available slot to book it",
                    textAlign: TextAlign.center,
                  )
                ],
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
    if (bookedBy.isEmpty || from.isEmpty || to.isEmpty) {
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
