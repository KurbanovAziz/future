import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/generated/assets.dart';
import 'package:future_savings_app_29_t/trak/screens/goal_creation.dart';
import 'package:future_savings_app_29_t/trak/screens/savings_goals.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../floor/dao/appdatabase/app_database.dart';
import '../../fsa/fsa_color.dart';
import '../floor/dao/goal_dao.dart';
import '../floor/event_bus.dart';
import 'data/goal_data.dart';

class TrakScreen extends StatefulWidget {
  const TrakScreen({super.key});

  @override
  State<TrakScreen> createState() => _TrakScreenState();
}

class _TrakScreenState extends State<TrakScreen> {
  late AppDatabase database;
  late GoalDao goalDao;
  final event = GetIt.I<EventBus>();
  List<GoalData> goals = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    event.on<UpdateList>().listen((event) {
      _initializeDatabase();
    });
  }

  void _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    goalDao = database.goalDao;
    _fetchGoals();
  }

  void _fetchGoals() async {
    List<GoalData> fetchedGoals = await goalDao.findAllGoals();
    setState(() {
      goals = fetchedGoals;
      print(goals);
    });
  }

  Future<void> deleteGoalFromStorage(GoalData goal) async {
    event.fire(UpdateList());
    await goalDao.deleteGoals(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Savings goals tracker",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: goals.isEmpty
              ? _buildEmptyState()
              : _buildGoalsList(),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: goals.isNotEmpty,
        child: BottomAppBar(
          color: FsaColor.black,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoalCreation(),
                ),
              );
            },
            child: Container(
              height: 56.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                color: FsaColor.blue,
              ),
              child: Center(
                child: Text(
                  'Add New Goal',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: FsaColor.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Create your first long-term goal",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GoalCreation(),
              ),
            );
          },
          child: Container(
            height: 56.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              color: FsaColor.blue,
            ),
            child: Center(
              child: Text(
                'Add New Goal',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: FsaColor.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsList() {
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        String dateString = goal.date;
        DateFormat format = DateFormat('yyyy-MM-dd');
        DateTime goalDate = format.parse(dateString);
        print(goals[index].image);
        return SizedBox(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SavingsGoals(goal: goal,)));
                },
                child: Card(
                  color: FsaColor.darkGrey,
                  margin: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.0.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0.h),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: FsaColor.black,
                                        borderRadius: BorderRadius.circular(8.r)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0.r),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Left (\$):',
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp),
                                          ),
                                          Text(
                                            '${goal.number - (goal.accumulated ?? 0)}',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: FsaColor.black,
                                        borderRadius: BorderRadius.circular(8.r)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0.r),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Years left (\$):',
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp),
                                          ),
                                          Text(
                                            '${(DateTime.now().difference(goalDate).inDays ~/ 365).abs()}',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0.h),
                              Row(
                                children: [
                                  Expanded(child: LinearProgressIndicator(
                                      value: goal.number != 0
                                        ? ((goal.accumulated ?? 0) / goal.number).clamp(0.0, 1.0)
                                        : 0.0,
                                      backgroundColor: FsaColor.black,
                                      valueColor: const AlwaysStoppedAnimation<Color>(FsaColor.green),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${(goal.number != 0 ? ((goal.accumulated ?? 0) / goal.number * 100).clamp(0.0,100.0).toInt() : 0)}%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: CircleAvatar(
                            backgroundImage: goal.image != null
                                ? (goal.image!.startsWith('/data/user/') && File(goal.image!).existsSync()
                                ? FileImage(File(goal.image!))
                                : AssetImage(goal.image!)) as ImageProvider<Object>
                                : null,
                            radius: 30.r,
                            child: goal.image == null
                                ? const Icon(Icons.image, size: 30)
                                : null, // Placeholder icon if no image
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      show(goal);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void show(GoalData goal) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalCreation(goal: goal),
                    ),
                  );
                },
                child: const Text(
                  'Edit', style: TextStyle(color: FsaColor.blue),),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteDialog(context, goal);
                },
                child: const Text('Delete', style: TextStyle(color: FsaColor.red),),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
          );
        }
    );
  }

  void _showDeleteDialog(BuildContext context, GoalData goal) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete the card'),
          content: const Text('Once deleted, the card cannot be restored'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
              onPressed: () {
                deleteGoalFromStorage(goal);
                _fetchGoals();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel', style: TextStyle(color: FsaColor.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
