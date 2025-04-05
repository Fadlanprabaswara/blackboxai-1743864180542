import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class CollaborationScreen extends StatefulWidget {
  const CollaborationScreen({super.key});

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen> {
  final List<String> _teamMembers = [
    'Alice Johnson',
    'Bob Smith',
    'Carol Williams',
    'David Brown',
  ];

  final List<String> _integrations = [
    'Slack',
    'Microsoft Teams',
    'Google Workspace',
    'Notion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collaboration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _inviteTeamMember,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTeamSection(),
          const SizedBox(height: 24),
          _buildSharedTasksSection(),
          const SizedBox(height: 24),
          _buildIntegrationsSection(),
          const SizedBox(height: 24),
          _buildActivityFeed(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shareNewTask,
        icon: const Icon(Icons.share),
        label: const Text('Share Task'),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.group_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Team Members',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _teamMembers.map((member) => _buildTeamMemberChip(member)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberChip(String name) {
    final initials = name.split(' ').map((e) => e[0]).join('');
    
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          initials,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 12,
          ),
        ),
      ),
      label: Text(name),
      onPressed: () => _showMemberDetails(name),
    );
  }

  Widget _buildSharedTasksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_shared_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Shared Tasks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSharedTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        // Simulated shared tasks
        final sharedTasks = taskProvider.tasks.take(3).toList();

        if (sharedTasks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No shared tasks yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sharedTasks.length,
          itemBuilder: (context, index) {
            final task = sharedTasks[index];
            return _buildSharedTaskTile(task);
          },
        );
      },
    );
  }

  Widget _buildSharedTaskTile(Task task) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.assignment),
      ),
      title: Text(task.title),
      subtitle: Text(
        'Shared with ${_teamMembers[0]} and 2 others',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => _showTaskOptions(task),
      ),
    );
  }

  Widget _buildIntegrationsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.integration_instructions_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Integrations',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _integrations.length,
              itemBuilder: (context, index) {
                return _buildIntegrationTile(_integrations[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationTile(String integration) {
    IconData getIntegrationIcon(String name) {
      switch (name.toLowerCase()) {
        case 'slack':
          return Icons.message_rounded;
        case 'microsoft teams':
          return Icons.groups_rounded;
        case 'google workspace':
          return Icons.work_rounded;
        case 'notion':
          return Icons.note_rounded;
        default:
          return Icons.integration_instructions_rounded;
      }
    }

    return ListTile(
      leading: Icon(getIntegrationIcon(integration)),
      title: Text(integration),
      trailing: Switch(
        value: true, // Simulated connection status
        onChanged: (value) => _toggleIntegration(integration, value),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timeline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              'Alice Johnson shared a new task',
              '2 hours ago',
              Icons.share,
            ),
            _buildActivityItem(
              'Bob Smith completed "Project Review"',
              '4 hours ago',
              Icons.check_circle,
            ),
            _buildActivityItem(
              'Carol Williams commented on a task',
              'Yesterday',
              Icons.comment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String text, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _inviteTeamMember() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Team Member'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter email address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Send Invite'),
          ),
        ],
      ),
    );
  }

  void _showMemberDetails(String name) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Text(name[0]),
              ),
              title: Text(name),
              subtitle: const Text('Team Member'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Assigned Tasks'),
              trailing: const Text('5'),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Completed Tasks'),
              trailing: const Text('12'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareNewTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Share with:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: _teamMembers
                          .take(2)
                          .map((e) => Chip(label: Text(e)))
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskOptions(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit task
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Collaborators'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add collaborators
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Task'),
              textColor: Theme.of(context).colorScheme.error,
              iconColor: Theme.of(context).colorScheme.error,
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement remove task
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleIntegration(String integration, bool value) {
    // TODO: Implement integration toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${value ? 'Connected to' : 'Disconnected from'} $integration'),
      ),
    );
  }
}