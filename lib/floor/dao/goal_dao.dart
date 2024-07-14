import 'package:floor/floor.dart';
import 'package:future_savings_app_29_t/trak/data/goal_data.dart';

@dao
abstract class GoalDao {
  @Query('SELECT * FROM GoalData')
  Future<List<GoalData>> findAllGoals();

  @insert
  Future<void> insertGoals(GoalData goal);

  @delete
  Future<void> deleteGoals(GoalData goal);

  @update
  Future<void> updateGoal(GoalData goal);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrUpdateGoals(GoalData goal);

  @Query('SELECT * FROM GoalData WHERE id = :id')
  Future<GoalData?> findGoalById(int id);
}