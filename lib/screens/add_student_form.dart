import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/teaching_model.dart';

class AddStudentForm extends StatefulWidget {
  final RouyaTheme t;
  final AppStateProvider state;

  const AddStudentForm({super.key, required this.t, required this.state});

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _name = TextEditingController();
  final _subject = TextEditingController();
  final _notes = TextEditingController();
  int _progress = 3;

  RouyaTheme get t => widget.t;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24,
          MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Student',
                style: TextStyle(color: t.text, fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),

            _label('Student Name'),
            _field(_name, 'e.g. Ahmed Hassan'),
            const SizedBox(height: 14),

            _label('Subject / Topic'),
            _field(_subject, 'e.g. Python, Primavera P6'),
            const SizedBox(height: 14),

            _label('Notes'),
            TextField(
              controller: _notes,
              maxLines: 3,
              style: TextStyle(color: t.text),
              decoration: InputDecoration(
                hintText: 'Student background, goals...',
                hintStyle: TextStyle(color: t.textFaint),
                filled: true,
                fillColor: t.surface,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: t.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: t.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: t.accent)),
              ),
            ),
            const SizedBox(height: 14),

            _label('Initial Progress Rating'),
            Row(
              children: List.generate(5, (i) =>
                  GestureDetector(
                    onTap: () => setState(() => _progress = i + 1),
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                            i < _progress
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: t.gold, size: 32)),
                  )
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_name.text.trim().isEmpty) return;
                  widget.state.addStudent(IndividualStudent(
                    id: 's${DateTime.now().millisecondsSinceEpoch}',
                    name: _name.text.trim(),
                    subject: _subject.text.trim().isEmpty
                        ? null : _subject.text.trim(),
                    startDate: DateTime.now(),
                    notes: _notes.text.trim().isEmpty
                        ? null : _notes.text.trim(),
                    progressRating: _progress,
                  ));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Student',
                    style: TextStyle(color: Colors.white,
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text,
        style: TextStyle(color: t.textDim, fontSize: 13)),
  );

  Widget _field(TextEditingController ctrl, String hint) => TextField(
    controller: ctrl,
    style: TextStyle(color: t.text),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: t.textFaint),
      filled: true,
      fillColor: t.surface,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: t.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: t.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: t.accent)),
    ),
  );
}