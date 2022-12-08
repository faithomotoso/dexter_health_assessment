import 'package:dexter_health_assessment/core/models/task.dart';
import 'package:dexter_health_assessment/core/view_models/nurse_view_model.dart';
import 'package:dexter_health_assessment/core/view_models/task_mover_view_model.dart';
import 'package:dexter_health_assessment/ui/widgets/heading.dart';
import 'package:dexter_health_assessment/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/shift.dart';

void showTaskMoverDialog(BuildContext context, Task task) {
  showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: TaskMoverDialog(task: task),
              ),
            ),
          ),
        );
      });
}

class TaskMoverDialog extends StatelessWidget {
  final Task task;

  TaskMoverDialog({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiniHeading(heading: "Select a shift to move this task to"),
          Selector<NurseViewModel, Set<Shift>>(
            selector: (ctx, a) =>
                a.shifts.where((s) => s.isFutureShift).toSet(),
            builder: (ctx, shifts, child) {
              return ListView.separated(
                itemCount: shifts.length,
                shrinkWrap: true,
                separatorBuilder: (ctx, index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (ctx, index) {
                  Shift shift = shifts.elementAt(index);
                  return ListTile(
                    onTap: () {
                      Provider.of<TaskMover>(context, listen: false)
                          .moveTaskToShift(task: task, newShift: shift);
                    },
                    title: Text(
                        "Shift starting ${AppDateUtils.formatDate(date: shift.startTime)}"),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
