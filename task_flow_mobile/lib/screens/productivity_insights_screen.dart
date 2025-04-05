import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';

class ProductivityInsightsScreen extends StatefulWidget {
  const ProductivityInsightsScreen({super.key});

  @override
  State<ProductivityInsightsScreen> createState() => _ProductivityInsightsScreenState();
}

class _ProductivityInsightsScreenState extends State<ProductivityInsightsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 1; // 0: Daily, 1: Weekly, 2: Monthly

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity Insights'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trends'),
            Tab(text: 'Analysis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTrendsTab(),
          _buildAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final productivityScore = taskProvider.getProductivityScore();
        final completedTasks = taskProvider.completedTasks.length;
        final totalTasks = taskProvider.tasks.length;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductivityScoreCard(productivityScore),
              const SizedBox(height: 16),
              _buildTaskCompletionCard(completedTasks, totalTasks),
              const SizedBox(height: 16),
              _buildRecommendationsCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductivityScoreCard(double score) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productivity Score',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '${score.round()}',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 10,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCompletionCard(int completed, int total) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Completion',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: total > 0 ? completed / total : 0,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '$completed of $total tasks completed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              icon: Icons.timer,
              title: 'Best Working Hours',
              description: 'Your productivity peaks between 9 AM and 11 AM',
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              icon: Icons.battery_charging_full,
              title: 'Energy Management',
              description: 'Schedule challenging tasks for your high-energy periods',
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              icon: Icons.psychology,
              title: 'Focus Improvement',
              description: 'Try the Pomodoro Technique: 25min work, 5min break',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          _buildProductivityChart(),
          const SizedBox(height: 24),
          _buildTaskDistributionChart(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 0, label: Text('Daily')),
        ButtonSegment(value: 1, label: Text('Weekly')),
        ButtonSegment(value: 2, label: Text('Monthly')),
      ],
      selected: {_selectedPeriod},
      onSelectionChanged: (Set<int> newSelection) {
        setState(() {
          _selectedPeriod = newSelection.first;
        });
      },
    );
  }

  Widget _buildProductivityChart() {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 4),
                const FlSpot(2, 3.5),
                const FlSpot(3, 5),
                const FlSpot(4, 4),
                const FlSpot(5, 4.5),
                const FlSpot(6, 5),
              ],
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDistributionChart() {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              title: '40%\nUrgent',
              color: Colors.red.shade400,
              radius: 100,
            ),
            PieChartSectionData(
              value: 30,
              title: '30%\nImportant',
              color: Colors.orange.shade400,
              radius: 100,
            ),
            PieChartSectionData(
              value: 30,
              title: '30%\nRoutine',
              color: Colors.blue.shade400,
              radius: 100,
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 0,
        ),
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAnalysisCard(
          title: 'Peak Productivity Hours',
          content: _buildPeakHoursContent(),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          title: 'Task Completion Patterns',
          content: _buildCompletionPatternsContent(),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          title: 'Energy Level Impact',
          content: _buildEnergyLevelContent(),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard({
    required String title,
    required Widget content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildPeakHoursContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your most productive hours are:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        _buildProductivityTimeSlot('Morning (9 AM - 11 AM)', 0.9),
        _buildProductivityTimeSlot('Afternoon (2 PM - 4 PM)', 0.7),
        _buildProductivityTimeSlot('Evening (7 PM - 9 PM)', 0.5),
      ],
    );
  }

  Widget _buildProductivityTimeSlot(String timeSlot, double productivity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeSlot),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: productivity,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionPatternsContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text('Most tasks completed on Wednesdays'),
          subtitle: Text('Average of 8 tasks per day'),
        ),
        ListTile(
          leading: Icon(Icons.timer_outlined),
          title: Text('Average completion time: 45 minutes'),
          subtitle: Text('25% faster than last week'),
        ),
        ListTile(
          leading: Icon(Icons.trending_up),
          title: Text('Completion rate improving'),
          subtitle: Text('15% increase in the last month'),
        ),
      ],
    );
  }

  Widget _buildEnergyLevelContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Energy Level Distribution',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        _buildEnergyLevelBar('High Energy', 0.8, Colors.green),
        _buildEnergyLevelBar('Medium Energy', 0.6, Colors.orange),
        _buildEnergyLevelBar('Low Energy', 0.3, Colors.red),
      ],
    );
  }

  Widget _buildEnergyLevelBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}