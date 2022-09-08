import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/Screens/Done.dart';
import 'package:to_do_list/cubit/cubit.dart';
import 'package:to_do_list/cubit/states.dart';
import 'package:to_do_list/widgets/constants.dart';

import '../Screens/NewTasks.dart';

class Tabscreen extends StatelessWidget {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var Datecontroller = TextEditingController();

  var scafoldkey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDataBaseStates) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scafoldkey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.lightBlue[400],
              //  shape: Cuvedshape(30.0),
              title: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppCubit.get(context).titles[cubit.selectedpageIndex],
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    letterSpacing: .5,
                    color: Colors.black,
                    fontSize: 25,
                    // fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingStates,
              builder: (context) => cubit.screens[cubit.selectedpageIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              focusColor: Colors.lightBlue[400],
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.inserttoDataBase(
                      title: titlecontroller.text,
                      date: Datecontroller.text,
                      time: timecontroller.text,
                    );
                  }
                } else {
                  scafoldkey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titlecontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  onFieldSubmitted: (String value) {
                                    print(value);
                                  },
                                  onChanged: (String value) {
                                    print(value);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Tasks',
                                    prefixIcon: Icon(
                                      Icons.title,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: timecontroller,
                                  keyboardType: TextInputType.datetime,
                                  onFieldSubmitted: (String value) {
                                    print(value);
                                  },
                                  onChanged: (String value) {
                                    print(value);
                                  },
                                  onTap: () {
                                    print("time tapped");
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timecontroller.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Task Time',
                                    prefixIcon: Icon(
                                      Icons.watch_later_outlined,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: Datecontroller,
                                  keyboardType: TextInputType.datetime,
                                  onFieldSubmitted: (String value) {
                                    print(value);
                                  },
                                  onChanged: (String value) {
                                    print(value);
                                  },
                                  onTap: () {
                                    print("Date tapped");
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2050-08-15'))
                                        .then((value) {
                                      Datecontroller.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Task Date',
                                    prefixIcon: Icon(
                                      Icons.calendar_month,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              // ignore: prefer_const_constructors
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: Colors.lightBlue.shade400,
              backgroundColor: Colors.white.withOpacity(0.9),
              buttonBackgroundColor: Colors.lightBlue[400],
              index: AppCubit.get(context).selectedpageIndex,
              height: 60,
              key: _bottomNavigationKey,
              items: const <Widget>[
                Icon(Icons.menu_rounded, size: 30),
                Icon(Icons.task_alt_rounded, size: 30),
                Icon(
                  Icons.archive_outlined,
                  size: 30,
                  //color: Colors.deepOrangeAccent,
                ),
              ],
              // ignore: prefer_const_constructors
              animationDuration: Duration(
                milliseconds: 300,
              ),
              animationCurve: Curves.decelerate,
              onTap: (value) {
                /* setState(() {
              selectedpageIndex = value;
            });*/
                cubit.changeIndex(value);
              },
            ),
          );
        },
      ),
    );
  }
}
