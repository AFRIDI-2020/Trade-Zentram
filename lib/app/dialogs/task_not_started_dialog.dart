import 'package:flutter/material.dart';

class TaskNotStartedDialog extends StatelessWidget {
  final VoidCallback onOkayButtonPressed;
  final String warningText;
  const TaskNotStartedDialog({super.key, required this.onOkayButtonPressed, required this.warningText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 20),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(8))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.play_circle_outline,
            size: 80,
          ),
          const SizedBox(
            height: 16,
          ),
          Text("TASK NOT STARTED",
              style: theme.textTheme.titleLarge),
          const SizedBox(
            height: 4,
          ),
          Text(
            warningText,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onOkayButtonPressed,
          child: const Text(
            "Ok",
          ),
        )
      ],
    );
  }
}
