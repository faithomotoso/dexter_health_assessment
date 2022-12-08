import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_health_assessment/core/models/user.dart';
import 'package:dexter_health_assessment/core/view_models/nurse_view_model.dart';
import 'package:dexter_health_assessment/main.dart';
import 'package:dexter_health_assessment/ui/pages/todo_list/nurse_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NurseSelectorPage extends StatefulWidget {
  const NurseSelectorPage({Key? key}) : super(key: key);

  static const String routeName = "/nurse_selector";

  @override
  State<NurseSelectorPage> createState() => _NurseSelectorPageState();
}

class _NurseSelectorPageState extends State<NurseSelectorPage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection("users").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a nurse"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("An error occurred"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            // Map<String, dynamic> data = snapshot.data.docs.first.da
            List<User> users = List<User>.from(snapshot.data!.docChanges
                .map((e) => User.fromDocumentSnapshot(document: e.doc)));

            return ListView.separated(
              itemCount: users.length,
              separatorBuilder: (ctx, index) => const SizedBox(
                height: 10,
              ),
              itemBuilder: (ctx, index) {
                User user = users.elementAt(index);
                return ListTile(
                  title: Text("${user.firstName} ${user.lastName}"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Provider.of<NurseViewModel>(ctx, listen: false)
                        .assignUser(user: user);
                    navigatorKey.currentState!
                        .pushNamed(NurseTodoPage.routeName, arguments: user);
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
