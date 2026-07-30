import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/rouya_themes.dart';
import '../services/supabase_service.dart';

class SurveyResultsScreen extends StatefulWidget {
  const SurveyResultsScreen({super.key});

  @override
  State<SurveyResultsScreen> createState() => _SurveyResultsScreenState();
}

class _SurveyResultsScreenState extends State<SurveyResultsScreen> {
  InterviewSurveyResult? _result;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final result = await SupabaseService.fetchSurveyResults();
      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
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
        title: Text('Candidate Survey Results',
            style: TextStyle(color: t.text,
                fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: t.accent))
          : _error != null
          ? Center(child: Text('Error: $_error',
          style: TextStyle(color: t.textDim)))
          : _result == null
          ? Center(child: Text('No survey data yet',
          style: TextStyle(color: t.textDim)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(t.radius),
                border: Border.all(color: t.border),
              ),
              child: Column(
                children: [
                  Text('${_result!.avgOverallRating.toStringAsFixed(1)}',
                      style: TextStyle(color: t.gold,
                          fontSize: 56, fontWeight: FontWeight.w700)),
                  Text('out of 10',
                      style: TextStyle(color: t.textDim, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('${_result!.respondentCount} candidates responded',
                      style: TextStyle(color: t.textDim, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('BREAKDOWN',
                style: TextStyle(color: t.textFaint, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 12),

            _RatingBar(t: t,
                label: 'Friendliness & Professionalism',
                value: _result!.avgFriendliness,
                maxValue: 5,
                color: t.accent),
            _RatingBar(t: t,
                label: 'Candidate Comfort',
                value: _result!.avgFeel,
                maxValue: 5,
                color: t.accent2),
            _RatingBar(t: t,
                label: 'Question Relevance',
                value: _result!.avgRelevance,
                maxValue: 5,
                color: t.accent),
            _RatingBar(t: t,
                label: 'Fair Opportunity to Speak',
                value: _result!.avgFairOpportunity,
                maxValue: 5,
                color: t.accent2),
            _RatingBar(t: t,
                label: 'Process Clarity',
                value: _result!.avgExplainedProcess,
                maxValue: 5,
                color: t.accent),
            _RatingBar(t: t,
                label: 'Overall Fairness',
                value: _result!.avgFairness,
                maxValue: 5,
                color: t.gold),

            if (_result!.improvementSuggestions != null &&
                _result!.improvementSuggestions!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('IMPROVEMENT SUGGESTIONS',
                  style: TextStyle(color: t.textFaint, fontSize: 11,
                      fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(t.radius),
                  border: Border.all(color: t.border),
                ),
                child: Text(
                    _result!.improvementSuggestions!
                        .split(' | ')
                        .map((s) => '• $s')
                        .join('\n\n'),
                    style: TextStyle(color: t.text,
                        fontSize: 14, height: 1.6)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final RouyaTheme t;
  final String label;
  final double value;
  final double maxValue;
  final Color color;

  const _RatingBar({
    required this.t, required this.label,
    required this.value, required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value / maxValue).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(color: t.text, fontSize: 13,
                      fontWeight: FontWeight.w600)),
              Text(value.toStringAsFixed(1),
                  style: TextStyle(color: color, fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}