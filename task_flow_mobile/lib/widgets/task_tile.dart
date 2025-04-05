import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: _buildDismissBackground(context, DismissDirection.startToEnd),
      secondaryBackground: _buildDismissBackground(context, DismissDirection.endToStart),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Archive functionality
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Archive Task'),
              content: const Text('Do you want to archive this task?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Archive'),
                ),
              ],
            ),
          );
        } else {
          // Delete functionality
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Task'),
              content: const Text('Are you sure you want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildCheckbox(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(context),
                          if (task.description.isNotEmpty)
                            _buildDescription(context),
                        ],
                      ),
                    ),
                    _buildPriorityIndicator(context),
                  ],
                ),
                if (task.subtasks.isNotEmpty || task.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 40),
                        if (task.subtasks.isNotEmpty) _buildSubtasksIndicator(context),
                        if (task.subtasks.isNotEmpty && task.dueDate != null)
                          const SizedBox(width: 16),
                        if (task.dueDate != null) _buildDueDate(context),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggle(value ?? false),
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      task.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        color: task.isCompleted
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        task.description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriorityIndicator(BuildContext context) {
    final priorityScore = task.calculatePriorityScore();
    Color priorityColor;
    IconData priorityIcon;

    if (priorityScore >= 0.7) {
      priorityColor = Colors.red;
      priorityIcon = Icons.priority_high;
    } else if (priorityScore >= 0.4) {
      priorityColor = Colors.orange;
      priorityIcon = Icons.arrow_upward;
    } else {
      priorityColor = Colors.green;
      priorityIcon = Icons.arrow_downward;
    }

    return Icon(
      priorityIcon,
      color: priorityColor.withOpacity(task.isCompleted ? 0.5 : 1.0),
      size: 20,
    );
  }

  Widget _buildSubtasksIndicator(BuildContext context) {
    final completedSubtasks = task.subtasks.where((subtask) => subtask.isCompleted).length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.checklist_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Text(
          '$completedSubtasks/${task.subtasks.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDate(BuildContext context) {
    final isOverdue = task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.event,
          size: 16,
          color: isOverdue
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('MMM d').format(task.dueDate!),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isOverdue
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildDismissBackground(BuildContext context, DismissDirection direction) {
    final isArchive = direction == DismissDirection.startToEnd;
    return Container(
      alignment: isArchive ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: isArchive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.error,
      child: Icon(
        isArchive ? Icons.archive : Icons.delete,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}