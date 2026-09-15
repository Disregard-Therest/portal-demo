import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/astro_math.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

const _months = [
  'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
];
const _weekdays = ['понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье'];

const _dayNumberMeaning = {
  1: 'начинать', 2: 'договариваться', 3: 'говорить и творить', 4: 'наводить порядок',
  5: 'менять и пробовать', 6: 'заботиться', 7: 'побыть с собой', 8: 'про деньги и дела',
  9: 'завершать', 11: 'слушать интуицию', 22: 'строить большое',
};

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final now = DateTime.now();
    final day = AstroMath.personalDay(Demo.birth, now);
    return ScreenBody(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_weekdays[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]}'.toUpperCase(), style: AppText.label),
                  const SizedBox(height: 4),
                  Text('Доброе утро, ${Demo.name}', style: AppText.hero.copyWith(fontSize: 25)),
                ],
              ),
            ),
            Tap(
              onTap: () => state.open(Screen.profile),
              child: const Avatar(initials: 'А', color: AppColors.glow, size: 40),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Энергия дня — наследник карточки Ба Цзы из старого приложения.
        NightCard(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3A1A5E), Color(0xFF7A2E3E), Color(0xFF0A0B4A)],
          ),
          accent: AppColors.bazi,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Pill('ЭНЕРГИЯ ДНЯ', color: AppColors.bazi),
                  const Spacer(),
                  Text('Ба Цзы', style: AppText.small),
                ],
              ),
              const SizedBox(height: 10),
              Text('День Огненной Лошади', style: AppText.h2),
              const SizedBox(height: 6),
              Text(
                'Для тебя, Металлической Козы, это день напора. Хорошо для переговоров и спорта; '
                'крупные покупки лучше отложить до завтра.',
                style: AppText.p.copyWith(color: AppColors.star),
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Pill('✓ переговоры', color: AppColors.good),
                  Pill('✓ спорт', color: AppColors.good),
                  Pill('✕ крупные покупки', color: AppColors.bazi),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: NightCard(
                accent: AppColors.numero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ЧИСЛО ДНЯ', style: AppText.label.copyWith(color: AppColors.numero)),
                    const SizedBox(height: 4),
                    Text('$day', style: AppText.hero.copyWith(fontSize: 38, color: AppColors.numero)),
                    Text('День, чтобы ${_dayNumberMeaning[day] ?? 'прислушаться'}', style: AppText.small.copyWith(color: AppColors.star2)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: NightCard(
                onTap: () => state.open(Screen.calendar),
                accent: AppColors.astro,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ТВОЙ ПЕРИОД', style: AppText.label.copyWith(color: AppColors.astro)),
                    const SizedBox(height: 6),
                    Text('Год завершения', style: AppText.h3),
                    const SizedBox(height: 4),
                    Text('3 окт — окно для старта', style: AppText.small.copyWith(color: AppColors.star2)),
                    const SizedBox(height: 8),
                    Text('Календарь →', style: AppText.small.copyWith(color: AppColors.glowLight, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _DailyMessage(revealed: state.cardRevealed, onReveal: () => state.update(() => state.cardRevealed = true)),
        const SectionLabel('Практика дня'),
        NightCard(
          onTap: () {
            state.expertIndex = 2;
            state.open(Screen.expert);
          },
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(colors: [Color(0xFF7A3FC4), Color(0xFFEE86BB)]),
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Дыхание перед решением', style: AppText.h3.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('7 мин · Ольга Лучезарная', style: AppText.small),
                  ],
                ),
              ),
              const Pill('бесплатно', color: AppColors.good),
            ],
          ),
        ),
        const SizedBox(height: 10),
        NightCard(
          onTap: () => state.open(Screen.match),
          accent: AppColors.numero,
          child: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: AppColors.numero, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Добавь близкого — узнай, где вы совпадаете', style: AppText.h3.copyWith(fontSize: 13.5)),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.star3),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyMessage extends StatelessWidget {
  const _DailyMessage({required this.revealed, required this.onReveal});

  final bool revealed;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return NightCard(
      key: const Key('daily-card'),
      onTap: revealed ? null : onReveal,
      accent: AppColors.tarot,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: revealed
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1E5E8C), Color(0xFF15175C)],
                      ),
                      border: Border.all(color: AppColors.tarot.withValues(alpha: 0.6)),
                    ),
                    child: const Icon(Icons.wb_sunny_outlined, color: AppColors.gold, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ПОСЛАНИЕ ДНЯ · XIX СОЛНЦЕ', style: AppText.label.copyWith(color: AppColors.tarot)),
                        const SizedBox(height: 6),
                        Text(
                          '«Не прячь то, что у тебя получается. Сегодня тебя видят — покажи результат».',
                          style: AppText.p.copyWith(color: AppColors.star, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(Icons.style_outlined, color: AppColors.tarot, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Послание дня', style: AppText.h3),
                        Text('Сосредоточься на вопросе и вытяни карту', style: AppText.small),
                      ],
                    ),
                  ),
                  const Pill('Вытянуть', color: AppColors.tarot, filled: true),
                ],
              ),
      ),
    );
  }
}

class MethodsScreen extends StatelessWidget {
  const MethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ScreenBody(
      children: [
        const SizedBox(height: 10),
        Text('Методики', style: AppText.hero.copyWith(fontSize: 26)),
        const SizedBox(height: 6),
        Text('Шесть взглядов на тебя. Базовое открыто, глубже — в расшифровках.', style: AppText.p),
        const SizedBox(height: 16),
        for (final m in methods)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NightCard(
              key: Key('method-${m.id}'),
              accent: m.color,
              onTap: () => state.open(Screen.reading),
              child: Row(
                children: [
                  MethodBadge(method: m, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: AppText.h3),
                        Text(m.answers, style: AppText.small),
                        const SizedBox(height: 6),
                        Text(m.result, style: AppText.small.copyWith(color: m.color, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.star3),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        NightCard(
          onTap: () => state.open(Screen.match),
          gradient: const LinearGradient(colors: [Color(0xFF5A1F55), Color(0xFF15175C)]),
          accent: AppColors.numero,
          child: Row(
            children: [
              const Icon(Icons.people_alt_outlined, color: AppColors.numero),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Совместимость', style: AppText.h3),
                    Text('Партнёр, ребёнок, друг, коллега', style: AppText.small),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.star3),
            ],
          ),
        ),
      ],
    );
  }
}

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final m = methodById('hd');
    void unlock() => state.open(Screen.plus);
    return Column(
      children: [
        const TopBar(title: 'Human Design'),
        Expanded(
          child: ScreenBody(
            children: [
              NightCard(
                accent: m.color,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F4B5C), Color(0xFF0A0B4A)],
                ),
                child: Row(
                  children: [
                    const _BodygraphMini(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ТВОЙ ТИП', style: AppText.label.copyWith(color: m.color)),
                          const SizedBox(height: 4),
                          Text(Demo.hdType, style: AppText.hero.copyWith(fontSize: 26)),
                          const SizedBox(height: 4),
                          Text('Профиль ${Demo.hdProfile} · Отшельник-опортунист', style: AppText.small.copyWith(color: AppColors.star2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SectionLabel('Открыто'),
              const _OpenSection(
                title: 'Стратегия — откликаться',
                text: 'Твоя энергия включается в ответ на то, что приходит извне. Когда ты сама «продавливаешь» старт, '
                    'дело быстро выматывает. Когда откликаешься — не устаёшь.',
              ),
              const _OpenSection(
                title: 'Авторитет — эмоциональный',
                text: 'Правильное решение не приходит в моменте. Дай себе ночь, и ясность наступит сама.',
              ),
              const SectionLabel('В полной расшифровке'),
              LockedRow('Профиль 2/4 — как ты строишь отношения', subtitle: '6 страниц', onTap: unlock),
              LockedRow('9 центров — где ты стабильна, где берёшь чужое', subtitle: 'интерактивная схема', onTap: unlock),
              LockedRow('Инкарнационный крест — твоя большая тема', subtitle: '4 страницы', onTap: unlock),
              LockedRow('Не-Я: как понять, что живёшь не своей жизнью', onTap: unlock),
              const SizedBox(height: 8),
              PrimaryButton('Открыть расшифровку · 490 ₽', onTap: unlock, gold: true),
              const SizedBox(height: 8),
              GhostButton('Все системы в Портал+', onTap: unlock),
              const SectionLabel('Разобрать с экспертом'),
              _ExpertMini(index: 3, onTap: () {
                state.expertIndex = 3;
                state.open(Screen.expert);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _BodygraphMini extends StatelessWidget {
  const _BodygraphMini();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      height: 96,
      child: CustomPaint(painter: _BodygraphPainter()),
    );
  }
}

class _BodygraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final line = Paint()
      ..color = AppColors.hd.withValues(alpha: 0.5)
      ..strokeWidth = 1.2;
    final filled = Paint()..color = AppColors.hd;
    final empty = Paint()
      ..color = AppColors.hd
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final pts = [
      Offset(s.width / 2, 6), Offset(s.width / 2, 22), Offset(s.width / 2, 40),
      Offset(s.width / 2, 58), Offset(12, 62), Offset(s.width - 12, 62),
      Offset(s.width / 2, 76), Offset(s.width / 2, 91), Offset(s.width - 18, 82),
    ];
    for (var i = 0; i < pts.length - 1; i++) {
      canvas.drawLine(pts[i], pts[i + 1], line);
    }
    const defined = {1, 2, 3, 6, 8};
    for (var i = 0; i < pts.length; i++) {
      canvas.drawCircle(pts[i], 5, defined.contains(i) ? filled : empty);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OpenSection extends StatelessWidget {
  const _OpenSection({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NightCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.h3.copyWith(fontSize: 14)),
            const SizedBox(height: 4),
            Text(text, style: AppText.p.copyWith(fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}

class _ExpertMini extends StatelessWidget {
  const _ExpertMini({required this.index, required this.onTap});

  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final e = experts[index];
    return NightCard(
      onTap: onTap,
      child: Row(
        children: [
          Avatar(initials: e.initials, color: e.color, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name, style: AppText.h3.copyWith(fontSize: 14)),
                Text('${e.role} · ★ ${e.rating}', style: AppText.small),
              ],
            ),
          ),
          Text('от ${_rub(e.price)}', style: AppText.small.copyWith(color: AppColors.star)),
        ],
      ),
    );
  }
}

String _rub(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
    b.write(s[i]);
  }
  return '$b ₽';
}

String rub(int v) => _rub(v);

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      children: [
        const TopBar(title: 'Совместимость'),
        Expanded(
          child: state.partnerAdded ? const _MatchResult() : _MatchAdd(onAdd: () => state.update(() => state.partnerAdded = true)),
        ),
      ],
    );
  }
}

class _MatchAdd extends StatelessWidget {
  const _MatchAdd({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
      children: [
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            height: 130,
            width: 220,
            child: Stack(
              children: [
                const Positioned(left: 10, top: 5, child: Orb(size: 120, color: AppColors.glow)),
                const Positioned(right: 10, top: 5, child: Orb(size: 120, color: AppColors.numero)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('С кем сверим\nваши коды?', textAlign: TextAlign.center, style: AppText.hero.copyWith(fontSize: 24)),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: const [
            Pill('Партнёр', color: AppColors.numero, filled: true),
            Pill('Ребёнок', color: AppColors.star2),
            Pill('Друг', color: AppColors.star2),
            Pill('Коллега', color: AppColors.star2),
          ],
        ),
        const SizedBox(height: 18),
        NightCard(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Имя', style: AppText.small),
              Text(Demo.partnerName, style: AppText.h3.copyWith(fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        NightCard(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Дата рождения', style: AppText.small),
              Text(Demo.partnerBirth, style: AppText.h3.copyWith(fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('Время рождения не нужно: Максим добавит его сам, когда примет приглашение.', style: AppText.small),
        const SizedBox(height: 18),
        PrimaryButton('Сверить', key: const Key('match-add'), onTap: onAdd),
      ],
    );
  }
}

class _MatchResult extends StatelessWidget {
  const _MatchResult();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ScreenBody(
      children: [
        NightCard(
          gradient: const LinearGradient(colors: [Color(0xFF4A1D5E), Color(0xFF15175C)]),
          accent: AppColors.numero,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Avatar(initials: 'А', color: AppColors.glow, size: 44),
                  const SizedBox(width: 10),
                  Text('78%', style: AppText.hero.copyWith(fontSize: 40, color: AppColors.numero)),
                  const SizedBox(width: 10),
                  const Avatar(initials: 'М', color: AppColors.numero, size: 44),
                ],
              ),
              const SizedBox(height: 6),
              Text('${Demo.name} и ${Demo.partnerName}', style: AppText.h3),
              const SizedBox(height: 4),
              Text(
                'Сильная эмоциональная связь при разном темпе: ты действуешь, он чувствует.',
                textAlign: TextAlign.center,
                style: AppText.p.copyWith(fontSize: 12.5),
              ),
            ],
          ),
        ),
        const SectionLabel('По сферам'),
        const _Sphere(label: 'Эмоции и близость', value: 0.86, open: true),
        const _Sphere(label: 'Быт и деньги', value: 0.64),
        const _Sphere(label: 'Цели и планы', value: 0.58),
        const _Sphere(label: 'Страсть', value: 0.91),
        const SizedBox(height: 14),
        NightCard(
          accent: AppColors.gold,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.card_giftcard_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Полный разбор — бесплатно для вас двоих', style: AppText.h3.copyWith(fontSize: 14))),
                ],
              ),
              const SizedBox(height: 6),
              Text('Когда Максим примет приглашение и добавит время рождения.', style: AppText.small.copyWith(color: AppColors.star2)),
              const SizedBox(height: 12),
              PrimaryButton(
                'Пригласить Максима',
                icon: Icons.send_rounded,
                gold: true,
                onTap: () => showDemoSnack(context, 'Ссылка-приглашение скопирована'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GhostButton('Открыть сейчас в Портал+', onTap: () => state.open(Screen.plus)),
      ],
    );
  }
}

class _Sphere extends StatelessWidget {
  const _Sphere({required this.label, required this.value, this.open = false});

  final String label;
  final double value;
  final bool open;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppText.h3.copyWith(fontSize: 13))),
              if (open)
                Text('${(value * 100).round()}%', style: AppText.small.copyWith(color: AppColors.numero, fontWeight: FontWeight.w600))
              else
                const Icon(Icons.lock_rounded, size: 13, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: 6),
          open
              ? ValueBar(value: value, color: AppColors.numero)
              : const ValueBar(value: 0, color: AppColors.star3),
        ],
      ),
    );
  }
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final answered = state.guideAnswered;
    final left = 3 - answered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
          child: Row(
            children: [
              const Orb(size: 38),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Проводник', style: AppText.h3),
                    Text('знает твой код · опирается на методики экспертов', style: AppText.small),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            children: [
              const _Bubble(
                mine: false,
                text: 'Привет, Анна. Я вижу твой код целиком: все шесть систем и то, что для тебя сейчас важно. '
                    'Спроси о любой ситуации — отвечу с опорой на них.',
              ),
              for (var i = 0; i < answered; i++) ...[
                _Bubble(mine: true, text: guideSuggestions[i].question),
                _Bubble(mine: false, text: guideSuggestions[i].answer, hint: guideSuggestions[i].expertHint),
              ],
              if (answered < guideSuggestions.length) ...[
                const SizedBox(height: 6),
                Text('ПОПРОБУЙ СПРОСИТЬ', style: AppText.label),
                const SizedBox(height: 8),
                for (var i = answered; i < guideSuggestions.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Tap(
                      key: Key('guide-q-$i'),
                      onTap: i == answered ? () => state.update(() => state.guideAnswered++) : () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: i == answered ? AppColors.glow : AppColors.nightLine),
                        ),
                        child: Text(
                          guideSuggestions[i].question,
                          style: AppText.p.copyWith(color: i == answered ? AppColors.star : AppColors.star3, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.nightLine))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(color: AppColors.night2, borderRadius: BorderRadius.circular(22)),
                      child: Text('Спроси о своей ситуации…', style: AppText.p.copyWith(color: AppColors.star3)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(radius: 20, backgroundColor: AppColors.glow, child: Icon(Icons.mic_rounded, color: Colors.white, size: 20)),
                ],
              ),
              const SizedBox(height: 6),
              Tap(
                onTap: () => state.open(Screen.plus),
                child: Text(
                  left > 0 ? 'Бесплатно осталось $left из 3 вопросов · безлимит в Портал+' : 'Бесплатные вопросы закончились · безлимит в Портал+',
                  style: AppText.small.copyWith(fontSize: 10.5, color: left > 0 ? AppColors.star3 : AppColors.gold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.mine, required this.text, this.hint});

  final bool mine;
  final String text;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mine ? AppColors.glow : AppColors.night2,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine ? null : Border.all(color: AppColors.nightLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: AppText.p.copyWith(color: AppColors.star, fontSize: 13)),
            if (hint != null) ...[
              const SizedBox(height: 10),
              Tap(
                onTap: () {
                  state.expertIndex = hint!.startsWith('Дана') ? 3 : 0;
                  state.open(Screen.expert);
                },
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: AppColors.night3, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.person_search_rounded, size: 16, color: AppColors.gold),
                      const SizedBox(width: 8),
                      Expanded(child: Text(hint!, style: AppText.small.copyWith(color: AppColors.gold))),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static const _periods = [
    ('СЕН', 9, false), ('ОКТ', 1, true), ('НОЯ', 2, false), ('ДЕК', 3, false), ('ЯНВ', 1, false), ('ФЕВ', 2, false),
  ];

  static const _dates = [
    ('3 окт', 'Окно для старта', 'Новолуние в твоём 6-м доме: хорошо начинать проект или менять работу.', AppColors.good, 'astro'),
    ('9 окт', 'Меркурий разворачивается', 'До 1 ноября не подписывать важного и не покупать технику.', AppColors.bazi, 'astro'),
    ('14 окт', 'Личный день 1', 'Сильный день для первого шага в том, что давно откладывала.', AppColors.numero, 'numero'),
    ('27 ноя', 'Благоприятная неделя', 'Хорошо для переговоров о деньгах и повышения.', AppColors.good, 'bazi'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      children: [
        const TopBar(title: 'Календарь периодов'),
        Expanded(
          child: ScreenBody(
            children: [
              NightCard(
                gradient: AppGradients.premium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('2026 · ЛИЧНЫЙ ГОД ${AstroMath.personalYear(Demo.birth, 2026)}', style: AppText.label.copyWith(color: AppColors.gold)),
                    const SizedBox(height: 6),
                    Text('Год завершения', style: AppText.hero.copyWith(fontSize: 24)),
                    const SizedBox(height: 6),
                    Text(
                      'Закрыть старое, отпустить лишнее, дописать начатое. Новый девятилетний цикл начнётся в 2027-м.',
                      style: AppText.p.copyWith(color: AppColors.star),
                    ),
                  ],
                ),
              ),
              const SectionLabel('Личные месяцы'),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    for (final (label, n, current) in _periods)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: current ? AppColors.glow.withValues(alpha: 0.2) : AppColors.night2,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: current ? AppColors.glow : AppColors.nightLine),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(label, style: AppText.label.copyWith(fontSize: 9)),
                              const SizedBox(height: 4),
                              Text('$n', style: AppText.h2.copyWith(color: current ? AppColors.glowLight : AppColors.star)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SectionLabel('Важные даты'),
              for (final (date, title, text, color, methodId) in _dates)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NightCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 54,
                          child: Text(date, style: AppText.h3.copyWith(fontSize: 13, color: color)),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: AppText.h3.copyWith(fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(text, style: AppText.small.copyWith(color: AppColors.star2)),
                              const SizedBox(height: 6),
                              Pill(methodById(methodId).name, color: methodById(methodId).color),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              NightCard(
                onTap: () => state.update(() => state.remindersOn = !state.remindersOn),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, color: AppColors.glowLight),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Напоминать накануне важных дат', style: AppText.h3.copyWith(fontSize: 13.5))),
                    Switch(
                      value: state.remindersOn,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.glow,
                      onChanged: (v) => state.update(() => state.remindersOn = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
