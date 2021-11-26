import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubit/cubit.dart';

class TaskService extends StatelessWidget {
  Map? tasks;

  TaskService({this.tasks});
  final SlidableController slidableController = SlidableController();
  @override
  Widget build(BuildContext context) {
    String date = tasks!['date'];
    String time = tasks!['time'];
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Slidable(
        key: Key(tasks!['title']),

        dismissal: SlidableDismissal(
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.secondary: 1.0
          },
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            AppCubit.get(context).deleteFromDatabase(tasks!['id']);
          },
        ),
        controller: slidableController,
        enabled: true,
        actionExtentRatio: 0.2,
        movementDuration: Duration(microseconds: 10),
        actionPane: SlidableScrollActionPane(),
        actions: [
          IconSlideAction(
            closeOnTap: true,
            caption: 'Löschen',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              AppCubit.get(context).deleteFromDatabase(tasks!['id']);
            },
          ),
        ],
        secondaryActions: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
            child: tasks!['status'] == 'done'
                ? IconSlideAction(
              closeOnTap: true,
              caption: 'Hinzufügen',
              color: Colors.amber[700],
              icon: Icons.add,
              onTap: () {
                AppCubit.get(context).updateDatabase('New', tasks!['id']);
              },
            )
                : IconSlideAction(
              closeOnTap: true,
              caption: 'Abschließen',
              color: Colors.green,
              icon: Icons.check_circle,
              onTap: () {
                AppCubit.get(context)
                    .updateDatabase('done', tasks!['id']);
              },
            ),


          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                color: kThemeColorLight,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zu erledigen bis: $date',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontFamily: 'NotoSans'),
                            ),

                            Text(
                              tasks!['title'],
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: tasks!['status'] == 'done'
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSans'),
                            ),

                            Text(
                              tasks!['description'],
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: tasks!['status'] == 'done'
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontFamily: 'NotoSans'),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
