// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GoalDao? _goalDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `GoalData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `number` INTEGER NOT NULL, `date` TEXT NOT NULL, `image` TEXT NOT NULL, `accumulated` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GoalDao get goalDao {
    return _goalDaoInstance ??= _$GoalDao(database, changeListener);
  }
}

class _$GoalDao extends GoalDao {
  _$GoalDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _goalDataInsertionAdapter = InsertionAdapter(
            database,
            'GoalData',
            (GoalData item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'number': item.number,
                  'date': item.date,
                  'image': item.image,
                  'accumulated': item.accumulated
                }),
        _goalDataUpdateAdapter = UpdateAdapter(
            database,
            'GoalData',
            ['id'],
            (GoalData item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'number': item.number,
                  'date': item.date,
                  'image': item.image,
                  'accumulated': item.accumulated
                }),
        _goalDataDeletionAdapter = DeletionAdapter(
            database,
            'GoalData',
            ['id'],
            (GoalData item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'number': item.number,
                  'date': item.date,
                  'image': item.image,
                  'accumulated': item.accumulated
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GoalData> _goalDataInsertionAdapter;

  final UpdateAdapter<GoalData> _goalDataUpdateAdapter;

  final DeletionAdapter<GoalData> _goalDataDeletionAdapter;

  @override
  Future<List<GoalData>> findAllGoals() async {
    return _queryAdapter.queryList('SELECT * FROM GoalData',
        mapper: (Map<String, Object?> row) => GoalData(
            id: row['id'] as int?,
            name: row['name'] as String,
            number: row['number'] as int,
            date: row['date'] as String,
            image: row['image'] as String,
            accumulated: row['accumulated'] as int?));
  }

  @override
  Future<GoalData?> findGoalById(int id) async {
    return _queryAdapter.query('SELECT * FROM GoalData WHERE id = ?1',
        mapper: (Map<String, Object?> row) => GoalData(
            id: row['id'] as int?,
            name: row['name'] as String,
            number: row['number'] as int,
            date: row['date'] as String,
            image: row['image'] as String,
            accumulated: row['accumulated'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> insertGoals(GoalData goal) async {
    await _goalDataInsertionAdapter.insert(goal, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertOrUpdateGoals(GoalData goal) async {
    await _goalDataInsertionAdapter.insert(goal, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateGoal(GoalData goal) async {
    await _goalDataUpdateAdapter.update(goal, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGoals(GoalData goal) async {
    await _goalDataDeletionAdapter.delete(goal);
  }
}
