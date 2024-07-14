import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../floor/dao/appdatabase/app_database.dart';
import '../../floor/dao/goal_dao.dart';
import '../../floor/event_bus.dart';
import '../../fsa/fsa_color.dart';
import '../data/goal_data.dart';

class SavingsGoals extends StatefulWidget {
  final GoalData goal;

  const SavingsGoals({super.key, required this.goal});

  @override
  State<SavingsGoals> createState() => _SavingsGoalsState();
}

class _SavingsGoalsState extends State<SavingsGoals> {
  final TextEditingController _moneyController = TextEditingController();
  late AppDatabase database;
  late GoalDao goalDao;
  final event = GetIt.I<EventBus>();
  late int accumulated;
  late GoalData currentGoal;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    accumulated = widget.goal.accumulated ?? 0;
    currentGoal = widget.goal;
    event.on<UpdateList>().listen((event) {
      setState(() {
        accumulated = currentGoal.accumulated ?? 0;
      });
    });
  }

  void _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    goalDao = database.goalDao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Savings goals tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentGoal.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Target Amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              enabled: false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "${currentGoal.number}",
                hintStyle: const TextStyle(color: Colors.blue),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Accumulated',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              readOnly: true,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "$accumulated",
                hintStyle: const TextStyle(color: Colors.blue),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Left',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              style: const TextStyle(color: Colors.white),
              readOnly: true,
              onTap: () {},
              decoration: InputDecoration(
                hintText: "${currentGoal.number - accumulated}",
                hintStyle: const TextStyle(color: Colors.blue),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  showAddMoneyBottomSheet(context);
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
                      'Add money',
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
          ],
        ),
      ),
    );
  }

  void showAddMoneyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: FsaColor.darkGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0.r),
                topRight: Radius.circular(25.0.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add money",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter number',
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0.r),
                        borderSide: const BorderSide(
                          color: Colors.white54,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0.r),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      _saveGoal();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveGoal() async {
    final enteredValue = int.tryParse(_moneyController.text) ?? 0;

    final updatedGoal = GoalData(
      id: currentGoal.id,
      name: currentGoal.name,
      number: currentGoal.number,
      date: currentGoal.date,
      accumulated: (currentGoal.accumulated ?? 0) + enteredValue,
      image: currentGoal.image,
    );

    await goalDao.insertOrUpdateGoals(updatedGoal);
    _moneyController.clear();
    event.fire(UpdateList());

    setState(() {
      accumulated = updatedGoal.accumulated!;
      currentGoal = updatedGoal;
    });
  }
}
