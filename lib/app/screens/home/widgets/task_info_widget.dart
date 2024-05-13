import 'package:flutter/material.dart';

class TaskInfoWidget extends StatelessWidget {
  final String icon;
  final String data;
  final TextStyle? textStyle;
  final double? width;
  final double? space;

  const TaskInfoWidget({super.key, required this.icon, required this.data, this.textStyle, this.width, this.space});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            icon,
            height: width ?? 20,
            width: width ?? 20,
          ),
          SizedBox(
            width: space ?? 6,
          ),
          Expanded(
            child: Text(
              data,
              style: textStyle ?? theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
