import 'package:flutter/material.dart';
import 'package:tosl_operation/modules/auth/screen/login.dart';
import 'package:tosl_operation/modules/student/component/studentRoute.dart';
import 'package:tosl_operation/shared/common/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: appTheme(),
      //home: const LoginScreen(),
      home: const StudentRoutePage(userId: 1),
      //home: AdminRoutePage(userId: 3),
      //home: const TeacherRoutePage(userId: 2),
    );
  }
}
