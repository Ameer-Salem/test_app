import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsController>(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 5),
      children: [
        ListTile(
          title: Text('Theme Mode'),
          trailing: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: SegmentedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ), // adjust size
                ),
              ),
              segments: [
                ButtonSegment(
                  value: ThemeModeOption.light,
                  icon: Icon(Icons.light_mode_rounded),
                ),
                ButtonSegment(
                  value: ThemeModeOption.system,
                  icon: Icon(Icons.contrast_rounded),
                ),
                ButtonSegment(
                  value: ThemeModeOption.dark,
                  icon: Icon(Icons.dark_mode_rounded),
                ),
              ],
              selected: <ThemeModeOption>{provider.selected},
              onSelectionChanged: (newSelection) {
                // provider.updateTheme(newSelection.first);
                provider.updateTheme(newSelection.first);
                switch (newSelection.first) {
                  case ThemeModeOption.light:
                    AdaptiveTheme.of(context).setLight();
                    break;
                  case ThemeModeOption.dark:
                    AdaptiveTheme.of(context).setDark();
                    break;
                  case ThemeModeOption.system:
                    AdaptiveTheme.of(context).setSystem();
                    break;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
