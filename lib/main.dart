import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/Design/home_design.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: kThemeColor)
      ),

      title: 'ToDo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    home: HomeDesign(),
    );
  }
}
