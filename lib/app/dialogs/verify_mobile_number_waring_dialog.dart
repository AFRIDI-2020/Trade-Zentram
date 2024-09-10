import 'package:flutter/material.dart';

class VerifyMobileNumberWaringDialog extends StatelessWidget {
  final VoidCallback onOkayButtonPressed;
  const VerifyMobileNumberWaringDialog({super.key, required this.onOkayButtonPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius
                  .circular(
                  8))),
      content: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Padding(
            padding:
            const EdgeInsets
                .only(
                left: 15),
            child: Image.asset(
              "assets/ic_verify_mobile.png",
              height: 60,
              width: 60,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Verify mobile number!!",
            style: theme
                .textTheme
                .titleLarge,
            textAlign: TextAlign
                .center,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "You haven't verify mobile number yet",
            style: theme
                .textTheme
                .bodyMedium,
            textAlign: TextAlign
                .center,
          ),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment:
          Alignment.center,
          child: ElevatedButton(
            onPressed: onOkayButtonPressed,
            child: const Text(
              "Okay",
            ),
          ),
        ),
      ],
    );
  }
}
