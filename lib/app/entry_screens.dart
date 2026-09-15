import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      children: [
        const Positioned.fill(child: StarField(density: 90)),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 26),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Orb(size: 210),
                  Text(
                    'ПОРТАЛ',
                    style: AppText.h2.copyWith(fontSize: 34, letterSpacing: 6, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const Spacer(),
              Text('Шесть систем о тебе —\nв одном профиле', textAlign: TextAlign.center, style: AppText.hero),
              const SizedBox(height: 14),
              Text(
                'Астрология, нумерология, Human Design, Ба Цзы, матрица судьбы и таро '
                'сходятся в один портрет. А мастера помогают с этим жить.',
                textAlign: TextAlign.center,
                style: AppText.p,
              ),
              const Spacer(flex: 2),
              PrimaryButton('Узнать свой код', onTap: () => state.open(Screen.intent)),
              const SizedBox(height: 12),
              Text('Бесплатно · 2 минуты · без регистрации', style: AppText.small),
              const SizedBox(height: 14),
              Tap(
                onTap: () => state.open(Screen.today),
                child: Text(
                  'У меня уже есть профиль',
                  style: AppText.small.copyWith(color: AppColors.star2, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IntentScreen extends StatelessWidget {
  const IntentScreen({super.key});

  static const _icons = [
    Icons.favorite_border_rounded,
    Icons.trending_up_rounded,
    Icons.explore_outlined,
    Icons.bolt_rounded,
    Icons.family_restroom_rounded,
    Icons.visibility_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      children: [
        const TopBar(title: 'Шаг 1 из 2'),
        Expanded(
          child: ScreenBody(
            children: [
              const SizedBox(height: 6),
              Text('Что для тебя сейчас\nважнее всего?', style: AppText.hero.copyWith(fontSize: 26)),
              const SizedBox(height: 10),
              Text('Можно выбрать несколько. Под это подстроим главную, подсказки и экспертов.', style: AppText.p),
              const SizedBox(height: 22),
              for (var i = 0; i < intents.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _IntentTile(
                    key: Key('intent-$i'),
                    label: intents[i],
                    icon: _icons[i],
                    selected: state.intents.contains(intents[i]),
                    onTap: () => state.toggleIntent(intents[i]),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
          child: PrimaryButton(
            'Дальше',
            enabled: state.intents.isNotEmpty,
            onTap: () => state.open(Screen.birth),
          ),
        ),
      ],
    );
  }
}

class _IntentTile extends StatelessWidget {
  const _IntentTile({super.key, required this.label, required this.icon, required this.selected, required this.onTap});

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.glow.withValues(alpha: 0.18) : AppColors.night2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.glow : AppColors.nightLine, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.glowLight : AppColors.star2),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppText.h3)),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 20,
              color: selected ? AppColors.glowLight : AppColors.star3,
            ),
          ],
        ),
      ),
    );
  }
}

class BirthScreen extends StatelessWidget {
  const BirthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final unknown = state.timeUnknown;
    return Column(
      children: [
        const TopBar(title: 'Шаг 2 из 2'),
        Expanded(
          child: ScreenBody(
            children: [
              const SizedBox(height: 6),
              Text('Когда и где\nты родилась?', style: AppText.hero.copyWith(fontSize: 26)),
              const SizedBox(height: 10),
              Text('Из этих данных считаются все системы. Их видишь только ты.', style: AppText.p),
              const SizedBox(height: 20),
              const _Field(label: 'Имя', value: Demo.name, unlocks: []),
              const _Field(
                label: 'Дата рождения',
                value: Demo.birthLabel,
                unlocks: ['numero', 'matrix', 'bazi', 'astro'],
              ),
              _Field(
                label: 'Время рождения',
                value: unknown ? 'Не знаю' : Demo.birthTime,
                unlocks: const ['astro', 'hd', 'bazi'],
                warning: unknown ? 'Асцендент и Human Design будут приблизительными. Время можно добавить позже.' : null,
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
              const _Field(label: 'Место рождения', value: Demo.birthPlace, unlocks: ['astro', 'hd']),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
          child: PrimaryButton('Рассчитать мой код', icon: Icons.auto_awesome, onTap: () => state.open(Screen.code)),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, required this.unlocks, this.warning});

  final String label;
  final String value;
  final List<String> unlocks;
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
            if (unlocks.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (final id in unlocks) Pill(methodById(id).name, color: methodById(id).color),
                ],
              ),
            ],
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

class CodeScreen extends StatelessWidget {
  const CodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    // Короткая «сборка» кода: без неё результат выглядит заготовленным заранее.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      builder: (context, t, _) {
        if (t < 1) return _Calculating(progress: t);
        return Column(
          children: [
            TopBar(
              title: 'Твой код',
              trailing: Tap(
                onTap: () => showDemoSnack(context, 'Карточка кода готова к отправке в сторис'),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.ios_share_rounded, size: 20, color: AppColors.star),
                ),
              ),
            ),
            Expanded(
              child: ScreenBody(
                children: [
                  const CodeCard(),
                  const SectionLabel('Твоя сила'),
                  const _Trait(
                    icon: Icons.bolt_rounded,
                    title: 'Запускаешь новое',
                    text: 'Число пути 1 и огненная энергия дня рождения: ты первой берёшься за то, на что другие не решаются.',
                  ),
                  const _Trait(
                    icon: Icons.spa_outlined,
                    title: 'Чувствуешь людей',
                    text: 'Рыбы и аркан Умеренности: ты тонко улавливаешь настроение и умеешь мирить.',
                  ),
                  const _Trait(
                    icon: Icons.all_inclusive_rounded,
                    title: 'Долгая энергия',
                    text: 'Генератор в Human Design: когда дело по душе, ты не устаёшь дольше других.',
                  ),
                  const SectionLabel('Где спотыкаешься'),
                  const _Trait(
                    icon: Icons.waves_rounded,
                    title: 'Решения на эмоциях',
                    text: 'Импульс «сделать сейчас» спорит с эмоциональным авторитетом, которому нужно время.',
                    warm: true,
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton('Сохранить мой код', onTap: () => state.open(Screen.save)),
                  const SizedBox(height: 10),
                  Center(child: Text('Полные расшифровки по каждой системе — внутри', style: AppText.small)),
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
  const _Calculating({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final shown = (progress * methods.length).floor().clamp(0, methods.length - 1);
    return Stack(
      children: [
        const Positioned.fill(child: StarField()),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Orb(size: 150),
              const SizedBox(height: 18),
              Text('Сводим системы', style: AppText.h2),
              const SizedBox(height: 6),
              Text(methods[shown].name, style: AppText.p.copyWith(color: methods[shown].color)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Карточка кода — та же, что уходит в сторис.
class CodeCard extends StatelessWidget {
  const CodeCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
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
                  for (final m in methods.take(5)) _CodeChip(method: m),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodeChip extends StatelessWidget {
  const _CodeChip({required this.method});

  final Method method;

  @override
  Widget build(BuildContext context) {
    final short = switch (method.id) {
      'astro' => '☉ ${Demo.sun} · ↑ ${Demo.ascendant}',
      'numero' => 'Путь ${Demo.lifePath}',
      'hd' => '${Demo.hdType} ${Demo.hdProfile}',
      'matrix' => 'Аркан ${Demo.arcana}',
      'bazi' => Demo.chinese,
      _ => method.name,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: method.color.withValues(alpha: 0.55)),
      ),
      child: Text(short, style: const TextStyle(fontSize: 11, color: AppColors.star, fontWeight: FontWeight.w600)),
    );
  }
}

class _Trait extends StatelessWidget {
  const _Trait({required this.icon, required this.title, required this.text, this.warm = false});

  final IconData icon;
  final String title;
  final String text;
  final bool warm;

  @override
  Widget build(BuildContext context) {
    final color = warm ? AppColors.gold : AppColors.glowLight;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NightCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    void go() => state.open(Screen.today);
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
              Text(
                'Чтобы он не потерялся, а каждое утро приходило послание дня и личный прогноз.',
                style: AppText.p,
              ),
              const SizedBox(height: 22),
              _AuthButton(label: 'Продолжить с Telegram', icon: Icons.send_rounded, color: const Color(0xFF2AABEE), onTap: go),
              _AuthButton(label: 'Продолжить с Apple', icon: Icons.apple, color: Colors.white, dark: true, onTap: go),
              _AuthButton(label: 'Продолжить с Google', icon: Icons.g_mobiledata_rounded, color: AppColors.night3, onTap: go),
              _AuthButton(label: 'По номеру телефона', icon: Icons.phone_iphone_rounded, color: AppColors.night2, onTap: go),
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

class _AuthButton extends StatelessWidget {
  const _AuthButton({required this.label, required this.icon, required this.color, required this.onTap, this.dark = false});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? AppColors.night : Colors.white;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Tap(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.nightLine),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: fg),
              Expanded(
                child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
