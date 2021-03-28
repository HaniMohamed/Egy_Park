import 'package:egy_park/widgets/bottom_sheet.dart';
import 'package:egy_park/widgets/floating_appbar.dart';
import 'package:egy_park/widgets/park_slot.dart';
import 'package:flutter/material.dart';

class ParkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParkScreenState();
  }
}

class _ParkScreenState extends State<ParkScreen> {
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
                  Stack(
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
                          child: ParkSlot(Colors.red, "A\nOccupied", displayBottomSheet)),
                      Positioned(
                          top: 260,
                          left: 20,
                          child: ParkSlot(Colors.green, "B\nAvailable", displayBottomSheet)),
                      Positioned(
                          top: 180,
                          right: 20,
                          child: ParkSlot(Colors.green, "C\nAvailable",displayBottomSheet)),
                      Positioned(
                          top: 260,
                          right: 20,
                          child: ParkSlot(Colors.red, "D\nOccupied",displayBottomSheet)),

                    ],
                  ),

                  Text("Press on the Available slot to book it",textAlign: TextAlign.center,)
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

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BottomBookingSheet();
        });
  }
}
