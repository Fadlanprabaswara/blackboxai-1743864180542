import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/settings_provider.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
      }
    }
    
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showFab) {
        setState(() => _showFab = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTaskList(),
      floatingActionButton: _buildFab(),
      drawer: _buildDrawer(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'TaskFlow',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Implement search functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // TODO: Implement filter functionality
          },
        ),
        IconButton(
          icon: Consumer<SettingsProvider>(
            builder: (context, settings, _) => Icon(
              settings.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          onPressed: () {
            final settings = context.read<SettingsProvider>();
            settings.toggleDarkMode();
          },
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final tasks = taskProvider.sortedTasks;
        
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a task to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _buildOverdueTasks(taskProvider),
            ),
            SliverToBoxAdapter(
              child: _buildTodayTasks(taskProvider),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = tasks[index];
                  return TaskTile(
                    task: task,
                    onTap: () => _openTaskDetails(task),
                    onToggle: (completed) {
                      taskProvider.toggleTaskCompletion(task.id);
                    },
                  );
                },
                childCount: tasks.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverdueTasks(TaskProvider taskProvider) {
    final overdueTasks = taskProvider.getOverdueTasks();
    if (overdueTasks.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.error.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Overdue Tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...overdueTasks.map((task) => TaskTile(
              task: task,
              onTap: () => _openTaskDetails(task),
              onToggle: (completed) {
                taskProvider.toggleTaskCompletion(task.id);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTasks(TaskProvider taskProvider) {
    final todayTasks = taskProvider.getTasksDueToday();
    if (todayTasks.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.today_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Due Today',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...todayTasks.map((task) => TaskTile(
              task: task,
              onTap: () => _openTaskDetails(task),
              onToggle: (completed) {
                taskProvider.toggleTaskCompletion(task.id);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: _showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showFab ? 1 : 0,
        child: FloatingActionButton.extended(
          onPressed: _createNewTask,
          label: const Text('Add Task'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  'TaskFlow',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'Manage your tasks efficiently',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.insights_rounded),
            title: const Text('Productivity Insights'),
            onTap: () {
              // TODO: Navigate to productivity insights
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_rounded),
            title: const Text('Collaboration'),
            onTap: () {
              // TODO: Navigate to collaboration screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.spa_rounded),
            title: const Text('Well-being'),
            onTap: () {
              // TODO: Navigate to well-being screen
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Navigate to settings screen
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _createNewTask() {
    // TODO: Implement task creation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SizedBox(), // TODO: Add task creation form
    );
  }

  void _openTaskDetails(Task task) {
    // TODO: Implement task details navigation
  }
}