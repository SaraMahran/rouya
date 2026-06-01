import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rouya/theme/rouya_themes.dart';
import '../providers/theme_provider.dart';
import '../providers/app_state_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final picked = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 80,
  //     maxWidth: 512,
  //     maxHeight: 512,
  //   );
  //   if (picked != null && mounted) {
  //     context.read<AppStateProvider>().updateProfileImage(picked.path);
  //   }
  // }
  //
  // Future<void> _pickImage() async {
  //   final source = await showModalBottomSheet<ImageSource>(
  //     context: context,
  //     builder: (_) => Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         ListTile(
  //           leading: const Icon(Icons.photo_library),
  //           title: const Text('Gallery'),
  //           onTap: () => Navigator.pop(context, ImageSource.gallery),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt),
  //           title: const Text('Camera'),
  //           onTap: () => Navigator.pop(context, ImageSource.camera),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (source == null) return;
  //   final picked = await _picker.pickImage(
  //     source: source,
  //     imageQuality: 80,
  //     maxWidth: 512,
  //     maxHeight: 512,
  //   );
  //   if (picked != null && mounted) {
  //     context.read<AppStateProvider>().updateProfileImage(picked.path);
  //   }
  // }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1A0A2E),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Choose from Gallery',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Take a Photo',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source == null || !mounted) return;

    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (picked != null && mounted) {
        context.read<AppStateProvider>().updateProfileImage(picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final themeProvider = context.watch<ThemeProvider>();
    final state = context.watch<AppStateProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings',
                style: TextStyle(color: t.textDim, fontSize: 12)),
            Text('Preferences',
                style: TextStyle(color: t.text, fontSize: 28,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),

            // Profile section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(t.radius),
                border: Border.all(color: t.border),
              ),
              child: Row(
                children: [
                  // Tappable avatar
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [t.accent, t.accent2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: state.profileImagePath != null
                              ? ClipOval(
                            child: Image.file(
                              File(state.profileImagePath!),
                              width: 64, height: 64,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Center(
                            child: Text('S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        // Camera badge
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              color: t.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: t.bg1, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sara',
                            style: TextStyle(color: t.text, fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        Text('Planning Engineer · Builder',
                            style: TextStyle(color: t.textDim, fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: t.accentTint,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text('✨ Rouya رؤيا',
                              style: TextStyle(color: t.accent,
                                  fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Appearance
            Text('APPEARANCE',
                style: TextStyle(color: t.textFaint, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Container(
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
                      color: t.accentTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.palette_outlined,
                        color: t.accent, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme',
                            style: TextStyle(color: t.text, fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Text(themeProvider.isFeminine
                            ? 'Feminine Power' : 'Obsidian',
                            style: TextStyle(color: t.textDim, fontSize: 13)),
                      ],
                    ),
                  ),
                  Switch(
                    value: themeProvider.isFeminine,
                    onChanged: (_) => themeProvider.toggle(),
                    activeTrackColor: t.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _ThemePreview(
                  label: '✨ Feminine',
                  bg: RouyaColors.femBg1,
                  accent: RouyaColors.femAccent,
                  isSelected: themeProvider.isFeminine,
                  onTap: () {
                    if (!themeProvider.isFeminine) themeProvider.toggle();
                  },
                )),
                const SizedBox(width: 12),
                Expanded(child: _ThemePreview(
                  label: '🌑 Obsidian',
                  bg: RouyaColors.obsBg1,
                  accent: RouyaColors.obsAccent,
                  isSelected: !themeProvider.isFeminine,
                  onTap: () {
                    if (themeProvider.isFeminine) themeProvider.toggle();
                  },
                )),
              ],
            ),
            const SizedBox(height: 28),

            // About
            Text('ABOUT',
                style: TextStyle(color: t.textFaint, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Container(
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
                      color: t.accentTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.info_outline,
                        color: t.accent, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rouya رؤيا',
                            style: TextStyle(color: t.text, fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Text('Version 1.0.0 · Personal achievement tracker',
                            style: TextStyle(color: t.textDim, fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: t.textFaint, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  final String label;
  final Color bg, accent;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePreview({
    required this.label, required this.bg,
    required this.accent, required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? accent : Colors.transparent,
              width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40, height: 6,
              decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(color: accent, fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}