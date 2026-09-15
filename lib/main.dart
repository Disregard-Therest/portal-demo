import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'presentation/presentation_shell.dart';
import 'theme/app_theme.dart';

void main() {
  // Диплинк на шаг презентации: ?step=7 (нумерация с единицы).
  final step = int.tryParse(Uri.base.queryParameters['step'] ?? '');
  if (step != null) AppState.instance.goToStep(step - 1);

  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Портал · прототип',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const PresentationShell(),
    );
  }
}
