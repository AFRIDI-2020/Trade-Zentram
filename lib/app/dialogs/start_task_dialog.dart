import 'package:flutter/material.dart';

class StartTaskDialog extends StatelessWidget {
  final VoidCallback onNoButtonPressed;
  final VoidCallback onYesButtonPressed;
  const StartTaskDialog({super.key, required this.onNoButtonPressed, required this.onYesButtonPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
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
          Text("WANNA START?", style: theme.textTheme.titleLarge),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Are you sure that you want to start this Task",
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onNoButtonPressed,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Colors.red.shade900,
                ),
              ),
              child: Text(
                "NO",
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: onYesButtonPressed,
              child: const Text(
                "YES",
              ),
            )
          ],
        )
      ],
    );
  }
}
