import 'package:flutter/material.dart';

class LocationArrivalConfirmationDialog extends StatelessWidget {
  final VoidCallback onNoButtonPressed;
  final VoidCallback onYesButtonPressed;
  const LocationArrivalConfirmationDialog({super.key, required this.onNoButtonPressed, required this.onYesButtonPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape:
      const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(
                  8.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.not_listed_location,
            size: 60,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Are you sure that you have reached?",
            style: theme
                .textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Once it is updated, you can't change!",
            style: theme
                .textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onNoButtonPressed,
              style: ButtonStyle(
                  backgroundColor:
                  WidgetStatePropertyAll(
                    Colors.red.shade900,
                  )),
              child: const Text(
                "NO",
                style: TextStyle(
                    color:
                    Colors.white),
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
