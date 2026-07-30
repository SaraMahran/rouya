import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/interview_model.dart';

class LogInterviewForm extends StatefulWidget {
  final RouyaTheme t;
  final AppStateProvider state;

  const LogInterviewForm({super.key, required this.t, required this.state});

  @override
  State<LogInterviewForm> createState() => _LogInterviewFormState();
}

class _LogInterviewFormState extends State<LogInterviewForm> {
  final _company = TextEditingController();
  final _role = TextEditingController();
  final _purpose = TextEditingController();
  final _notes = TextEditingController();
  String _type = 'Technical';
  String _outcome = 'Pending';
  int _rating = 0;
  DateTime _date = DateTime.now();

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
            Text('Log Interview',
                style: TextStyle(color: t.text, fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),

            _label('Company'),
            _field(_company, 'e.g. Google, Vercel, Linear'),
            const SizedBox(height: 14),

            _label('Role / Position'),
            _field(_role, 'e.g. Senior Backend Engineer'),
            const SizedBox(height: 14),

            _label('Interview Type'),
            Row(
              children: ['Technical', 'HR', 'Culture'].map((type) =>
                  GestureDetector(
                    onTap: () => setState(() => _type = type),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          color: _type == type ? t.accent : t.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: _type == type ? t.accent : t.border)),
                      child: Text(type,
                          style: TextStyle(
                              color: _type == type
                                  ? Colors.white : t.textDim,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  )
              ).toList(),
            ),
            const SizedBox(height: 14),

            _label('Date'),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (ctx, child) => Theme(
                      data: ThemeData.dark(), child: child!),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: t.textDim, size: 16),
                    const SizedBox(width: 10),
                    Text(
                        '${_date.day}/${_date.month}/${_date.year}',
                        style: TextStyle(color: t.text, fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            _label('Outcome'),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: ['Pending', 'Advanced', 'Passed',
                'Failed', 'Rejected'].map((o) =>
                  GestureDetector(
                    onTap: () => setState(() => _outcome = o),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          color: _outcome == o ? t.accent : t.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: _outcome == o ? t.accent : t.border)),
                      child: Text(o,
                          style: TextStyle(
                              color: _outcome == o
                                  ? Colors.white : t.textDim,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  )
              ).toList(),
            ),
            const SizedBox(height: 14),

            _label('Purpose'),
            _field(_purpose,
                'e.g. System design round, recruiter screen...'),
            const SizedBox(height: 14),

            _label('Notes'),
            TextField(
              controller: _notes,
              maxLines: 3,
              style: TextStyle(color: t.text),
              decoration: InputDecoration(
                hintText: 'How did it go? What to improve?',
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

            _label('Self Rating'),
            Row(
              children: List.generate(5, (i) =>
                  GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                            i < _rating
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
                  if (_company.text.trim().isEmpty) return;
                  widget.state.addInterviewRecord(InterviewRecord(
                    id: 'i${DateTime.now().millisecondsSinceEpoch}',
                    company: _company.text.trim(),
                    role: _role.text.trim(),
                    type: _type,
                    date: _date,
                    purpose: _purpose.text.trim().isEmpty
                        ? null : _purpose.text.trim(),
                    notes: _notes.text.trim().isEmpty
                        ? null : _notes.text.trim(),
                    outcome: _outcome,
                    rating: _rating == 0 ? null : _rating,
                  ));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Interview',
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