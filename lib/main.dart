import 'package:dexter_health_assessment/core/view_models/nurses_view_model.dart';
import 'package:dexter_health_assessment/ui/pages/todo_list/nurse_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/models/user.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ui/pages/nurse_selector/nurse_selector_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NursesViewModel()),
    ],
    child: const MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dexter Health',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      initialRoute: NurseSelectorPage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case NurseSelectorPage.routeName:
            return MaterialPageRoute(
                builder: (ctx) => const NurseSelectorPage());

          case NurseTodoPage.routeName:
            return MaterialPageRoute(
                builder: (ctx) =>
                    NurseTodoPage(user: settings.arguments as User));
          // default:
          //   return SizedBox();
        }
      },
    );
  }
}
