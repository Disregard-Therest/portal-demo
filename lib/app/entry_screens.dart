import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      children: [
        const Positioned.fill(child: StarField(density: 90)),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 22),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Orb(size: 200),
                  Text(
                    'ПОРТАЛ',
                    style: AppText.h2.copyWith(fontSize: 32, letterSpacing: 6, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const Spacer(),
              Text('Узнай свой код', textAlign: TextAlign.center, style: AppText.hero),
              const SizedBox(height: 12),
              Text(
                'Дата рождения — и три числа, которые объясняют твой характер, '
                'твой год и твою силу. Бесплатно, за две минуты.',
                textAlign: TextAlign.center,
                style: AppText.p,
              ),
              const SizedBox(height: 22),
              const _HowStep(number: '1', text: 'Отвечаешь на пять вопросов о себе'),
              const SizedBox(height: 8),
              const _HowStep(number: '2', text: 'Получаешь код бесплатно — сразу'),
              const SizedBox(height: 8),
              const _HowStep(number: '3', text: 'Возвращаешься каждый день за новым'),
              const Spacer(flex: 2),
              PrimaryButton('Узнать свой код', onTap: () => state.open(Screen.survey)),
              const SizedBox(height: 14),
              Text('Вас пригласила ${Demo.inviter}', style: AppText.small),
            ],
          ),
        ),
      ],
    );
  }
}

class _HowStep extends StatelessWidget {
  const _HowStep({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.glowLight)),
          child: Text(number, style: AppText.small.copyWith(color: AppColors.glowLight, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppText.p)),
      ],
    );
  }
}

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final unknown = state.timeUnknown;
    // Прогресс — доля заполненных полей: имя, дата и город уже показаны
    // предзаполненными для демо, поэтому реально интерактивен только запрос.
    final progress = state.request == null ? 0.75 : 1.0;
    return Column(
      children: [
        const TopBar(title: ''),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 4),
          child: ValueBar(value: progress),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              const SizedBox(height: 10),
              Text('Когда, во сколько\nи где ты родилась?', style: AppText.hero.copyWith(fontSize: 25)),
              const SizedBox(height: 10),
              Text('Из этих данных считаются все расчёты. Их видишь только ты.', style: AppText.p),
              const SizedBox(height: 18),
              const _Field(label: 'Имя', value: Demo.name),
              const _Field(label: 'Дата рождения', value: Demo.birthLabel),
              _Field(
                label: 'Время рождения',
                value: unknown ? 'Не знаю' : Demo.birthTime,
                warning: unknown ? 'Понадобится позже, для астрологии. Сейчас можно не знать.' : null,
              ),
              Tap(
                key: const Key('time-unknown'),
                onTap: () => state.update(() => state.timeUnknown = !state.timeUnknown),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 14),
                  child: Row(
                    children: [
                      Icon(
                        unknown ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        size: 18,
                        color: unknown ? AppColors.glowLight : AppColors.star3,
                      ),
                      const SizedBox(width: 8),
                      Text('Не знаю точное время', style: AppText.small.copyWith(color: AppColors.star2)),
                    ],
                  ),
                ),
              ),
              const _Field(label: 'Город рождения', value: Demo.birthPlace),
              const SectionLabel('Что сейчас важнее всего'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < requestOptions.length; i++)
                    _RequestChip(
                      key: Key('request-$i'),
                      label: requestOptions[i].$1,
                      icon: requestOptions[i].$2,
                      selected: state.request == requestOptions[i].$1,
                      onTap: () => state.selectRequest(requestOptions[i].$1),
                    ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
          child: PrimaryButton(
            'Дальше',
            enabled: state.request != null,
            onTap: () => state.open(Screen.code),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.warning});

  final String label;
  final String value;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NightCard(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        radius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.small),
            const SizedBox(height: 2),
            Text(value, style: AppText.h3.copyWith(fontSize: 16)),
            if (warning != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Expanded(child: Text(warning!, style: AppText.small.copyWith(color: AppColors.gold))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestChip extends StatelessWidget {
  const _RequestChip({super.key, required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.glow.withValues(alpha: 0.18) : AppColors.night2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.glow : AppColors.nightLine, width: selected ? 1.5 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: selected ? AppColors.glowLight : AppColors.star2),
            const SizedBox(width: 8),
            Text(label, style: AppText.h3.copyWith(fontSize: 13.5)),
          ],
        ),
      ),
    );
  }
}

class CodeScreen extends StatelessWidget {
  const CodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final year = DateTime.now().year;
    // Короткая «сборка» кода: без неё результат выглядит заготовленным заранее.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (context, t, _) {
        if (t < 1) return const _Calculating();
        return Column(
          children: [
            const TopBar(title: 'Твой код'),
            Expanded(
              child: ScreenBody(
                children: [
                  const CodeCard(),
                  const SectionLabel('Расшифровка'),
                  _NumberCard(label: 'ЧИСЛО ПУТИ', value: '${Demo.lifePath}', title: 'Лидерство и старт', text: lifePathText),
                  _NumberCard(
                    label: 'АРКАН ЛИЧНОСТИ',
                    value: '${Demo.arcana}',
                    title: arcanaName,
                    text: arcanaText,
                  ),
                  _NumberCard(
                    label: 'ЛИЧНЫЙ ГОД $year',
                    value: '${Demo.personalYear(year)}',
                    title: 'Год завершения',
                    text: personalYearText,
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton('Сохранить результат', onTap: () => state.open(Screen.auth)),
                  const SizedBox(height: 10),
                  Center(child: Text('Бесплатно и навсегда — платное начинается дальше', style: AppText.small)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Calculating extends StatelessWidget {
  const _Calculating();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: StarField()),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Orb(size: 150),
              const SizedBox(height: 18),
              Text('Считаем твой код', style: AppText.h2),
              const SizedBox(height: 6),
              Text('по дате рождения', style: AppText.p),
            ],
          ),
        ),
      ],
    );
  }
}

/// Карточка кода — верх результата, показывает все три числа разом.
class CodeCard extends StatelessWidget {
  const CodeCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.code,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Stack(
        children: [
          const Positioned(right: -30, top: -30, child: Orb(size: 120, animate: false)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('КОД · ${Demo.name.toUpperCase()}', style: AppText.label.copyWith(color: AppColors.glowLight)),
              const SizedBox(height: 6),
              Text('Мягкая сила,\nкоторая запускает', style: AppText.hero.copyWith(fontSize: compact ? 20 : 24)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _codeChip('Путь ${Demo.lifePath}'),
                  _codeChip('Аркан ${Demo.arcana}'),
                  _codeChip('Год ${Demo.personalYear(year)}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _codeChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glowLight.withValues(alpha: 0.55)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.star, fontWeight: FontWeight.w600)),
      );
}

class _NumberCard extends StatelessWidget {
  const _NumberCard({required this.label, required this.value, required this.title, required this.text});

  final String label;
  final String value;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NightCard(
        accent: AppColors.numero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.numero.withValues(alpha: 0.16), shape: BoxShape.circle),
              child: Text(value, style: AppText.h2.copyWith(color: AppColors.numero, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppText.label.copyWith(color: AppColors.numero)),
                  const SizedBox(height: 3),
                  Text(title, style: AppText.h3.copyWith(fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(text, style: AppText.p.copyWith(fontSize: 12.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final sent = state.codeSent;
    return Column(
      children: [
        const TopBar(title: ''),
        Expanded(
          child: ScreenBody(
            children: [
              const SizedBox(height: 4),
              const CodeCard(compact: true),
              const SizedBox(height: 22),
              Text('Сохрани свой код', style: AppText.hero.copyWith(fontSize: 26)),
              const SizedBox(height: 8),
              Text('Чтобы результат сохранился и каждый день приходило новое задание.', style: AppText.p),
              const SizedBox(height: 22),
              const _Field(label: 'Номер телефона', value: Demo.phone),
              if (!sent) ...[
                const SizedBox(height: 8),
                PrimaryButton(
                  'Получить код',
                  icon: Icons.sms_outlined,
                  onTap: () => state.update(() => state.codeSent = true),
                ),
              ] else ...[
                const _Field(label: 'Код из SMS', value: '• • • •'),
                const SizedBox(height: 8),
                PrimaryButton('Войти', onTap: () => state.open(Screen.today)),
              ],
              const SizedBox(height: 10),
              Text(
                'Продолжая, ты соглашаешься с условиями и политикой обработки данных.',
                textAlign: TextAlign.center,
                style: AppText.small.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
