import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/category_model.dart';

const int _monthlyGoal = 50;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greetingTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _contextualLine(AppStateProvider state) {
    final streak = state.interviews.streak;
    final total = state.totalAchievements;
    final weekActivity = state.interviews.chart.length >= 7
        ? state.interviews.chart.sublist(state.interviews.chart.length - 7)
        : state.interviews.chart;
    final activeDaysThisWeek = weekActivity.where((v) => v > 0).length;

    if (streak >= 10) {
      return "You're on a $streak day streak — keep it going";
    }
    if (activeDaysThisWeek >= 5) {
      return 'Active $activeDaysThisWeek of the last 7 days. Strong week';
    }
    if (total > 0) {
      return '$total logged so far. Add something today';
    }
    return 'Tap + on any category to start tracking';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final state = context.watch<AppStateProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('${_greetingTime()}, Sara',
                style: TextStyle(color: t.textDim, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Rouya ',
                    style: TextStyle(
                      color: t.text, fontSize: 28,
                      fontFamily: 'Cormorant Garamond',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    )),
                Text('رؤيا',
                    style: TextStyle(
                      color: t.accent, fontSize: 18,
                      fontFamily: 'NotoKufiArabic',
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            const SizedBox(height: 6),
            Text(_contextualLine(state),
                style: TextStyle(color: t.textDim, fontSize: 13,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),

            // Hero streak card
            _StreakCard(t: t, state: state),
            const SizedBox(height: 16),

            // Progress ring + interview stats
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: _ProgressRingCard(t: t, state: state),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _StatCard(
                          t: t, label: 'Technical',
                          value: '${state.interviews.technical}',
                          sublabel: 'interviews',
                          color: t.accent2),
                      const SizedBox(height: 12),
                      _StatCard(
                          t: t, label: 'HR',
                          value: '${state.interviews.hr}',
                          sublabel: 'interviews',
                          color: t.accent2),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Categories
            Text('Top categories',
                style: TextStyle(color: t.text, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...state.categories.take(3).map((cat) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CategoryTile(
                  t: t, cat: cat,
                  onIncrement: () => state.increment(cat.id)),
            )),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final RouyaTheme t;
  final AppStateProvider state;

  const _StreakCard({required this.t, required this.state});

  @override
  Widget build(BuildContext context) {
    final streak = state.interviews.streak;
    final chart = state.interviews.chart;
    final last7 = chart.length >= 7
        ? chart.sublist(chart.length - 7)
        : List<int>.filled(7 - chart.length, 0) + chart;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(color: t.gold.withValues(alpha: 0.35)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            t.gold.withValues(alpha: 0.16),
            t.surface,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: t.gold.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('🔥', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$streak',
                        style: TextStyle(color: t.gold, fontSize: 30,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Text('day streak',
                        style: TextStyle(color: t.textDim, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(7, (i) {
                    final active = last7[i] > 0;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        width: 20, height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? t.gold
                              : t.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingCard extends StatelessWidget {
  final RouyaTheme t;
  final AppStateProvider state;

  const _ProgressRingCard({required this.t, required this.state});

  @override
  Widget build(BuildContext context) {
    final total = state.totalAchievements;
    final progress = (total / _monthlyGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(color: t.border),
      ),
      child: Column(
        children: [
          Text('THIS MONTH',
              style: TextStyle(color: t.textFaint, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          SizedBox(
            width: 92, height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 92, height: 92,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: t.border,
                    valueColor: AlwaysStoppedAnimation(t.accent),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$total',
                        style: TextStyle(color: t.text, fontSize: 22,
                            fontWeight: FontWeight.w700)),
                    Text('/ $_monthlyGoal',
                        style: TextStyle(color: t.textDim, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('${state.categories.length} categories',
              style: TextStyle(color: t.textDim, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final RouyaTheme t;
  final String label, value, sublabel;
  final Color color;

  const _StatCard({
    required this.t, required this.label,
    required this.value, required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(color: t.textFaint, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(color: color, fontSize: 32,
                  fontWeight: FontWeight.w700)),
          Text(sublabel,
              style: TextStyle(color: t.textDim, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final RouyaTheme t;
  final CategoryModel cat;
  final VoidCallback onIncrement;

  const _CategoryTile({
    required this.t, required this.cat,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(color: t.border),
      ),
      child: Row(
        children: [
          Text(cat.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat.name,
                    style: TextStyle(color: t.text, fontSize: 15,
                        fontWeight: FontWeight.w600)),
                Text('${cat.count} total',
                    style: TextStyle(color: t.textDim, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: t.accentTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.border),
              ),
              child: Icon(Icons.add, color: t.accent, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}