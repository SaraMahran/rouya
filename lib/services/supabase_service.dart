import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://qyrspoaaqmlrerssfpcc.supabase.co';
  static const String supabaseKey = 'sb_publishable_hHWClasAXgvb_phnVdbBbg_ekezvzIJ';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<InterviewSurveyResult?> fetchSurveyResults() async {
    try {
      final response = await client
          .from('interview_surveys')
          .select()
          .eq('session_label', 'Planning Engineer Interviews')
          .single();

      return InterviewSurveyResult.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}

class InterviewSurveyResult {
  final int respondentCount;
  final double avgFriendliness;
  final double avgFeel;
  final double avgRelevance;
  final double avgFairOpportunity;
  final double avgExplainedProcess;
  final double avgFairness;
  final double avgOverallRating;
  final String? improvementSuggestions;

  InterviewSurveyResult({
    required this.respondentCount,
    required this.avgFriendliness,
    required this.avgFeel,
    required this.avgRelevance,
    required this.avgFairOpportunity,
    required this.avgExplainedProcess,
    required this.avgFairness,
    required this.avgOverallRating,
    this.improvementSuggestions,
  });

  factory InterviewSurveyResult.fromJson(Map<String, dynamic> json) {
    return InterviewSurveyResult(
      respondentCount: json['respondent_count'] ?? 0,
      avgFriendliness: (json['avg_friendliness_professionalism'] ?? 0).toDouble(),
      avgFeel: (json['avg_feel'] ?? 0).toDouble(),
      avgRelevance: (json['avg_relevance'] ?? 0).toDouble(),
      avgFairOpportunity: (json['avg_fair_opportunity'] ?? 0).toDouble(),
      avgExplainedProcess: (json['avg_explained_process'] ?? 0).toDouble(),
      avgFairness: (json['avg_fairness'] ?? 0).toDouble(),
      avgOverallRating: (json['avg_overall_rating'] ?? 0).toDouble(),
      improvementSuggestions: json['improvement_suggestions'],
    );
  }
}