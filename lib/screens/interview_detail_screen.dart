import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/interview_model.dart';

class InterviewDetailScreen extends StatelessWidget {
  final InterviewRecord record;
  const InterviewDetailScreen({super.key, required this.record});

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
    final t = context.watch<ThemeProvider>().theme;

    return Scaffold(
      backgroundColor: t.bg0,
      appBar: AppBar(
        backgroundColor: t.bg1,
        foregroundColor: t.text,
        elevation: 0,
        title: Text(record.company,
            style: TextStyle(color: t.text,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(t.radius),
                border: Border.all(color: t.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.role,
                      style: TextStyle(color: t.text, fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(record.company,
                      style: TextStyle(color: t.accent, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: record.type == 'Technical'
                              ? t.accentTint : t.accent2Tint,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(record.type,
                            style: TextStyle(
                                color: record.type == 'Technical'
                                    ? t.accent : t.accent2,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _outcomeColor().withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(record.outcome,
                            style: TextStyle(
                                color: _outcomeColor(),
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(t: t,
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: '${record.date.day}/${record.date.month}/${record.date.year}'),
            if (record.meetingTime != null)
              _DetailRow(t: t,
                  icon: Icons.access_time,
                  label: 'Time',
                  value: record.meetingTime!),
            if (record.purpose != null)
              _DetailRow(t: t,
                  icon: Icons.info_outline,
                  label: 'Purpose',
                  value: record.purpose!),
            if (record.rating != null) ...[
              const SizedBox(height: 16),
              Text('Self Rating',
                  style: TextStyle(color: t.textDim, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (i) => Icon(
                    i < record.rating!
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: t.gold, size: 24)),
              ),
            ],
            if (record.notes != null) ...[
              const SizedBox(height: 16),
              _Section(t: t, title: 'Notes', content: record.notes!),
            ],
            if (record.candidateFeedback != null) ...[
              const SizedBox(height: 16),
              _Section(t: t,
                  title: 'Candidate Feedback',
                  content: record.candidateFeedback!),
            ],
            if (record.surveyRating != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(t.radius),
                  border: Border.all(color: t.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Candidate Survey',
                        style: TextStyle(color: t.textDim, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(record.surveyRating!.toStringAsFixed(1),
                            style: TextStyle(color: t.gold, fontSize: 36,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Text('/ 5.0',
                            style: TextStyle(
                                color: t.textDim, fontSize: 16)),
                        const Spacer(),
                        Text('${record.surveyRespondents} respondents',
                            style: TextStyle(
                                color: t.textDim, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final RouyaTheme t;
  final IconData icon;
  final String label, value;

  const _DetailRow({
    required this.t, required this.icon,
    required this.label, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: t.textFaint, size: 16),
          const SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(color: t.textDim, fontSize: 13)),
          Text(value,
              style: TextStyle(color: t.text, fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final RouyaTheme t;
  final String title, content;

  const _Section({
    required this.t, required this.title, required this.content,
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
          Text(title,
              style: TextStyle(color: t.textDim, fontSize: 13)),
          const SizedBox(height: 8),
          Text(content,
              style: TextStyle(color: t.text, fontSize: 14,
                  height: 1.6)),
        ],
      ),
    );
  }
}