import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/app_state_provider.dart';
import './screens/main_shell.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.load();
  final appState = AppStateProvider();
  await appState.init();


  // Inside main() before runApp:
  await Supabase.initialize(
    url: SupabaseService.supabaseUrl,
    anonKey: SupabaseService.supabaseKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<AppStateProvider>.value(value:appState),
      ],
      child: const RouyaApp(),
    ),
  );
}

class RouyaApp extends StatelessWidget {
  const RouyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;

    return MaterialApp(
      title: 'Rouya',
      debugShowCheckedModeBanner: false,
      theme: t.materialTheme,
      home: const MainShell(),
    );
  }
}