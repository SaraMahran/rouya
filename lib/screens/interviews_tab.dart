import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/interview_model.dart';
import 'interview_detail_screen.dart';
import 'log_interview_form.dart';
import 'survey_results_screen.dart';

class InterviewsTab extends StatelessWidget {
  final RouyaTheme t;
  final AppStateProvider state;

  const InterviewsTab({super.key, required this.t, required this.state});

  @override
  Widget build(BuildContext context) {
    final iv = state.interviews;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: t.accent,
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: t.bg2,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          builder: (_) => LogInterviewForm(t: t, state: state),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                Expanded(child: _StatCard(
                    t: t, label: 'TECHNICAL',
                    value: '${iv.technical}',
                    color: t.accent)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(
                    t: t, label: 'HR',
                    value: '${iv.hr}',
                    color: t.accent2)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(
                    t: t, label: 'STREAK',
                    value: '${iv.streak}',
                    color: t.gold,
                    suffix: 'd')),
              ],
            ),
            const SizedBox(height: 12),

            // Survey results button
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => const SurveyResultsScreen())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.goldTint,
                  borderRadius: BorderRadius.circular(t.radius),
                  border: Border.all(
                      color: t.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, color: t.gold, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Candidate Survey Results',
                              style: TextStyle(color: t.text,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text('See how candidates rated your interviews',
                              style: TextStyle(color: t.textDim,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: t.textFaint, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Interview Log',
                style: TextStyle(color: t.text, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            iv.history.isEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Column(
                  children: [
                    const Text('💼',
                        style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text('No interviews logged yet',
                        style: TextStyle(color: t.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Tap + to log your first interview',
                        style: TextStyle(color: t.textDim,
                            fontSize: 14)),
                  ],
                ),
              ),
            )
                : Column(
              children: iv.history.map((record) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InterviewCard(
                  t: t,
                  record: record,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => InterviewDetailScreen(
                              record: record))),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final RouyaTheme t;
  final String label, value;
  final Color color;
  final String suffix;

  const _StatCard({
    required this.t, required this.label,
    required this.value, required this.color,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: t.textFaint, fontSize: 9,
                  fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: TextStyle(color: color, fontSize: 28,
                      fontWeight: FontWeight.w700)),
              if (suffix.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 2),
                  child: Text(suffix,
                      style: TextStyle(color: t.textDim, fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class InterviewCard extends StatelessWidget {
  final RouyaTheme t;
  final InterviewRecord record;
  final VoidCallback onTap;

  const InterviewCard({
    super.key,
    required this.t,
    required this.record,
    required this.onTap,
  });

  Color _outcomeColor() {
    switch (record.outcome) {
      case 'Passed': return const Color(0xFF4CAF50);
      case 'Advanced': return const Color(0xFF2196F3);
      case 'Failed': return const Color(0xFFF44336);
      case 'Rejected': return const Color(0xFF9E9E9E);
      default: return const Color(0xFFFF9800);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(t.radius),
          border: Border.all(color: t.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: record.type == 'Technical'
                        ? t.accentTint : t.accent2Tint,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(record.type,
                      style: TextStyle(
                          color: record.type == 'Technical'
                              ? t.accent : t.accent2,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _outcomeColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(record.outcome,
                      style: TextStyle(
                          color: _outcomeColor(),
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(record.company,
                style: TextStyle(color: t.text, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            Text(record.role,
                style: TextStyle(color: t.textDim, fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: t.textFaint, size: 13),
                const SizedBox(width: 4),
                Text(
                    '${record.date.day}/${record.date.month}/${record.date.year}',
                    style: TextStyle(color: t.textDim, fontSize: 12)),
                if (record.meetingTime != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.access_time,
                      color: t.textFaint, size: 13),
                  const SizedBox(width: 4),
                  Text(record.meetingTime!,
                      style: TextStyle(color: t.textDim, fontSize: 12)),
                ],
                const Spacer(),
                if (record.rating != null)
                  Row(
                    children: List.generate(5, (i) => Icon(
                        i < record.rating!
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: t.gold, size: 14)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}