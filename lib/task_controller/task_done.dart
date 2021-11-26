import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class taskDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return SafeArea(
          child: SingleChildScrollView(
            physics:
            BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      '',
                      style: TextStyle(
                        //color: Colors.white,
                          color: Colors.amber.shade700,
                          fontSize: 19,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // SizedBox(

                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: tasks.length > 0
                        ? Text(
                      'Abgeschlossene Aufgaben',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                        fontSize: 19,
                        fontFamily: 'Helvetica',
                      ),
                    )
                        : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  tasks.length > 0
                      ? ListView.builder(
                    //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //print(index);
                        return TaskService(
                          tasks: tasks[index],
                        );
                      },
                      itemCount: tasks.length)
                      : Container(
                      child: Center(
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
