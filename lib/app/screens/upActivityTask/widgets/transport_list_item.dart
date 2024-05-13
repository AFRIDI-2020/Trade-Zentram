import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../../../model/task_details_model.dart';

class TransportListItem extends StatefulWidget {
  final TaskTransportationData taskTransportationData;
  final Function(String)? onSelected;

  const TransportListItem(
      {super.key, required this.onSelected, required this.taskTransportationData});

  @override
  State<TransportListItem> createState() => _TransportListItemState();
}

class _TransportListItemState extends State<TransportListItem> {
  final List<String> _menuList = ['Edit', 'Reached', 'Delete'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/ic_source_location.png",
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "From",
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                            Text(
                              widget.taskTransportationData.taskTransportationStartLocation ?? "",
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const DottedLine(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          lineLength: 30,
                          lineThickness: 1.0,
                          dashLength: 4.0,
                          dashColor: Colors.black,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              "By",
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              widget.taskTransportationData.vehicleName ?? "",
                              style: theme.textTheme.titleMedium?.copyWith(color: ColorConstant.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/ic_source_location.png",
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "To",
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                            Text(
                              widget.taskTransportationData.taskTransportationEndLocation ?? "",
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              VerticalDivider(
                thickness: 0.5,
                width: 0.5,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.taskTransportationData.taskTransportationEndLat == null &&
                        widget.taskTransportationData.taskTransportationEndLong == null)
                      PopupMenuButton<String>(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstant().baseColor,
                            ),
                            padding: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.settings,
                              color: ColorConstant.secondaryThemeColor,
                              size: 16,
                            ),
                          ),
                          offset: const Offset(0, 40),
                          padding: EdgeInsets.zero,
                          onSelected: widget.onSelected,
                          itemBuilder: (context) => [..._menuList.map(buildItem)]),
                    //const Spacer(),
                    Text(
                      "Cost",
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      "৳ ${widget.taskTransportationData.taskTransportationCost ?? "0"}",
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> buildItem(String item) => PopupMenuItem<String>(
        value: item,
        child: Text(
          item,
        ),
      );
}
