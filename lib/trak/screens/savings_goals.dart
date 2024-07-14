import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
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
        title: const Text(
          'Savings goals tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentGoal.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Target Amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "${currentGoal.number}",
                hintStyle: const TextStyle(color: Colors.blue),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Accumulated',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "$accumulated",
                hintStyle: const TextStyle(color: Colors.blue),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Left',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
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
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  showAddMoneyBottomSheet(context);
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: FsaColor.blue,
                  ),
                  child: const Center(
                    child: Text(
                      'Add money',
                      style: TextStyle(
                        fontSize: 16,
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
            decoration: const BoxDecoration(
              color: FsaColor.darkGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add money",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter number',
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.white54,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _saveGoal();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
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
