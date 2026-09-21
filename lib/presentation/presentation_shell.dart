import 'package:flutter/material.dart';

import '../build_info.dart';
import '../data/app_state.dart';
import '../data/demo_steps.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';
import 'explain_panel.dart';
import 'phone_frame.dart';

/// Admin и next — не телефон, а панель во всю ширину области.
bool _isPanelScreen(Screen screen) => screen == Screen.admin || screen == Screen.next;

class PresentationShell extends StatelessWidget {
  const PresentationShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Номер шага передаётся параметром, а не читается внутри: const-виджет
    // Flutter не перестраивает, и шаги с панелью застывали на первом экране,
    // пока телефон, слушающий состояние сам, уже показывал следующий.
    return Scaffold(
      backgroundColor: AppColors.page,
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) => LayoutBuilder(
          builder: (context, c) {
            final stepIndex = AppState.instance.stepIndex;
            return c.maxWidth >= 1000 && c.maxHeight >= 620
                ? _Wide(stepIndex: stepIndex)
                : _Narrow(stepIndex: stepIndex);
          },
        ),
      ),
    );
  }
}

// ── Широкий экран: шаги сверху, телефон слева, пояснения справа ─────────────

class _Wide extends StatelessWidget {
  const _Wide({required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            const _Header(),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 6, 120, 6),
              child: Column(
                children: [
                  _StageRow(stage: Stage.entry, stepIndex: stepIndex),
                  const SizedBox(height: 7),
                  _StageRow(stage: Stage.product, stepIndex: stepIndex),
                  const SizedBox(height: 7),
                  _StageRow(stage: Stage.ops, stepIndex: stepIndex),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 12, 32, 20),
                      child: _isPanelScreen(demoSteps[stepIndex].screen)
                          ? const PanelFrame()
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox.fromSize(size: phoneSize, child: const PhoneFrame()),
                            ),
                    ),
                  ),
                  Container(
                    width: 540,
                    padding: const EdgeInsets.fromLTRB(0, 12, 32, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            key: ValueKey('panel-$stepIndex'),
                            child: ExplainPanel(step: demoSteps[stepIndex], stepIndex: stepIndex),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _NavButtons(stepIndex: stepIndex),
                        const SizedBox(height: 6),
                        Text('сборка $buildStamp', textAlign: TextAlign.center, style: AppText.muted.copyWith(fontSize: 10.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 18, 32, 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(color: AppColors.night, shape: BoxShape.circle),
            child: const Center(child: Orb(size: 30, animate: false)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('«Портал» — состав первой версии продукта', style: AppText.display.copyWith(fontSize: 17)),
                Text(
                  'интерактивный прототип · переключайте шаги сверху или нажимайте прямо в телефоне',
                  style: AppText.muted.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text('названия, тексты и цены — гипотезы для обсуждения', style: AppText.muted.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

/// Ряд шагов одного этапа. Цвет кодирует этап, поэтому рядом всегда подпись.
class _StageRow extends StatelessWidget {
  const _StageRow({required this.stage, required this.stepIndex});

  final Stage stage;
  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final color = stageColor(stage);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 190,
          child: Text(stageLabels[stage]!, textAlign: TextAlign.right, style: AppText.eyebrow.copyWith(fontSize: 9.5, color: color)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < demoSteps.length; i++)
                if (demoSteps[i].stage == stage) _StepChip(index: i, selected: i == stepIndex, color: color),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.index, required this.selected, required this.color});

  final int index;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tap(
      key: Key('step-chip-$index'),
      onTap: () => AppState.instance.goToStep(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
        decoration: BoxDecoration(
          color: selected ? color : AppColors.card,
          border: Border.all(color: selected ? color : AppColors.line),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${index + 1} · ${demoSteps[index].navLabel}',
          style: TextStyle(
            fontSize: 11,
            color: selected ? Colors.white : AppColors.ink2,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons({required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final isLast = stepIndex == demoSteps.length - 1;
    return Row(
      children: [
        if (stepIndex > 0) ...[
          Tap(
            onTap: state.prevStep,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('←', style: TextStyle(fontSize: 17, height: 1.1, color: AppColors.ink2)),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Tap(
            onTap: isLast ? () => state.goToStep(0) : state.nextStep,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: AppGradients.cta,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x332D5BFF), blurRadius: 16, offset: Offset(0, 5))],
              ),
              child: Text(
                isLast ? '↺  Смотреть сначала' : 'Дальше: ${demoSteps[stepIndex + 1].navLabel}  →',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Узкий экран (телефон, Telegram): приложение во весь экран ───────────────
//
// Рамка телефона внутри настоящего телефона съедает треть ширины, а панель
// под ней пришлось бы листать поверх прокручиваемого приложения — жесты
// конфликтуют. Поэтому здесь приложение занимает весь экран, навигация по
// шагам — тонкой полосой сверху, пояснения и список шагов — отдельными
// слоями по кнопке.

enum _Layer { none, explain, steps }

class _Narrow extends StatefulWidget {
  const _Narrow({required this.stepIndex});

  /// Не читается напрямую: нужен, чтобы смена шага перестраивала полосу и слои.
  final int stepIndex;

  @override
  State<_Narrow> createState() => _NarrowState();
}

class _NarrowState extends State<_Narrow> {
  _Layer layer = _Layer.none;

  void _set(_Layer l) => setState(() => layer = l);

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ColoredBox(
      color: AppColors.night,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Stack(
              children: [
                Column(
                  children: [
                    _NarrowBar(
                      onSteps: () => _set(layer == _Layer.steps ? _Layer.none : _Layer.steps),
                      onExplain: () => _set(layer == _Layer.explain ? _Layer.none : _Layer.explain),
                    ),
                    const Expanded(child: AppViewport()),
                  ],
                ),
                if (layer != _Layer.none)
                  Positioned.fill(
                    top: 56,
                    child: layer == _Layer.explain
                        ? _ExplainLayer(onClose: () => _set(_Layer.none))
                        : _StepsLayer(
                            current: state.stepIndex,
                            onPick: (i) {
                              state.goToStep(i);
                              _set(_Layer.none);
                            },
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NarrowBar extends StatelessWidget {
  const _NarrowBar({required this.onSteps, required this.onExplain});

  final VoidCallback onSteps;
  final VoidCallback onExplain;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final step = state.step;
    final color = stageColor(step.stage);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: AppColors.page,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          _BarIcon(key: const Key('narrow-prev'), icon: Icons.chevron_left_rounded, onTap: state.stepIndex > 0 ? state.prevStep : null),
          Expanded(
            child: Tap(
              key: const Key('narrow-steps'),
              onTap: onSteps,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ШАГ ${state.stepIndex + 1} ИЗ ${demoSteps.length} · ЭТАП ${step.stage.index + 1}',
                    style: AppText.eyebrow.copyWith(fontSize: 9, color: color),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          step.navLabel,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.display.copyWith(fontSize: 15),
                        ),
                      ),
                      const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.ink2),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Tap(
            key: const Key('narrow-explain'),
            onTap: onExplain,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 15, color: Colors.white),
                  SizedBox(width: 4),
                  Text('Зачем', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          _BarIcon(
            key: const Key('narrow-next'),
            icon: Icons.chevron_right_rounded,
            onTap: state.stepIndex < demoSteps.length - 1 ? state.nextStep : null,
          ),
        ],
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  const _BarIcon({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap ?? () {},
      child: SizedBox(
        width: 42,
        height: 48,
        child: Icon(icon, size: 30, color: onTap == null ? AppColors.line : AppColors.ink),
      ),
    );
  }
}

class _ExplainLayer extends StatelessWidget {
  const _ExplainLayer({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final isLast = state.stepIndex == demoSteps.length - 1;
    return ColoredBox(
      color: AppColors.page,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              key: ValueKey('narrow-panel-${state.stepIndex}'),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: ExplainPanel(step: state.step, stepIndex: state.stepIndex),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.line))),
            child: Row(
              children: [
                Expanded(
                  child: Tap(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text('К экрану', textAlign: TextAlign.center, style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Tap(
                    onTap: isLast ? () => state.goToStep(0) : state.nextStep,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(gradient: AppGradients.cta, borderRadius: BorderRadius.circular(14)),
                      child: Text(
                        isLast ? '↺ Сначала' : 'Дальше →',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('сборка $buildStamp', style: AppText.muted.copyWith(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

class _StepsLayer extends StatelessWidget {
  const _StepsLayer({required this.current, required this.onPick});

  final int current;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.page,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          for (final stage in Stage.values) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
              child: Text(stageLabels[stage]!, style: AppText.eyebrow.copyWith(color: stageColor(stage))),
            ),
            for (var i = 0; i < demoSteps.length; i++)
              if (demoSteps[i].stage == stage)
                Tap(
                  key: Key('narrow-step-$i'),
                  onTap: () => onPick(i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: i == current ? stageColor(stage) : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: i == current ? stageColor(stage) : AppColors.line),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 26,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(color: i == current ? Colors.white : AppColors.muted, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            demoSteps[i].title,
                            style: TextStyle(
                              color: i == current ? Colors.white : AppColors.ink,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
