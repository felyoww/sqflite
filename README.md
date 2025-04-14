# SQFLITE

Video Tutorial URL : https://youtu.be/bihC6ou8FqQ?si=cSnDDK1oyaUJwAhA

In this tutorial, we will make simple "TO DO LIST APP" by implementing database from sqflite package. This app used to make some sort of to do list, and user can mark their list as completed when they already finished it in real life.

**Downloading Sqflite**
1. Open the terminal in Android Studio
2. To install Sqflite, just type ```flutter pub add sqflite```
3. Check the pubspec.yaml, make sure the sqflite is on there. That's mean, your sqflite is ready.

**Making The Project**
1. First, in lib folder create models directory and add task.dart
   
   ![image](https://github.com/user-attachments/assets/ae76fb5e-a6bd-4970-8e88-52cf53ed9e6a)

2. Then, also add task_type.dart file and define 3 task type (today, planned, urgent)
   ```
       enum TaskType { today, planned, urgent }
    
    extension TaskTypeExtension on TaskType {
      String get name {
        switch (this) {
          case TaskType.planned:
            return "Planned";
          case TaskType.today:
            return "Today";
          case TaskType.urgent:
            return "Urgent";
          default:
            return"";
        }
      }
    
      static TaskType fromString(String value){
        switch (value){
          case 'Planned':
            return TaskType.planned;
          case 'Today':
            return TaskType.today;
          case 'Urgent':
            return TaskType.urgent;
          default:
            throw ArgumentError('Invalid TaskType string: $value');
        }
      }
    }
    
    

   ```
3. After that, go back to task.dart to add constructur. Define the tableName as "Task" and define the coloumn name in database, also define each of column as list of string.
   ```
     import 'task_type.dart';
  
     const String tableName = "tasks";
     
     const String idField = "_id";
     const String titleField = "title";
     const String descriptionField = "description";
     const String dueDateField = "due_date";
     const String taskTypeField = "task_type";
     const String isDoneField = "is_done";
     
     const List<String> taskColumns = [
       idField,
       titleField,
       descriptionField,
       dueDateField,
       taskTypeField,
       isDoneField
     ];
     
     const String boolType = "BOOLEAN NOT NULL";
     const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
     const String textTypeNullable = "TEXT";
     const String textType = "TEXT NOT NULL";
     
     class Task {
       final int? id;
       final String title;
       final String? description;
       final DateTime dueDate;
       final TaskType taskType;
       final bool isDone;
     
       const Task({
         this.id,
         required this.title,
         this.description,
         required this.dueDate,
         required this.taskType,
         required this.isDone,
       });


   ```
4. Create 2 json method
   ```
      static Task fromJson(Map<String, dynamic> json) => Task(
       id: json[idField] as int?,
       title: json[titleField] as String,
       description: json[descriptionField] as String?,
       dueDate: DateTime.parse(json[dueDateField] as String),
       taskType: TaskTypeExtension.fromString(json[taskTypeField] as String),
       isDone: json[isDoneField] == 1,
     );
   
     Map<String, dynamic> toJson() => {
       idField: id,
       titleField : title,
       descriptionField  : description,
       dueDateField : dueDate.toIso8601String(),
       taskTypeField : taskType.name,
       isDoneField : isDone ? 1 : 0,
     };

   ```
5. Next, adding copywith methode to enaby for easy this realization, serialization, and update task class
   ```
      Task copyWith ({
       int? id,
       String? title,
       String? description,
       DateTime? dueDate,
       TaskType? taskType,
       bool? isDone,
   }) =>
         Task(
           id: id ?? this.id,
           title: title ?? this.title,
           description: description ?? this.description,
           dueDate: dueDate ?? this.dueDate,
           taskType: taskType ?? this.taskType,
           isDone: isDone ?? this.isDone,
         );
   
   }
   
6. Go back to Lib folder, make new database folder with name "app_database.dart". Then, get initialize DB methode. Inside it, we set the database path using sqflite package, then join the db path and fileName.
   ```
      import 'dart:convert';
      import 'package:sqflite/sqflite.dart';
      import 'package:path/path.dart';
      import '../models/task.dart';
      
      const String fileName = "task_database.db";
      
      class AppDatabase {
        AppDatabase._init();
      
        static final AppDatabase instance = AppDatabase._init();
      
        static Database? _database;
      
        Future<Database> get database async {
          if (_database != null) return _database!;
          _database = await _initializeDB(fileName);
          return _database!;
        }
      
        Future _createDB(Database db, int version) async {
          await db.execute('''
            CREATE TABLE $tableName(
              $idField $idType,
              $titleField $textType,
              $descriptionField $textTypeNullable,
              $dueDateField $textType,
              $taskTypeField $textType,
              $isDoneField $boolType    
            )
          ''');
        }
      
        Future<Database> _initializeDB(String fileName) async {
          final dbPath = await getDatabasesPath();
          final path = join(dbPath, fileName);
          return await openDatabase(path, version: 1, onCreate: _createDB);
        }

   ```
8. Add _createDB callback to create query from task.dart file
9. Then, create read feature by adding readAllTask methode
    ```
       Future<List<Task?>> readAllTasks() async {
       final db = await instance.database;
       final result = await db.query(tableName, orderBy: "$dueDateField DESC");
       return result.map((json) => Task.fromJson(json)).toList();
     }
    ```
10. Create task to call db.insert methode that used to ask task
    ```
        Future<Task> createTask(Task task) async {
       final db = await instance.database;
       final id = await db.insert(tableName, task.toJson());
       return task.copyWith(id: id);
     }
    ```
12. Finally in database, add close methode to close database when not use
    ```
       Future<void> close() async {
       final db = await instance.database;
       return db.close();
     }
    ```
    
**Making The UI , and Connectin It**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
