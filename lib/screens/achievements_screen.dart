import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rouya/models/category_model.dart';
import 'package:rouya/providers/app_state_provider.dart';
import 'package:rouya/theme/rouya_themes.dart';
import '../providers/theme_provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final state = context.watch<AppStateProvider>();
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddSheet(context, state, t),
          backgroundColor: t.accent,
          child: const Icon(Icons.add, color: Colors.white),
        ),

      body: SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tracking',
                        style: TextStyle(
                          color: t.textDim,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Achievements',
                        style: TextStyle(
                          color: t.text,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  //Total badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: t.accentTint,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: t.border),
                    ),
                    child: Text(
                      '${state.totalAchievements} total',
                      style: TextStyle(
                        color: t.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //Categories list
            Expanded(
              child: state.categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🌟', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'No categories yet',
                            style: TextStyle(
                              color: t.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap + to create your first one',
                            style: TextStyle(color: t.textDim, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final cat = state.categories[i];
                        return _CategoryCard(
                          t: t,
                          cat: cat,
                          onIncrement: () => state.increment(cat.id),
                          onDecrement: () => state.decrement(cat.id),
                          onDelete: () => _confirmDelete(
                            context,
                            state,
                            cat.id,
                            cat.name,
                            t,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AppStateProvider state,
    String id,
    String name,
    RouyaTheme t,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: t.bg2,
        title: Text('Delete "$name"?', style: TextStyle(color: t.text)),
        content: Text(
          'This will remove all entries too.',
          style: TextStyle(color: t.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: t.textDim)),
          ),
          TextButton(
            onPressed: () {
              state.deleteCategory(id);
              Navigator.pop(context);
            },

            child: Text('Delete', style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }
  void _showAddSheet(BuildContext context, AppStateProvider state, RouyaTheme t) {
    String name = '';
    String emoji = '🎯';
    final controller = TextEditingController();
    final emojis = ['🎯','💼','📚','🎤','🏋️','💻','🎨','✈️','🏆','🌱',
      '💡','🧠','🎓','🚀','❤️','🌸','⚡','🔥','💎','🌟'];

    showModalBottomSheet(
      context: context,
      backgroundColor: t.bg2,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24,
              MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Category',
                  style: TextStyle(color: t.text, fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),

              Text('Pick an emoji',
                  style: TextStyle(color: t.textDim, fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: emojis.map((e) => GestureDetector(
                  onTap: () => setState(() => emoji = e),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: emoji == e ? t.accentTint : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: emoji == e ? t.accent : t.border),
                    ),
                    child: Center(child: Text(e,
                        style: const TextStyle(fontSize: 22))),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),

              Text('Category name',
                  style: TextStyle(color: t.textDim, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                onChanged: (v) => name = v,
                style: TextStyle(color: t.text),
                decoration: InputDecoration(
                  hintText: 'e.g. Books Read, Tech Interviews...',
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
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (name.trim().isNotEmpty) {
                      state.addCategory(name.trim(), emoji);
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Create Category',
                      style: TextStyle(color: Colors.white, fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final RouyaTheme t;
  final CategoryModel cat;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.t,
    required this.cat,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
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
          //Emoji
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: t.accentTint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(cat.emoji, style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          //Name + count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: TextStyle(
                    color: t.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${cat.count} recorded',
                  style: TextStyle(color: t.textDim, fontSize: 13),
                ),
              ],
            ),
          ),



          // - button
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: t.accent2Tint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.border),
              ),
              child: Icon(Icons.remove, color: t.accent2, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          // + button
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: t.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),

          //Delete button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade300,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
