import 'package:floor/floor.dart';

@entity
class GoalData{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int number;
  final String date;
  final String image;
  late final int? accumulated;

  GoalData({
    this.id,
    required this.name,
    required this.number,
    required this.date,
    required this.image,
    this.accumulated = 0
  });
}