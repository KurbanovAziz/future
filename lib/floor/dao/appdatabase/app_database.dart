import 'dart:async';

import 'package:floor/floor.dart';
import 'package:future_savings_app_29_t/trak/data/goal_data.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../goal_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [GoalData])
abstract class AppDatabase extends FloorDatabase {
  GoalDao get goalDao;
}
