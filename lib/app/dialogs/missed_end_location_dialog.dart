import 'package:flutter/material.dart';

class MissedEndLocationDialog extends StatelessWidget {
  final VoidCallback onOkayButtonPressed;

  const MissedEndLocationDialog({super.key, required this.onOkayButtonPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0))),
      content: const SizedBox(
        height: 180,
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Color(0xFFed6c02),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "MISSED END LOCATION",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "You have not clicked the reach button above!!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onOkayButtonPressed,
          style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              backgroundColor: const WidgetStatePropertyAll(Color(0xFFed6c02))),
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
