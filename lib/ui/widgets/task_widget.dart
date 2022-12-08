import 'package:dexter_health_assessment/core/models/resident.dart';
import 'package:dexter_health_assessment/core/models/task.dart';
import 'package:dexter_health_assessment/core/view_models/nurse_todo_view_model.dart';
import 'package:dexter_health_assessment/ui/dialogs/task_mover_dialog.dart';
import 'package:dexter_health_assessment/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NurseTask extends StatefulWidget {
  final Task task;

  NurseTask({required this.task}) : super(key: ValueKey(task.taskId));

  @override
  State<NurseTask> createState() => _NurseTaskState();
}

class _NurseTaskState extends State<NurseTask> {
  late Future valueFuture;
  Resident? resident;

  @override
  void initState() {
    super.initState();
    getResident();
  }

  void getResident() {
    valueFuture = widget.task.residentRef.get()
      ..then((value) {
        resident = Resident.fromDocumentSnapshot(document: value);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.blueGrey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.action),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: valueFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("...");
                          }

                          if (snapshot.hasData && resident != null) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Room: ${resident!.roomNumber}"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("Resident: ${resident!.fullName}")
                                ]);
                          }

                          return const SizedBox();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.task.dueDate != null)
                        Text(
                            "Due ${AppDateUtils.formatDate(date: widget.task.dueDate!)}")
                    ],
                  ),
                ),
                if (widget.task.isCompleted)
                  const Icon(Icons.check, color: Colors.green,),
              ],
            ),
            if (!widget.task.isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () {
                        showTaskMoverDialog(context, widget.task);
                      },
                      child: const Text("Move to another shift"),
                    ),
                  ),
                  const SizedBox(width: 50,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<NurseTodoViewModel>(context, listen: false)
                            .markTaskAsDone(task: widget.task);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700
                      ),
                      child: const Text("Done"),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
