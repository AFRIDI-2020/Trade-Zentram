import 'package:TradeZentrum/app/screens/home/widgets/task_info_widget.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/get_tasks_model.dart';

class TaskListItemView extends StatefulWidget {
  final TaskData taskData;

  const TaskListItemView({super.key, required this.taskData});

  @override
  State<TaskListItemView> createState() => _TaskListItemViewState();
}

class _TaskListItemViewState extends State<TaskListItemView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskData.taskName ?? "N/A",
                    style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TaskInfoWidget(
                              icon: "assets/ic_invoice.png",
                              data: widget.taskData.soSystemNo ?? "N/A",
                            ),
                            TaskInfoWidget(
                              icon: "assets/ic_building.png",
                              data: widget.taskData.taskDestination ?? "N/A",
                              width: 22,
                              space: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),

                      if(widget.taskData.taskStartTime == null && widget.taskData.taskEndTime == null)
                        Container(
                          decoration: BoxDecoration(
                            color: ColorConstant().baseColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          child: const Icon(
                            CupertinoIcons.play_fill,
                            color: ColorConstant.secondaryThemeColor,
                            size: 20,
                          ),
                        ),

                      if(widget.taskData.taskStartTime != null && widget.taskData.taskEndTime == null)
                        Container(
                          decoration: BoxDecoration(
                            color: ColorConstant().baseColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          child: const Icon(
                            CupertinoIcons.pause_fill,
                            color: ColorConstant.secondaryThemeColor,
                            size: 20,
                          ),
                        ),
                      const SizedBox(width: 15,),
                    ],
                  ),
                  TaskInfoWidget(
                      icon: "assets/ic_location.png",
                      data: widget.taskData.taskDestinationAddress ?? "N/A",
                      textStyle: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
