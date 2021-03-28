import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookedScreenState();
  }
}

class _BookedScreenState extends State<BookedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Successfully"),),
      body:Center(child: Column(mainAxisSize: MainAxisSize.min,
      children: [
        QrImage(
          data: "1234567890",
          version: QrVersions.auto,
          size: 200.0,
        ),
        SizedBox(height: 20,),

        Text("You have booked (slot A) Successfully !!", style: TextStyle(fontSize: 20),),
      ],),),
    );
  }
}
