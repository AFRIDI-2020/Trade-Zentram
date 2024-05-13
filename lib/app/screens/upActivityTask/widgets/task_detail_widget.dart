import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/task_details_model.dart';
import '../../../utils/color_const.dart';
import '../../home/widgets/task_info_widget.dart';

class TaskDetailWidget extends StatelessWidget {
  final TaskDetailsData taskDetailsData;
  final void Function()? onPlayPauseButtonTap;

  const TaskDetailWidget({super.key, required this.taskDetailsData, this.onPlayPauseButtonTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TaskInfoWidget(
                              icon: "assets/ic_invoice.png",
                              data: taskDetailsData.soSystemNo ?? "",
                            ),
                            TaskInfoWidget(
                              icon: "assets/ic_building.png",
                              data: taskDetailsData.taskDestination ?? "N/A",
                              width: 22,
                              space: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),


                      if (taskDetailsData.taskStartTime == null && taskDetailsData.taskEndTime == null)
                        InkWell(
                          onTap: onPlayPauseButtonTap,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
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
                        ),


                      if (taskDetailsData.taskStartTime != null && taskDetailsData.taskEndTime == null)
                        InkWell(
                          onTap: onPlayPauseButtonTap,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
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
                        ),


                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  TaskInfoWidget(
                      icon: "assets/ic_location.png",
                      data: taskDetailsData.taskDestinationAddress ?? "N/A",
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
