import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/category_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
            Text('Good morning, Sara',
                style: TextStyle(color: t.textDim, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 52,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats row 1
            Row(
              children: [
                Expanded(child: _StatCard(
                    t: t, label: 'Total',
                    value: '${state.totalAchievements}',
                    sublabel: '${state.categories.length} categories',
                    color: t.accent)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(
                    t: t, label: 'Streak',
                    value: '${state.interviews.streak}',
                    sublabel: 'days',
                    color: t.gold)),
              ],
            ),
            const SizedBox(height: 12),

            // Stats row 2
            Row(
              children: [
                Expanded(child: _StatCard(
                    t: t, label: 'Technical',
                    value: '${state.interviews.technical}',
                    sublabel: 'interviews',
                    color: t.accent2)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(
                    t: t, label: 'HR',
                    value: '${state.interviews.hr}',
                    sublabel: 'interviews',
                    color: t.accent2)),
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