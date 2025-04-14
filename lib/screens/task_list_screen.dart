import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/app_database.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  Future<void> _loadTasks() async {
    final tasks = await AppDatabase.instance.readAllTasks();
    setState(() {
      _tasks = tasks.cast<Task>();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (result == true) {
      _loadTasks();
    }
  }

  Widget _buildTaskItem(Task task) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(
        "${task.taskType.name} • Due: ${task.dueDate.toLocal().toString().split(' ')[0]}",
      ),
      trailing: Icon(
        task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
        color: task.isDone ? Colors.green : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: ListView(
        children: _tasks.map(_buildTaskItem).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
