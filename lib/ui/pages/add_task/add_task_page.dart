import 'package:dexter_health_assessment/core/models/shift.dart';
import 'package:dexter_health_assessment/core/view_models/add_task_view_model.dart';
import 'package:dexter_health_assessment/core/view_models/nurse_view_model.dart';
import 'package:dexter_health_assessment/core/view_models/residents_view_model.dart';
import 'package:dexter_health_assessment/ui/widgets/dropdown_button_styler.dart';
import 'package:dexter_health_assessment/ui/widgets/heading.dart';
import 'package:dexter_health_assessment/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resident.dart';

void showAddTask(BuildContext context) {
  showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return const AddTask();
      });
}

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  NurseViewModel? nurseViewModel;
  AddTaskViewModel? addTaskViewModel;
  ResidentsViewModel? residentsViewModel;
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    nurseViewModel ??= Provider.of<NurseViewModel>(context);
    addTaskViewModel ??= Provider.of<AddTaskViewModel>(context);
    residentsViewModel ??= Provider.of<ResidentsViewModel>(context);
  }

  @override
  void dispose() {
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(onPressed: () {
                addTaskViewModel!.clear();
                Navigator.pop(context);
              }),
              Heading5(heading: "Add task"),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView(
                children: [
                  MiniHeading(heading: "Select shift"),
                  Selector<AddTaskViewModel, Shift?>(
                      builder: (ctx, val, child) {
                        return DropdownButtonHideUnderline(
                            child: DropdownButtonStyler(
                          dropdownButton: DropdownButton<Shift>(
                            onChanged: (shift) {
                              if (shift != null) {
                                addTaskViewModel!.selectShift(shift: shift);
                              }
                            },
                            value: val,
                            hint: const Text("Select a shift"),
                            items: List<
                                DropdownMenuItem<
                                    Shift>>.from(nurseViewModel!.shifts.map(
                                (s) => DropdownMenuItem<Shift>(
                                    value: s,
                                    child: Text(
                                        "Shift starting ${AppDateUtils.formatDate(date: s.startTime)}")))),
                          ),
                        ));
                      },
                      selector: (ctx, a) => a.selectedShift),
                  const SizedBox(
                    height: 20,
                  ),
                  Selector<ResidentsViewModel, Set<Resident>>(
                    selector: (ctx, a) => a.residents,
                    builder: (ctx, residents, child) {
                      if (residents.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MiniHeading(heading: "Select a resident"),
                          Row(
                            children: [
                              Expanded(
                                child: Selector<AddTaskViewModel, Resident?>(
                                  selector: (ctx, a) => a.selectedResident,
                                  builder: (ctx, val, child) {
                                    return DropdownButtonHideUnderline(
                                        child: DropdownButtonStyler(
                                            dropdownButton: DropdownButton(
                                      items:
                                          List<DropdownMenuItem<Resident>>.from(
                                              residents.map((r) =>
                                                  DropdownMenuItem<Resident>(
                                                    value: r,
                                                    child: Text(r.fullName),
                                                  ))),
                                      value: val,
                                      hint: const Text("Select a resident"),
                                      onChanged: (value) {
                                        if (value != null) {
                                          addTaskViewModel!
                                              .selectResident(resident: value);
                                        }
                                      },
                                    )));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MiniHeading(heading: "Task description"),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: taskDescriptionController,
                      maxLines: 3,
                      validator: (txt) {
                        if (txt!.isEmpty) return "Enter a task description";
                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.blueGrey.withOpacity(0.05),
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addTaskViewModel!.createTask(
                          taskDescription: taskDescriptionController.text,
                          nurse:
                              Provider.of<NurseViewModel>(context, listen: false)
                                  .user!);
                    }
                  },
                  child: const Text("Create task"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
