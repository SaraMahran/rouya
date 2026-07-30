import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/teaching_model.dart';
import 'add_program_form.dart';
import 'add_student_form.dart';

class TeachingTab extends StatelessWidget {
  final RouyaTheme t;
  final AppStateProvider state;

  const TeachingTab({super.key, required this.t, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: t.accent,
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Programs',
                style: TextStyle(color: t.text, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            state.programs.isEmpty
                ? _EmptyState(t: t,
                emoji: '🎓',
                title: 'No programs yet',
                subtitle: 'Tap + to add a teaching program')
                : Column(
              children: state.programs.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProgramCard(t: t, program: p),
              )).toList(),
            ),
            const SizedBox(height: 24),
            Text('Individual Students',
                style: TextStyle(color: t.text, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            state.students.isEmpty
                ? _EmptyState(t: t,
                emoji: '👩‍🎓',
                title: 'No individual students yet',
                subtitle: 'Tap + to add a student')
                : Column(
              children: state.students.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StudentCard(t: t, student: s),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: t.bg2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      color: t.accentTint,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.groups_outlined, color: t.accent)),
              title: Text('Add Program',
                  style: TextStyle(color: t.text,
                      fontWeight: FontWeight.w600)),
              subtitle: Text('Teaching multiple students',
                  style: TextStyle(color: t.textDim, fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: t.bg2,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28))),
                  builder: (_) => AddProgramForm(t: t, state: state),
                );
              },
            ),
            ListTile(
              leading: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      color: t.accent2Tint,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.person_outline, color: t.accent2)),
              title: Text('Add Individual Student',
                  style: TextStyle(color: t.text,
                      fontWeight: FontWeight.w600)),
              subtitle: Text('One-on-one mentoring',
                  style: TextStyle(color: t.textDim, fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: t.bg2,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28))),
                  builder: (_) => AddStudentForm(t: t, state: state),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final RouyaTheme t;
  final String emoji, title, subtitle;

  const _EmptyState({
    required this.t, required this.emoji,
    required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(color: t.border),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(color: t.text, fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(color: t.textDim, fontSize: 13)),
        ],
      ),
    );
  }
}

class ProgramCard extends StatelessWidget {
  final RouyaTheme t;
  final TeachingProgram program;

  const ProgramCard({super.key, required this.t, required this.program});

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
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                    color: t.accentTint,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.groups_outlined,
                    color: t.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program.name,
                        style: TextStyle(color: t.text, fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    if (program.organization != null)
                      Text(program.organization!,
                          style: TextStyle(
                              color: t.textDim, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: program.status == 'Active'
                      ? t.accentTint : t.surface,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: t.border),
                ),
                child: Text(program.status,
                    style: TextStyle(
                        color: program.status == 'Active'
                            ? t.accent : t.textDim,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.people_outline,
                  color: t.textFaint, size: 14),
              const SizedBox(width: 4),
              Text('${program.studentCount} students',
                  style: TextStyle(color: t.textDim, fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today_outlined,
                  color: t.textFaint, size: 14),
              const SizedBox(width: 4),
              Text(
                  '${program.startDate.month}/${program.startDate.year}',
                  style: TextStyle(color: t.textDim, fontSize: 12)),
            ],
          ),
          if (program.topics.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: program.topics.take(3).map((topic) =>
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: t.accent2Tint,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(topic,
                        style: TextStyle(
                            color: t.accent2, fontSize: 11)),
                  )
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final RouyaTheme t;
  final IndividualStudent student;

  const StudentCard({
    super.key, required this.t, required this.student,
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
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: t.accent2Tint,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                  student.name.isNotEmpty
                      ? student.name[0].toUpperCase() : '?',
                  style: TextStyle(color: t.accent2, fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: TextStyle(color: t.text, fontSize: 15,
                        fontWeight: FontWeight.w600)),
                if (student.subject != null)
                  Text(student.subject!,
                      style: TextStyle(
                          color: t.textDim, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${student.sessions.length} sessions',
                  style: TextStyle(color: t.textDim, fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (i) => Icon(
                    i < student.progressRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: t.gold, size: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}