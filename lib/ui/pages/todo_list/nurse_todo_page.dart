import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_health_assessment/core/models/shift.dart';
import 'package:dexter_health_assessment/core/models/task.dart';
import 'package:dexter_health_assessment/core/models/user.dart';
import 'package:dexter_health_assessment/ui/widgets/task_widget.dart';
import 'package:dexter_health_assessment/utils/date_utils.dart';
import 'package:flutter/material.dart';

class NurseTodoPage extends StatefulWidget {
  static const String routeName = "/todo";

  final User user;

  const NurseTodoPage({Key? key, required this.user}) : super(key: key);

  @override
  State<NurseTodoPage> createState() => _NurseTodoPageState();
}

class _NurseTodoPageState extends State<NurseTodoPage> {
  late final User user;
  late final Stream<QuerySnapshot> _shiftsStream;
  Stream<QuerySnapshot>? _tasksStream;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _shiftsStream = FirebaseFirestore.instance
        .collection("shifts")
        // .where("nurse_id", isGreaterThanOrEqualTo: "users/${user.documentId}")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              Text(
                "Hi Nurse ${user.firstName} ${user.documentId}",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _shiftsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("Loading shift..."),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child:
                            Text("An error occurred while loading your shift"),
                      );
                    }

                    if (snapshot.hasData) {
                      List<Shift> shifts = List<Shift>.from(snapshot
                          .data!.docChanges
                          .map((e) =>
                              Shift.fromDocumentSnapshot(document: e.doc))
                          .where((element) =>
                              element.nurseId == "users/${user.documentId}"));

                      shifts.sort(
                          (s1, s2) => s1.startTime.compareTo(s2.startTime));

                      if (shifts.isEmpty) {
                        return const Center(
                          child: Text("You do not have any available shift"),
                        );
                      }

                      if (shifts
                          .where((element) => element.isActiveShift)
                          .isEmpty) {
                        return const Center(
                          child: Text("Your shift hasn't started yet"),
                        );
                      }

                      Shift activeShift =
                          shifts.firstWhere((element) => element.isActiveShift);

                      _tasksStream = FirebaseFirestore.instance
                          .collection("tasks")
                          .snapshots();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Your current shift ends on ${AppDateUtils.formatDate(date: activeShift.endTime)}"),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _tasksStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text(
                                        "An error occurred while fetching tasks"),
                                  );
                                }

                                if (snapshot.hasData) {
                                  List<Task> tasks = List<Task>.from(snapshot
                                      .data!.docChanges
                                      .map((e) => Task.fromDocumentSnapshot(
                                          document: e.doc))
                                      .where((t) => t.belongsToShift(
                                          shiftId: activeShift.documentId)));

                                  if (tasks.isEmpty) {
                                    return const Center(
                                      child:
                                          Text("No tasks available right now!"),
                                    );
                                  }

                                  return ListView.separated(
                                    itemCount: tasks.length,
                                    separatorBuilder: (ctx, index) =>
                                        const SizedBox(
                                      height: 20,
                                    ),
                                    itemBuilder: (ctx, index) =>
                                        NurseTask(task: tasks.elementAt(index)),
                                  );
                                }

                                return const SizedBox();
                              },
                            ),
                          )
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
