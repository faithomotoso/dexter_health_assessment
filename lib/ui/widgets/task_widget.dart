import 'package:dexter_health_assessment/core/models/resident.dart';
import 'package:dexter_health_assessment/core/models/task.dart';
import 'package:dexter_health_assessment/utils/date_utils.dart';
import 'package:flutter/material.dart';

class NurseTask extends StatefulWidget {
  final Task task;

  NurseTask({required this.task});

  @override
  State<NurseTask> createState() => _NurseTaskState();
}

class _NurseTaskState extends State<NurseTask> {
  late Future valueFuture;
  Resident? resident;

  @override
  void initState() {
    super.initState();
  }

  void getResident() {
    valueFuture = widget.task.residentRef.get()..then((value) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.action),
            const SizedBox(
              height: 10,
            ),
            // Text("Room: ${task.}")
            FutureBuilder(future: valueFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("...");
              }

              if (snapshot.hasData) {

              }

              return const SizedBox();
            },),
            const SizedBox(
              height: 10,
            ),
            if (widget.task.dueDate != null)
              Text("Due ${AppDateUtils.formatDate(date: widget.task.dueDate!)}")
          ],
        ),
      ),
    );
  }
}
