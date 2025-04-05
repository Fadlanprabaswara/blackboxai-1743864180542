import 'package:flutter/foundation.dart';

class Task {
  final String id;
  String title;
  String description;
  int urgency;
  int importance;
  int estimatedMinutes;
  DateTime? dueDate;
  bool isCompleted;
  List<Task> subtasks;
  double? energyLevel;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.urgency = 1,
    this.importance = 1,
    this.estimatedMinutes = 30,
    this.dueDate,
    this.isCompleted = false,
    this.subtasks = const [],
    this.energyLevel,
  });

  double calculatePriorityScore() {
    // AI-simulated priority scoring
    double score = 0;
    
    // Base score from urgency and importance (40% each)
    score += (urgency * 0.4) + (importance * 0.4);
    
    // Due date factor (20%)
    if (dueDate != null) {
      final daysUntilDue = dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 1) {
        score += 0.2; // Highest priority for tasks due within 24 hours
      } else if (daysUntilDue <= 3) {
        score += 0.15; // High priority for tasks due within 3 days
      } else if (daysUntilDue <= 7) {
        score += 0.1; // Medium priority for tasks due within a week
      } else {
        score += 0.05; // Lower priority for tasks due later
      }
    }

    // Energy level adjustment
    if (energyLevel != null) {
      score *= energyLevel!; // Adjust score based on user's energy level
    }

    // Completion status
    if (isCompleted) {
      score = 0; // Completed tasks have no priority
    }

    return score.clamp(0.0, 1.0); // Ensure score is between 0 and 1
  }

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'urgency': urgency,
      'importance': importance,
      'estimatedMinutes': estimatedMinutes,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'subtasks': subtasks.map((task) => task.toJson()).toList(),
      'energyLevel': energyLevel,
    };
  }

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      urgency: json['urgency'] as int? ?? 1,
      importance: json['importance'] as int? ?? 1,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 30,
      dueDate: json['dueDate'] != null 
        ? DateTime.parse(json['dueDate'] as String)
        : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((subtask) => Task.fromJson(subtask as Map<String, dynamic>))
          .toList() ?? [],
      energyLevel: json['energyLevel'] as double?,
    );
  }

  // Copy with method for immutable updates
  Task copyWith({
    String? title,
    String? description,
    int? urgency,
    int? importance,
    int? estimatedMinutes,
    DateTime? dueDate,
    bool? isCompleted,
    List<Task>? subtasks,
    double? energyLevel,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      urgency: urgency ?? this.urgency,
      importance: importance ?? this.importance,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
      energyLevel: energyLevel ?? this.energyLevel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          urgency == other.urgency &&
          importance == other.importance &&
          estimatedMinutes == other.estimatedMinutes &&
          dueDate == other.dueDate &&
          isCompleted == other.isCompleted &&
          listEquals(subtasks, other.subtasks) &&
          energyLevel == other.energyLevel;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      urgency.hashCode ^
      importance.hashCode ^
      estimatedMinutes.hashCode ^
      dueDate.hashCode ^
      isCompleted.hashCode ^
      subtasks.hashCode ^
      energyLevel.hashCode;
}