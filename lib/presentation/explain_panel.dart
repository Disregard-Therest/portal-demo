import 'package:flutter/material.dart';

import '../data/demo_steps.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';

/// Панель пояснений. На каждом шаге одна и та же форма:
/// Что это · Зачем · Почему так, а не иначе · Обсудить.
///
/// Форма постоянная намеренно: на созвоне не приходится каждый раз искать,
/// где ответ на вопрос.
class ExplainPanel extends StatelessWidget {
  const ExplainPanel({super.key, required this.step, required this.stepIndex});

  final DemoStep step;
  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final color = stageColor(step.stage);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ШАГ ${stepIndex + 1} ИЗ ${demoSteps.length}',
              style: AppText.eyebrow.copyWith(fontSize: 10.5, color: AppColors.muted),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
              child: Text(
                'ЭТАП ${step.stage.index + 1}',
                style: AppText.eyebrow.copyWith(fontSize: 9.5, color: color),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(step.title, style: AppText.display.copyWith(fontSize: 23)),
        const SizedBox(height: 16),
        _block(
          label: 'Что это',
          child: Text(step.whatIs, style: AppText.body.copyWith(fontSize: 14, height: 1.5)),
        ),
        _block(label: 'Зачем', child: _bullets(step.why, marker: '◆', markerColor: color)),
        _block(
          label: 'Почему так, а не иначе',
          child: _bullets(step.whyThisWay, marker: '—', markerColor: AppColors.muted),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(15, 13, 15, 7),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: color.withValues(alpha: 0.35)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ОБСУДИТЬ', style: AppText.eyebrow.copyWith(color: color)),
              const SizedBox(height: 9),
              // Первый вопрос — главный на этом шаге, поэтому он заметнее остальных.
              _bullets(step.discuss, marker: '?', markerColor: color, emphasizeFirst: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _block({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppText.eyebrow.copyWith(color: AppColors.muted)),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }

  Widget _bullets(List<String> items, {required String marker, required Color markerColor, bool emphasizeFirst = false}) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 17,
                  child: Text(
                    marker,
                    style: TextStyle(color: markerColor, fontSize: 12, height: 1.6, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: Text(
                    items[i],
                    style: AppText.body.copyWith(
                      fontSize: 13,
                      height: 1.5,
                      color: emphasizeFirst && i == 0 ? AppColors.ink : AppColors.ink2,
                      fontWeight: emphasizeFirst && i == 0 ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Color stageColor(Stage stage) => switch (stage) {
      Stage.entry => AppColors.stage1,
      Stage.daily => AppColors.stage2,
      Stage.money => AppColors.stage3,
    };
