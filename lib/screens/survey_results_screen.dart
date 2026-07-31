// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:math' as math;
// import '../providers/theme_provider.dart';
// import '../theme/rouya_themes.dart';
// import '../services/supabase_service.dart';
//
// class SurveyResultsScreen extends StatefulWidget {
//   const SurveyResultsScreen({super.key});
//
//   @override
//   State<SurveyResultsScreen> createState() => _SurveyResultsScreenState();
// }
//
// class _SurveyResultsScreenState extends State<SurveyResultsScreen>
//     with TickerProviderStateMixin {
//   InterviewSurveyResult? _result;
//   bool _loading = true;
//   late AnimationController _pulseController;
//   late AnimationController _floatController;
//   int? _selectedBubble;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     _floatController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat(reverse: true);
//
//     _loadData();
//   }
//
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _floatController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadData() async {
//     try {
//       final result = await SupabaseService.fetchSurveyResults();
//       setState(() {
//         _result = result;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final t = context.watch<ThemeProvider>().theme;
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: t.bg0,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         foregroundColor: t.text,
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Candidate Feedback',
//                 style: TextStyle(color: t.text,
//                     fontWeight: FontWeight.w700, fontSize: 16)),
//             Text('Tap any bubble to highlight',
//                 style: TextStyle(color: t.textDim, fontSize: 11)),
//           ],
//         ),
//       ),
//       body: _loading
//           ? Center(child: CircularProgressIndicator(color: t.accent))
//           : _result == null
//           ? Center(child: Text('No data yet',
//           style: TextStyle(color: t.textDim)))
//           : Stack(
//         children: [
//           // Background glow
//           Positioned(
//             top: size.height * 0.1,
//             left: size.width * 0.2,
//             child: AnimatedBuilder(
//               animation: _pulseController,
//               builder: (_, __) => Container(
//                 width: 300,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       t.accent.withValues(
//                           alpha: 0.15 + _pulseController.value * 0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Center hero score
//           Positioned(
//             top: size.height * 0.18,
//             left: 0,
//             right: 0,
//             child: AnimatedBuilder(
//               animation: _pulseController,
//               builder: (_, __) => Column(
//                 children: [
//                   Text(
//                     _result!.avgOverallRating.toStringAsFixed(1),
//                     style: TextStyle(
//                       color: t.gold,
//                       fontSize: 96,
//                       fontWeight: FontWeight.w700,
//                       height: 1,
//                       shadows: [
//                         Shadow(
//                           color: t.gold.withValues(alpha:
//                           0.3 + _pulseController.value * 0.3),
//                           blurRadius: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text('out of 10',
//                       style: TextStyle(color: t.textDim,
//                           fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Text(
//                       '${_result!.respondentCount} candidates',
//                       style: TextStyle(color: t.accent,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ),
//
//           // Floating metric bubbles
//           ..._buildBubbles(t, size),
//
//           // Candidate voices bottom sheet trigger
//           Positioned(
//             bottom: 24,
//             left: 16,
//             right: 16,
//             child: GestureDetector(
//               onTap: () => _showVoices(context, t),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: t.surface,
//                   borderRadius: BorderRadius.circular(t.radius),
//                   border: Border.all(
//                       color: t.accent.withValues(alpha: 0.3)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('💬',
//                         style: TextStyle(fontSize: 18)),
//                     const SizedBox(width: 8),
//                     Text('Read candidate voices',
//                         style: TextStyle(color: t.accent,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600)),
//                     const SizedBox(width: 8),
//                     Icon(Icons.arrow_upward,
//                         color: t.accent, size: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildBubbles(RouyaTheme t, Size size) {
//     if (_result == null) return [];
//
//     final metrics = [
//       _Metric('🤝', 'Friendliness', _result!.avgFriendliness, 5, t.accent),
//       _Metric('😌', 'Comfort', _result!.avgFeel, 5, t.accent2),
//       _Metric('🎯', 'Relevance', _result!.avgRelevance, 5, t.accent),
//       _Metric('🗣️', 'Fair Opp.', _result!.avgFairOpportunity, 5, t.accent2),
//       _Metric('📋', 'Clarity', _result!.avgExplainedProcess, 5, t.gold),
//       _Metric('⚖️', 'Fairness', _result!.avgFairness, 5, t.accent),
//     ];
//
//     // Positions around the center score
//
//     final positions = [
//       Offset(-0.38, -0.42),  // top left
//       Offset(0.18, -0.48),   // top right
//       Offset(0.42, -0.05),   // right
//       Offset(0.18, 0.38),    // bottom right
//       Offset(-0.38, 0.35),   // bottom left
//       Offset(-0.52, -0.05),  // left
//     ];
//
//     return List.generate(metrics.length, (i) {
//       final m = metrics[i];
//       final pos = positions[i];
//       final isSelected = _selectedBubble == i;
//
//       return AnimatedBuilder(
//         animation: _floatController,
//         builder: (_, __) {
//           final floatOffset = math.sin(
//               _floatController.value * math.pi * 2 + i * 1.0) * 8;
//
//           return Positioned(
//             left: size.width * (0.1 + pos.dx * 0.8),
//             top: size.height * (0.08 + pos.dy * 0.6) + floatOffset,
//             child: GestureDetector(
//               onTap: () => setState(() =>
//               _selectedBubble = isSelected ? null : i),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width: isSelected ? 100 : 88,
//                 height: isSelected ? 100 : 88,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: m.color.withValues(alpha: 0.15),
//                   border: Border.all(
//                       color: m.color.withValues(alpha:
//                       isSelected ? 0.8 : 0.4),
//                       width: isSelected ? 2 : 1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: m.color.withValues(alpha:
//                       isSelected ? 0.3 : 0.1),
//                       blurRadius: isSelected ? 20 : 8,
//                       spreadRadius: isSelected ? 4 : 0,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(m.emoji,
//                         style: TextStyle(fontSize: 14)),
//                     const SizedBox(height: 2),
//                     Text(m.value.toStringAsFixed(1),
//                         style: TextStyle(
//                             color: m.color,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700)),
//                     Text(m.label,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: m.color.withValues(alpha: 0.8),
//                             fontSize: 8,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   void _showVoices(BuildContext context, RouyaTheme t) {
//     if (_result?.improvementSuggestions == null) return;
//
//     final suggestions = _result!.improvementSuggestions!
//         .split(' | ')
//         .where((s) => s.trim().isNotEmpty)
//         .toList();
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: t.bg2,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
//       builder: (ctx) => DraggableScrollableSheet(
//         initialChildSize: 0.6,
//         minChildSize: 0.3,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (_, controller) => Column(
//           children: [
//             const SizedBox(height: 12),
//             Container(
//               width: 40, height: 4,
//               decoration: BoxDecoration(
//                   color: Colors.white24,
//                   borderRadius: BorderRadius.circular(2)),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   Text('💬',
//                       style: TextStyle(fontSize: 20)),
//                   const SizedBox(width: 8),
//                   Text('Candidate Voices',
//                       style: TextStyle(color: t.text,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700)),
//                   const Spacer(),
//                   Text('${suggestions.length} responses',
//                       style: TextStyle(color: t.textDim,
//                           fontSize: 13)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.separated(
//                 controller: controller,
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//                 itemCount: suggestions.length,
//                 separatorBuilder: (_, __) =>
//                 const SizedBox(height: 10),
//                 itemBuilder: (_, i) => Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: t.surface,
//                     borderRadius: BorderRadius.circular(t.radius),
//                     border: Border.all(color: t.border),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 32, height: 32,
//                         decoration: BoxDecoration(
//                           color: t.accentTint,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Text('${i + 1}',
//                               style: TextStyle(color: t.accent,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w700)),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(suggestions[i].trim(),
//                             style: TextStyle(color: t.text,
//                                 fontSize: 14, height: 1.6,
//                                 fontStyle: FontStyle.italic)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _Metric {
//   final String emoji, label;
//   final double value, maxValue;
//   final Color color;
//
//   _Metric(this.emoji, this.label, this.value,
//       this.maxValue, this.color);
// }


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

class _SurveyResultsScreenState extends State<SurveyResultsScreen>
    with TickerProviderStateMixin {
  InterviewSurveyResult? _result;
  bool _loading = true;
  late AnimationController _pulseController;
  int? _selectedMetric;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
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

    return Scaffold(
      backgroundColor: t.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: t.text,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Candidate Feedback',
                style: TextStyle(color: t.text,
                    fontWeight: FontWeight.w700, fontSize: 16)),
            Text('Tap any metric for details',
                style: TextStyle(color: t.textDim, fontSize: 11)),
          ],
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: t.accent))
          : _result == null
          ? Center(child: Text('No data yet',
          style: TextStyle(color: t.textDim)))
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _buildHeroScore(t),
            const SizedBox(height: 28),
            _buildMetricsGrid(t),
            const SizedBox(height: 20),
            GestureDetector(
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
                    Text('💬', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('Read candidate voices',
                        style: TextStyle(color: t.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right,
                        color: t.accent, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroScore(RouyaTheme t) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(t.radius),
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  t.accent.withValues(
                      alpha: 0.12 + _pulseController.value * 0.06),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                Text(
                  _result!.avgOverallRating.toStringAsFixed(1),
                  style: TextStyle(
                    color: t.gold,
                    fontSize: 88,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    shadows: [
                      Shadow(
                        color: t.gold.withValues(alpha:
                        0.25 + _pulseController.value * 0.25),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                ),
                Text('out of 10',
                    style: TextStyle(color: t.textDim, fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                    '${_result!.respondentCount} candidates',
                    style: TextStyle(color: t.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(RouyaTheme t) {
    final metrics = [
      _Metric('🤝', 'Friendliness', _result!.avgFriendliness, t.accent),
      _Metric('😌', 'Comfort', _result!.avgFeel, t.accent2),
      _Metric('🎯', 'Relevance', _result!.avgRelevance, t.accent),
      _Metric('🗣️', 'Fair Opp.', _result!.avgFairOpportunity, t.accent2),
      _Metric('📋', 'Clarity', _result!.avgExplainedProcess, t.gold),
      _Metric('⚖️', 'Fairness', _result!.avgFairness, t.accent),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (_, i) {
        final m = metrics[i];
        final isSelected = _selectedMetric == i;
        return GestureDetector(
          onTap: () => setState(() =>
          _selectedMetric = isSelected ? null : i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: m.color.withValues(alpha: isSelected ? 0.16 : 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: m.color.withValues(
                      alpha: isSelected ? 0.7 : 0.25),
                  width: isSelected ? 1.5 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: m.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(m.emoji,
                          style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.value.toStringAsFixed(1),
                          style: TextStyle(
                              color: m.color,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      Text(m.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: m.color.withValues(alpha: 0.85),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  Text('💬', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Candidate Voices',
                      style: TextStyle(color: t.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${suggestions.length} responses',
                      style: TextStyle(color: t.textDim, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
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
  final double value;
  final Color color;

  _Metric(this.emoji, this.label, this.value, this.color);
}