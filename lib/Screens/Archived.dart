import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/cubit/states.dart';
import 'package:to_do_list/widgets/components.dart';

import '../cubit/cubit.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).aechivedTasks;
          return buildTasks(tasks: tasks);
        });
  }
}
