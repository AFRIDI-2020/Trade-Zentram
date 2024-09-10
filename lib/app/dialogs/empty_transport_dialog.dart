import 'package:flutter/material.dart';

class EmptyTransportDialog extends StatelessWidget {
  final VoidCallback onOkayButtonPressed;
  const EmptyTransportDialog({super.key, required this.onOkayButtonPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(8))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/ic_empty_transport.png",
            width: 80,
            height: 80,
          ),
          const SizedBox(
            height: 4,
          ),
          Text("Empty Transport",
              style:
              theme.textTheme.titleLarge),
          const SizedBox(
            height: 16,
          ),
          Text(
            "You have not added any transport yet",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.center,
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
