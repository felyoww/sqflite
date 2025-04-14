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
3. After that, go back to task.dart to add constructur. Define the tableName as "Task" and define the coloumn name in database
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
5. 
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
