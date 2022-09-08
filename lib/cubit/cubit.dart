import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/Screens/Archived.dart';
import 'package:to_do_list/Screens/NewTasks.dart';
import 'package:to_do_list/cubit/states.dart';

import '../Screens/Done.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitailState());
  static AppCubit get(context) => BlocProvider.of(context);
  int selectedpageIndex = 0;

  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> aechivedTasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  late Database database;

  void changeIndex(int index) {
    selectedpageIndex = index;
    emit(AppchangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase(
      'todo.dpz',
      version: 1,
      onCreate: (database, version) async {
        print("Database  created");
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT ,date TEXT ,time TEXT, status TEXT )')
            .then((value) {
          print("table created");
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
        getDataFromDB(database);
        print("Database opened");
      },
    ).then(
      (value) {
        database = value;
        emit(AppcreateDataBaseStates());
      },
    );
  }

  inserttoDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title ,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        emit(AppInsertDataBaseStates());
        // getDataFromDB(database);
        getDataFromDB(database);
        print(" $value inserted succeded");
      }).catchError((error) {
        print('ERROR WHEN INSERTING NEW RECORD');
      });
    });
  }

  void getDataFromDB(database) {
    newtasks = [];
    donetasks = [];
    aechivedTasks = [];
    emit(AppGetDataBaseLoadingStates());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      emit(AppGetDataBaseStates());
      value.forEach((element) {
        if (element['status'] == "new") {
          newtasks.add(element);
        } else if (element['status'] == "Done") {
          donetasks.add(element);
        } else {
          aechivedTasks.add(element);
        }
      });
    });
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDB(database);
      emit(AppUPDATEStates());
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(database);
      emit(AppDeleteStates());
    });
  }

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetStates());
  }
}
