import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/task_controller/new_task.dart';
import 'package:todo_app/task_controller/task_done.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];

  Database? database;
  List<String> titles = ['Todo Tasks', 'Done Tasks'];
  bool isBottomSheetShown = false;
  Icon floatingButtonIcon = Icon(Icons.edit);
  int bottomNavigtionIndex = 0;
  List<Widget> screens = [
    newTask(),
    taskDone(),
  ];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,description TEXT, time TEXT, status TEXT)')
            .then((value) => print('Tabelle erstellt'))
            .catchError((error) {
          print('Fehler beim erstellen der Datenbank ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataBase(database);
        print('Datenbank geöffnet!');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }



  InsertInToDatabase(
      {required String title,
        required String time, required String description,
        required String date}) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks (title, date,description, time, status) VALUES ("$title","$date","$description","$time","New")')
          .then((value) {
        getDataBase(database);
        print('$value Erfolgreich eingefügt!');
        emit(AppInsertDatabaseState());
      }).catchError((error) {
        print('Fehler beim einfügen der Tabelle ${error.toString()}');
      });
    });
  }

  void DeleteTable(Database){

    database!.rawQuery('DROP TABLE tasks');

  }

  void changeIndex(int index) {
    bottomNavigtionIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void updateDatabase(String status, int id) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteFromDatabase(int id) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataBase(database) async {
    newTasks = [];
    doneTasks = [];
    //database!.rawQuery('ALTER TABLE tasks ADD description TEXT').then((value)
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      //print(value);
      value.forEach((element) {
        print(element['id']);
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState(bool isShow, Icon icon) {
    isBottomSheetShown = isShow;
    floatingButtonIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
