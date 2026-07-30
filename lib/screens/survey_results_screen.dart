import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/theme_provider.dart';
import '../theme/rouya_themes.dart';
import '../services/supabase_service.dart';

class SurveyResultsScreen extends StatefulWidget {
  const SurveyResultsScreen({super.key});

  @override
  State<SurveyResultsScreen> createState() => _SurveyResultsScreenState();
}

class _SurveyResultsScreenState extends State<SurveyResultsScreen>
    with TickerProviderStateMixin {
  InterviewSurveyResult? _result;
  bool _loading = true;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  int? _selectedBubble;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final result = await SupabaseService.fetchSurveyResults();
      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: t.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: t.text,
        elevation: 0,
        title: Text('Candidate Feedback',
            style: TextStyle(color: t.text,
                fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: t.accent))
          : _result == null
          ? Center(child: Text('No data yet',
          style: TextStyle(color: t.textDim)))
          : Stack(
        children: [
          // Background glow
          Positioned(
            top: size.height * 0.1,
            left: size.width * 0.2,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      t.accent.withValues(
                          alpha: 0.15 + _pulseController.value * 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Center hero score
          Positioned(
            top: size.height * 0.18,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Column(
                children: [
                  Text(
                    _result!.avgOverallRating.toStringAsFixed(1),
                    style: TextStyle(
                      color: t.gold,
                      fontSize: 96,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: t.gold.withValues(alpha:
                          0.3 + _pulseController.value * 0.3),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  Text('out of 10',
                      style: TextStyle(color: t.textDim,
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                      '${_result!.respondentCount} candidates',
                      style: TextStyle(color: t.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          // Floating metric bubbles
          ..._buildBubbles(t, size),

          // Candidate voices bottom sheet trigger
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _showVoices(context, t),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(t.radius),
                  border: Border.all(
                      color: t.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('💬',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('Read candidate voices',
                        style: TextStyle(color: t.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_upward,
                        color: t.accent, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBubbles(RouyaTheme t, Size size) {
    if (_result == null) return [];

    final metrics = [
      _Metric('🤝', 'Friendliness', _result!.avgFriendliness, 5, t.accent),
      _Metric('😌', 'Comfort', _result!.avgFeel, 5, t.accent2),
      _Metric('🎯', 'Relevance', _result!.avgRelevance, 5, t.accent),
      _Metric('🗣️', 'Fair Opp.', _result!.avgFairOpportunity, 5, t.accent2),
      _Metric('📋', 'Clarity', _result!.avgExplainedProcess, 5, t.gold),
      _Metric('⚖️', 'Fairness', _result!.avgFairness, 5, t.accent),
    ];

    // Positions around the center score
    final positions = [
      Offset(0.05, 0.08),   // top left
      Offset(0.62, 0.05),   // top right
      Offset(0.72, 0.38),   // right
      Offset(0.60, 0.65),   // bottom right
      Offset(0.02, 0.62),   // bottom left
      Offset(-0.05, 0.35),  // left
    ];

    return List.generate(metrics.length, (i) {
      final m = metrics[i];
      final pos = positions[i];
      final isSelected = _selectedBubble == i;

      return AnimatedBuilder(
        animation: _floatController,
        builder: (_, __) {
          final floatOffset = math.sin(
              _floatController.value * math.pi * 2 + i * 1.0) * 8;

          return Positioned(
            left: size.width * (0.1 + pos.dx * 0.8),
            top: size.height * (0.08 + pos.dy * 0.6) + floatOffset,
            child: GestureDetector(
              onTap: () => setState(() =>
              _selectedBubble = isSelected ? null : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 110 : 80,
                height: isSelected ? 110 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: m.color.withValues(alpha: 0.15),
                  border: Border.all(
                      color: m.color.withValues(alpha:
                      isSelected ? 0.8 : 0.4),
                      width: isSelected ? 2 : 1),
                  boxShadow: [
                    BoxShadow(
                      color: m.color.withValues(alpha:
                      isSelected ? 0.3 : 0.1),
                      blurRadius: isSelected ? 20 : 8,
                      spreadRadius: isSelected ? 4 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.emoji,
                        style: TextStyle(
                            fontSize: isSelected ? 22 : 18)),
                    const SizedBox(height: 2),
                    Text(m.value.toStringAsFixed(1),
                        style: TextStyle(
                            color: m.color,
                            fontSize: isSelected ? 18 : 14,
                            fontWeight: FontWeight.w700)),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(m.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: m.color,
                                fontSize: 9,
                                fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _showVoices(BuildContext context, RouyaTheme t) {
    if (_result?.improvementSuggestions == null) return;

    final suggestions = _result!.improvementSuggestions!
        .split(' | ')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: t.bg2,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('💬',
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Candidate Voices',
                      style: TextStyle(color: t.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${suggestions.length} responses',
                      style: TextStyle(color: t.textDim,
                          fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: suggestions.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (_, i) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(t.radius),
                    border: Border.all(color: t.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: t.accentTint,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${i + 1}',
                              style: TextStyle(color: t.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(suggestions[i].trim(),
                            style: TextStyle(color: t.text,
                                fontSize: 14, height: 1.6,
                                fontStyle: FontStyle.italic)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric {
  final String emoji, label;
  final double value, maxValue;
  final Color color;

  _Metric(this.emoji, this.label, this.value,
      this.maxValue, this.color);
}