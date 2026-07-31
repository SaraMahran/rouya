import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/teaching_model.dart';

class AddProgramForm extends StatefulWidget {
  final RouyaTheme t;
  final AppStateProvider state;
  final TeachingProgram? existingProgram;

  const AddProgramForm({
    super.key,
    required this.t,
    required this.state,
    this.existingProgram,
  });

  @override
  State<AddProgramForm> createState() => _AddProgramFormState();
}

class _AddProgramFormState extends State<AddProgramForm> {
  late final TextEditingController _name;
  late final TextEditingController _org;
  late final TextEditingController _topicsCtrl;
  late int _studentCount;
  late DateTime _startDate;
  late String _status;

  bool get isEditing => widget.existingProgram != null;
  RouyaTheme get t => widget.t;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProgram;
    _name = TextEditingController(text: p?.name ?? '');
    _org = TextEditingController(text: p?.organization ?? '');
    _topicsCtrl = TextEditingController(
        text: p?.topics.join(', ') ?? '');
    _studentCount = p?.studentCount ?? 0;
    _startDate = p?.startDate ?? DateTime.now();
    _status = p?.status ?? 'Active';
  }

  @override
  void dispose() {
    _name.dispose();
    _org.dispose();
    _topicsCtrl.dispose();
    super.dispose();
  }

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
            Row(
              children: [
                Text(isEditing ? 'Edit Program' : 'New Program',
                    style: TextStyle(color: t.text, fontSize: 22,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                if (isEditing)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: t.accentTint,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text('Editing',
                        style: TextStyle(color: t.accent,
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            _label('Program Name'),
            _field(_name, 'e.g. Planning Engineer Bootcamp'),
            const SizedBox(height: 14),

            _label('Organization'),
            _field(_org, 'e.g. iSchool, Udacity, PESoftware'),
            const SizedBox(height: 14),

            _label('Number of Students'),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    if (_studentCount > 0) _studentCount--;
                  }),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        color: t.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: t.border)),
                    child: Icon(Icons.remove,
                        color: t.textDim, size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Text('$_studentCount',
                    style: TextStyle(color: t.text, fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _studentCount++),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        color: t.accent,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _label('Topics (comma separated)'),
            _field(_topicsCtrl,
                'e.g. Primavera P6, Project Scheduling'),
            const SizedBox(height: 14),

            _label('Status'),
            Row(
              children: ['Active', 'Upcoming', 'Completed'].map((s) =>
                  GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          color: _status == s ? t.accent : t.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: _status == s ? t.accent : t.border)),
                      child: Text(s,
                          style: TextStyle(
                              color: _status == s
                                  ? Colors.white : t.textDim,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  )
              ).toList(),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_name.text.trim().isEmpty) return;
                  final topics = _topicsCtrl.text.trim().isEmpty
                      ? <String>[]
                      : _topicsCtrl.text.split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  final program = TeachingProgram(
                    id: isEditing
                        ? widget.existingProgram!.id
                        : 'p${DateTime.now().millisecondsSinceEpoch}',
                    name: _name.text.trim(),
                    organization: _org.text.trim().isEmpty
                        ? null : _org.text.trim(),
                    startDate: _startDate,
                    studentCount: _studentCount,
                    topics: topics,
                    status: _status,
                  );

                  if (isEditing) {
                    widget.state.updateProgram(program);
                  } else {
                    widget.state.addProgram(program);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                    isEditing ? 'Save Changes' : 'Save Program',
                    style: const TextStyle(color: Colors.white,
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