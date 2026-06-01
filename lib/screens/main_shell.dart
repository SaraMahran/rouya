import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/rouya_themes.dart';
import 'dashboard_screen.dart';
import 'achievements_screen.dart';
import 'interviews_screen.dart';
import 'quotes_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final screens = [
      const DashboardScreen(),
      const AchievementsScreen(),
      const InterviewsScreen(),
      const QuotesScreen(),
      const SettingsScreen(),
    ];
    return Scaffold(
      backgroundColor: t.bg0,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: t.bgGradient),
        child: screens[_index],
      ),
      bottomNavigationBar: _BottomNav(
        t: t,
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final RouyaTheme t;
  final int index;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.t,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined,         'activeIcon': Icons.home_rounded,         'label': 'Home'},
      {'icon': Icons.star_outline_rounded,  'activeIcon': Icons.star_rounded,         'label': 'Goals'},
      {'icon': Icons.work_outline_rounded,  'activeIcon': Icons.work_rounded,         'label': 'Interviews'},
      {'icon': Icons.format_quote_outlined, 'activeIcon': Icons.format_quote_rounded, 'label': 'Quotes'},
      {'icon': Icons.settings_outlined,     'activeIcon': Icons.settings_rounded,     'label': 'Settings'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: t.navBg,
        border: Border(top: BorderSide(color: t.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        active
                            ? items[i]['activeIcon'] as IconData
                            : items[i]['icon'] as IconData,
                        color: active ? t.accent : t.textFaint,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i]['label'] as String,
                        style: TextStyle(
                          color: active ? t.accent : t.textFaint,
                          fontSize: 10,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}