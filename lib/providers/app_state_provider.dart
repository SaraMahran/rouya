import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';
import '../models/interview_model.dart';
import '../models/quote_model.dart';
import '../models/teaching_model.dart';

class AppStateProvider extends ChangeNotifier {
  List<CategoryModel> categories = [];
  InterviewModel interviews = InterviewModel();
  List<QuoteModel> quotes = [];
  int dailyQuoteIndex = 1;
  String? profileImagePath;
  List<TeachingProgram> programs = [];
  List<IndividualStudent> students = [];


  //Load seed data on first launch
  Future<void> init() async{
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('categories');
    profileImagePath = prefs.getString('profileImagePath');
    if (saved != null) {
      // Load from storage later
    }
    else {
      // Seed data matching the prototype
      categories = [
        CategoryModel(id: 'c1', name: 'Books finished', emoji: '📚', count: 865, color: 'accent'),
        CategoryModel(id: 'c2', name: 'Students mentored', emoji: '🎓', count: 130, color: 'accent2'),
        CategoryModel(id: 'c3', name: 'Projects shipped', emoji: '🚀', count: 12, color: 'gold'),
        CategoryModel(id: 'c4', name: 'Courses completed', emoji: '🏆', count: 5, color: 'accent'),
        CategoryModel(id: 'c5', name: 'Technical docs written', emoji: '✍️', count: 17, color: 'accent2'),
        CategoryModel(id: 'c5', name: 'Arts Classes Attended', emoji: '🎨', count: 7, color: 'accent2'),
      ];
      interviews = InterviewModel(
        technical: 8,
        hr: 26,
        streak: 12,
        chart: [1, 0, 2, 1, 1, 0, 1, 2, 1, 1, 1, 2, 1, 1],
        history: [
          InterviewRecord(
            id: 'i1',
            company: 'Vercel',
            role: 'Senior Frontend Engineer',
            type: 'Technical',
            date: DateTime(2026, 5, 14),
            meetingTime: '10:00 AM',
            purpose: 'System design round',
            outcome: 'Advanced',
            rating: 4,
          ),
          InterviewRecord(
            id: 'i2',
            company: 'Linear',
            role: 'Product Engineer',
            type: 'HR',
            date: DateTime(2026, 5, 13),
            meetingTime: '2:00 PM',
            purpose: 'Recruiter screen',
            outcome: 'Advanced',
            rating: 5,
          ),
          InterviewRecord(
            id: 'i3',
            company: 'Figma',
            role: 'Frontend Developer',
            type: 'Technical',
            date: DateTime(2026, 5, 12),
            meetingTime: '11:30 AM',
            purpose: 'Live coding round',
            outcome: 'Pending',
            rating: 3,
          ),
        ],
      );

      programs = [
        TeachingProgram(
          id: 'p1',
          name: 'Planning Engineer Bootcamp',
          organization: 'PESoftware',
          startDate: DateTime(2026, 3, 1),
          studentCount: 24,
          topics: ['Primavera P6', 'Project Scheduling', 'Resource Planning'],
          status: 'Active',
        ),
      ];
      quotes = [
        QuoteModel(id: 'q1', text: 'The privilege of a lifetime is to become who you truly are.', author: 'Carl Jung', book: 'Memories, Dreams, Reflections', category: 'Becoming', favorite: true),
        QuoteModel(id: 'q2', text: 'She had not known the weight until she felt the freedom.', author: 'Toni Morrison', book: 'Beloved', category: 'Freedom', favorite: true),
        QuoteModel(id: 'q3', text: 'Discipline equals freedom.', author: 'Jocko Willink', book: 'Discipline Equals Freedom', category: 'Discipline'),
        QuoteModel(id: 'q4', text: 'You do not rise to the level of your goals. You fall to the level of your systems.', author: 'James Clear', book: 'Atomic Habits', category: 'Systems', favorite: true),
        QuoteModel(id: 'q5', text: 'The cave you fear to enter holds the treasure you seek.', author: 'Joseph Campbell', category: 'Courage'),
        QuoteModel(id: 'q6', text: 'What you seek is seeking you.', author: 'Rumi', category: 'Becoming', favorite: true),
        QuoteModel(id: 'q7', text: 'Between stimulus and response there is a space. In that space is our power to choose.', author: 'Viktor Frankl', book: 'Man\'s Search for Meaning', category: 'Mind'),
        QuoteModel(id: 'q8', text: 'You are allowed to be both a masterpiece and a work in progress, simultaneously.', author: 'Sophia Bush', category: 'Becoming', favorite: true),
      ];
    }
    notifyListeners();
  }

  //Increment a category count
  void increment(String id) {
    final cat = categories.firstWhere((c) => c.id == id);
    cat.count++;
    cat.entries.add(CategoryEntry(
      date: _today(),
      note: '',
    ));
    notifyListeners();
  }

  void decrement(String id) {
    final cat = categories.firstWhere((c) => c.id == id);
    if (cat.count > 0) cat.count--;
    notifyListeners();
  }

  //Add a new category
  void addCategory(String name, String emoji){
    categories.insert(0, CategoryModel(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emoji: emoji,
    ));
    notifyListeners();
  }

  //Delete a category
  void deleteCategory(String id){
    categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  //Toggle quote favorite
  void toggleFav(String id){
    final q = quotes.firstWhere((q) => q.id==id);
    q.favorite = !q.favorite;
    notifyListeners();
  }

  //Log an interview
  // void logInterview(String kind){
  //   if (kind == 'technical'){
  //     interviews.technical++;
  //   }
  //   else {
  //     interviews.hr++;
  //   }
  //   final chart = [...interviews.chart];
  //   chart[chart.length - 1] = chart.last + 1;
  //   interviews.chart = chart;
  //   notifyListeners();
  // }
  void addInterviewRecord(InterviewRecord record) {
    if (record.type == 'Technical') {
      interviews.technical++;
    } else {
      interviews.hr++;
    }
    interviews.history.insert(0, record);
    final chart = [...interviews.chart];
    chart[chart.length - 1] = chart.last + 1;
    interviews.chart = chart;
    notifyListeners();
  }

  void updateInterviewRecord(InterviewRecord record) {
    final index = interviews.history
        .indexWhere((r) => r.id == record.id);
    if (index != -1) {
      interviews.history[index] = record;
      notifyListeners();
    }
  }

  void deleteInterviewRecord(String id) {
    interviews.history.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void deleteProgram(String id) {
    programs.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void deleteStudent(String id) {
    students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void addProgram(TeachingProgram program) {
    programs.insert(0, program);
    notifyListeners();
  }

  void addStudent(IndividualStudent student) {
    students.insert(0, student);
    notifyListeners();
  }

  void updateProgram(TeachingProgram program) {
    final index = programs.indexWhere((p) => p.id == program.id);
    if (index != -1) {
      programs[index] = program;
      notifyListeners();
    }
  }

  void updateStudent(IndividualStudent student) {
    final index = students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      students[index] = student;
      notifyListeners();
    }
  }

  //Total achievement count
  int get totalAchievements =>
      categories.fold(0, (sum, c) => sum + c.count);

  String _today(){
    final now = DateTime.now();
    return '${_monthName(now.month)} ${now.day}';
  }

  String _monthName(int mon) => [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][mon];


  Future<void> updateProfileImage(String path) async {
    profileImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);
    notifyListeners();
  }
}



