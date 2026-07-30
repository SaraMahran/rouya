import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/interview_model.dart';

class InterviewsScreen extends StatelessWidget {
  const InterviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final state = context.watch<AppStateProvider>();
    final iv = state.interviews;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Practice log',
                  style: TextStyle(color: t.textDim, fontSize: 12),
                ),
                Text(
                  'Interviews',
                  style: TextStyle(
                    color: t.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                // Streak card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(t.radius),
                    border: Border.all(color: t.border),
                  ),
                  child: Row(
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${iv.streak}',
                                style: TextStyle(
                                  color: t.gold,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'days',
                                style: TextStyle(
                                  color: t.textDim,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Consecutive days with practice',
                            style: TextStyle(color: t.textDim, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Technical + HR counters
                Row(
                  children: [
                    Expanded(
                      child: _CounterCard(
                        t: t,
                        label: 'TECHNICAL',
                        value: iv.technical,
                        color: t.accent,
                        onLog: () => state.addInterviewRecord(InterviewRecord(
                          id: 'i${DateTime.now().millisecondsSinceEpoch}',
                          company: 'Quick log',
                          role: 'Interview',
                          type: 'Technical',
                          date: DateTime.now(),
                          outcome: 'Pending',
                        )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CounterCard(
                        t: t,
                        label: 'HR / PERSONAL',
                        value: iv.hr,
                        color: t.accent2,
                        onLog: () => state.addInterviewRecord(InterviewRecord(
                          id: 'i${DateTime.now().millisecondsSinceEpoch}',
                          company: 'Quick log',
                          role: 'Interview',
                          type: 'HR',
                          date: DateTime.now(),
                          outcome: 'Pending',
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  'Recent history',
                  style: TextStyle(
                    color: t.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // History list
          Expanded(
            child: iv.history.isEmpty
                ? Center(
                    child: Text(
                      'No interviews logged yet',
                      style: TextStyle(color: t.textDim),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: iv.history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final entry = iv.history[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: t.surface,
                          borderRadius: BorderRadius.circular(t.radius),
                          border: Border.all(color: t.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: entry.type == 'Technical'
                                    ? t.accentTint
                                    : t.accent2Tint,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                entry.type,
                                style: TextStyle(
                                  color: entry.type == 'Technical'
                                      ? t.accent
                                      : t.accent2,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${entry.company} — ${entry.role}',
                                style: TextStyle(color: t.text, fontSize: 14),
                              ),
                            ),
                            Text(
                              entry.outcome,
                              style: TextStyle(color: t.textDim, fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final RouyaTheme t;
  final String label;
  final int value;
  final Color color;
  final VoidCallback onLog;

  const _CounterCard({
    required this.t,
    required this.label,
    required this.value,
    required this.color,
    required this.onLog,
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
          Text(
            label,
            style: TextStyle(
              color: t.textFaint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onLog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: color, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Log one',
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
