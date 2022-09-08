import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/cubit/cubit.dart';
import 'package:to_do_list/cubit/states.dart';

import '../widgets/components.dart';
import '../widgets/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).newtasks;
          return buildTasks(tasks: tasks);
        });
  }
}
