import 'package:flutter/material.dart';

class ParkSlot extends StatelessWidget {
  String slotId;
  final Color color;
  final String status;
  Function showBottomSheet;

  ParkSlot(this.slotId, this.color, this.status, this.showBottomSheet);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        color == Colors.green
            ? showBottomSheet(context, slotId)
            : print("#########################3 no");
      },
      child: Container(
        width: 120,
        height: 65,
        child: Card(
          color: color,
          elevation: 5,
          child: Center(
            child: Text(
              status,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
