import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  double _userEnergyLevel = 1.0;

  // Getter for an unmodifiable view of the tasks
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  // Getter for sorted tasks based on priority
  List<Task> get sortedTasks {
    final sortedList = List<Task>.from(_tasks);
    sortedList.sort((a, b) {
      final scoreA = a.calculatePriorityScore();
      final scoreB = b.calculatePriorityScore();
      return scoreB.compareTo(scoreA); // Higher score first
    });
    return sortedList;
  }

  // Getter for incomplete tasks
  List<Task> get incompleteTasks => 
    _tasks.where((task) => !task.isCompleted).toList();

  // Getter for completed tasks
  List<Task> get completedTasks =>
    _tasks.where((task) => task.isCompleted).toList();

  // Get task by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new task
  void addTask(Task task) {
    try {
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
      rethrow;
    }
  }

  // Update existing task
  void updateTask(Task updatedTask) {
    try {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  // Delete task
  void deleteTask(String taskId) {
    try {
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  // Toggle task completion
  void toggleTaskCompletion(String taskId) {
    try {
      final task = getTaskById(taskId);
      if (task != null) {
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        updateTask(updatedTask);
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      rethrow;
    }
  }

  // Update user energy level
  void updateUserEnergyLevel(double energyLevel) {
    try {
      _userEnergyLevel = energyLevel.clamp(0.0, 1.0);
      // Update energy levels for all tasks
      for (var task in _tasks) {
        final updatedTask = task.copyWith(energyLevel: _userEnergyLevel);
        updateTask(updatedTask);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating energy level: $e');
      rethrow;
    }
  }

  // Add subtask to a task
  void addSubtask(String parentTaskId, Task subtask) {
    try {
      final parentTask = getTaskById(parentTaskId);
      if (parentTask != null) {
        final updatedSubtasks = List<Task>.from(parentTask.subtasks)..add(subtask);
        final updatedTask = parentTask.copyWith(subtasks: updatedSubtasks);
        updateTask(updatedTask);
      }
    } catch (e) {
      debugPrint('Error adding subtask: $e');
      rethrow;
    }
  }

  // Get productivity score (0-100)
  double getProductivityScore() {
    if (_tasks.isEmpty) return 0;
    
    final completedCount = completedTasks.length;
    final totalCount = _tasks.length;
    
    // Base completion rate
    double score = (completedCount / totalCount) * 100;
    
    // Adjust for task importance and urgency
    double importanceScore = 0;
    for (var task in completedTasks) {
      importanceScore += (task.importance + task.urgency) / 2;
    }
    
    // Weight the final score (70% completion rate, 30% importance)
    return (score * 0.7) + (importanceScore * 0.3);
  }

  // Clear all completed tasks
  void clearCompletedTasks() {
    try {
      _tasks.removeWhere((task) => task.isCompleted);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing completed tasks: $e');
      rethrow;
    }
  }

  // Get tasks due today
  List<Task> getTasksDueToday() {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == now.year &&
             task.dueDate!.month == now.month &&
             task.dueDate!.day == now.day;
    }).toList();
  }

  // Get overdue tasks
  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      return task.dueDate!.isBefore(now);
    }).toList();
  }
}