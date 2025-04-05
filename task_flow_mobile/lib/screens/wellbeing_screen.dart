import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({super.key});

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  double _stressLevel = 3;
  bool _isBreakTime = false;
  bool _isMeditating = false;
  int _focusMinutes = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStressLevelCard(),
                  const SizedBox(height: 16),
                  _buildBreakSuggestionCard(),
                  const SizedBox(height: 16),
                  _buildMeditationCard(),
                  const SizedBox(height: 16),
                  _buildWorkLifeBalanceCard(),
                  const SizedBox(height: 16),
                  _buildHealthTipsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Wellbeing'),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1506126613408-eca07ce68773',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.background,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressLevelCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Stress Level',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.sentiment_satisfied_alt,
                  color: _getStressColor(_stressLevel),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStressLevelText(_stressLevel),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Slider(
                        value: _stressLevel,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _getStressLevelText(_stressLevel),
                        onChanged: (value) {
                          setState(() {
                            _stressLevel = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakSuggestionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.coffee_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Break Time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isBreakTime
                  ? 'Time remaining: $_focusMinutes minutes'
                  : 'Take a 5-minute break to refresh your mind',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _toggleBreak,
                icon: Icon(_isBreakTime ? Icons.stop : Icons.play_arrow),
                label: Text(_isBreakTime ? 'End Break' : 'Start Break'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.self_improvement_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mindfulness',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isMeditating
                  ? 'Breathe in... Breathe out...'
                  : 'Take a moment to practice mindfulness',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _toggleMeditation,
                icon: Icon(_isMeditating ? Icons.stop : Icons.play_arrow),
                label: Text(_isMeditating ? 'End Session' : 'Start Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkLifeBalanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.balance_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Work-Life Balance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBalanceMetric('Work Hours', 0.7),
            const SizedBox(height: 8),
            _buildBalanceMetric('Break Time', 0.3),
            const SizedBox(height: 8),
            _buildBalanceMetric('Focus Sessions', 0.8),
            const SizedBox(height: 16),
            Text(
              'Recommendation: Consider taking more regular breaks',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceMetric(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ],
    );
  }

  Widget _buildHealthTipsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tips_and_updates_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Wellness Tips',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTip(
              icon: Icons.water_drop,
              title: 'Stay Hydrated',
              description: 'Drink water regularly throughout your work session',
            ),
            const SizedBox(height: 12),
            _buildTip(
              icon: Icons.remove_red_eye,
              title: '20-20-20 Rule',
              description: 'Every 20 minutes, look at something 20 feet away for 20 seconds',
            ),
            const SizedBox(height: 12),
            _buildTip(
              icon: Icons.straighten,
              title: 'Maintain Posture',
              description: 'Keep your back straight and screen at eye level',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip({
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
            size: 20,
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

  Color _getStressColor(double level) {
    if (level <= 2) return Colors.green;
    if (level <= 3) return Colors.orange;
    return Colors.red;
  }

  String _getStressLevelText(double level) {
    if (level <= 2) return 'Low Stress';
    if (level <= 3) return 'Moderate Stress';
    if (level <= 4) return 'High Stress';
    return 'Very High Stress';
  }

  void _toggleBreak() {
    setState(() {
      _isBreakTime = !_isBreakTime;
      if (_isBreakTime) {
        _focusMinutes = 5;
        _startBreakTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _toggleMeditation() {
    setState(() {
      _isMeditating = !_isMeditating;
    });
  }

  void _startBreakTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        if (_focusMinutes > 0) {
          _focusMinutes--;
        } else {
          _isBreakTime = false;
          timer.cancel();
        }
      });
    });
  }
}