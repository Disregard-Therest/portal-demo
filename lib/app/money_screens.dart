import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';
import 'daily_screens.dart' show rub;
import 'entry_screens.dart' show CodeCard;

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final filter = state.methodFilter;
    final list = [
      for (var i = 0; i < experts.length; i++)
        if (filter.isEmpty || experts[i].methodIds.contains(filter)) i,
    ];
    return ScreenBody(
      children: [
        const SizedBox(height: 10),
        Text('Эксперты', style: AppText.hero.copyWith(fontSize: 26)),
        const SizedBox(height: 6),
        Text('Проверенные мастера. Каждый видит твой код ещё до встречи.', style: AppText.p),
        const SizedBox(height: 14),
        SizedBox(
          height: 32,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(label: 'Все', selected: filter.isEmpty, onTap: () => state.update(() => state.methodFilter = '')),
              for (final m in methods)
                _FilterChip(
                  label: m.name,
                  color: m.color,
                  selected: filter == m.id,
                  onTap: () => state.update(() => state.methodFilter = m.id),
                ),
            ],
          ),
        ),
        const SectionLabel('Подходят под твой запрос'),
        for (final i in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ExpertCard(
              index: i,
              onTap: () {
                state.expertIndex = i;
                state.open(Screen.expert);
              },
            ),
          ),
        const SizedBox(height: 4),
        Center(child: Text('Имена и цифры — пример', style: AppText.small.copyWith(fontSize: 10))),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap, this.color = AppColors.glow});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Tap(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.2) : AppColors.night2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? color : AppColors.nightLine),
          ),
          child: Text(label, style: TextStyle(fontSize: 12, color: selected ? AppColors.star : AppColors.star2, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _ExpertCard extends StatelessWidget {
  const _ExpertCard({required this.index, required this.onTap});

  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final e = experts[index];
    return NightCard(
      key: Key('expert-$index'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(initials: e.initials, color: e.color, size: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.name, style: AppText.h3),
                    Text(e.role, style: AppText.small),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
                        const SizedBox(width: 3),
                        Text('${e.rating} · ${e.reviews} отзывов · ${e.years} лет практики', style: AppText.small.copyWith(color: AppColors.star2)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [for (final id in e.methodIds) Pill(methodById(id).name, color: methodById(id).color)],
                ),
              ),
              const SizedBox(width: 8),
              Text('от ${rub(e.price)}', style: AppText.h3.copyWith(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpertScreen extends StatelessWidget {
  const ExpertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final e = experts[state.expertIndex];
    final m = methodById(e.methodIds.first);
    return Column(
      children: [
        TopBar(
          title: '',
          trailing: Tap(
            onTap: () => showDemoSnack(context, 'Эксперт добавлен в избранное'),
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.favorite_border_rounded, color: AppColors.star, size: 21)),
          ),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Orb(size: 150, color: e.color, animate: false),
                    Avatar(initials: e.initials, color: e.color, size: 86),
                  ],
                ),
              ),
              Text(e.name, textAlign: TextAlign.center, style: AppText.hero.copyWith(fontSize: 24)),
              const SizedBox(height: 4),
              Text(e.role, textAlign: TextAlign.center, style: AppText.p),
              const SizedBox(height: 14),
              Row(
                children: [
                  _Stat(value: '★ ${e.rating}', label: '${e.reviews} отзывов'),
                  _Stat(value: '${e.years} лет', label: 'практики'),
                  _Stat(value: '${e.students}', label: 'учеников'),
                ],
              ),
              const SectionLabel('О подходе'),
              Text(
                '${m.name} без фатализма: карта показывает не приговор, а твои сильные ходы. '
                'На встрече разбираем один живой вопрос и уходим с планом на ближайшие месяцы.',
                style: AppText.p,
              ),
              const SectionLabel('Как можно поработать'),
              _Product(
                icon: Icons.graphic_eq_rounded,
                title: 'Мини-разбор голосом',
                text: 'Ответ на один вопрос в течение 24 часов',
                price: rub(1500),
                onTap: () => state.open(Screen.consult),
              ),
              _Product(
                icon: Icons.videocam_outlined,
                title: 'Консультация · 60 минут',
                text: 'Видео или голос, запись встречи остаётся у тебя',
                price: rub(e.price),
                highlight: true,
                onTap: () => state.open(Screen.consult),
              ),
              _Product(
                icon: Icons.school_outlined,
                title: 'Курс «Твоя карта за 21 день»',
                text: '21 урок · задания · чат потока · старт 1 октября',
                price: rub(12900),
                onTap: () => state.open(Screen.course),
              ),
              const SectionLabel('Отзывы'),
              const _Review(name: 'Екатерина', text: 'За час разобрали то, с чем я ходила два года. Отдельное спасибо, что без пугалок.'),
              const _Review(name: 'Ирина', text: 'Понравилось, что всё посчитано заранее и мы сразу говорили про мою ситуацию.'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
          child: PrimaryButton('Записаться на консультацию', onTap: () => state.open(Screen.consult)),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: AppColors.night2, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value, style: AppText.h3.copyWith(fontSize: 14)),
            Text(label, style: AppText.small.copyWith(fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}

class _Product extends StatelessWidget {
  const _Product({required this.icon, required this.title, required this.text, required this.price, required this.onTap, this.highlight = false});

  final IconData icon;
  final String title;
  final String text;
  final String price;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NightCard(
        onTap: onTap,
        accent: highlight ? AppColors.glow : null,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: highlight ? AppColors.glowLight : AppColors.star2, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h3.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(text, style: AppText.small),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(price, style: AppText.h3.copyWith(fontSize: 13.5)),
          ],
        ),
      ),
    );
  }
}

class _Review extends StatelessWidget {
  const _Review({required this.name, required this.text});

  final String name;
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
            Row(
              children: [
                Text(name, style: AppText.h3.copyWith(fontSize: 13.5)),
                const Spacer(),
                const Text('★★★★★', style: TextStyle(color: AppColors.gold, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 4),
            Text(text, style: AppText.p.copyWith(fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  static const _lessons = [
    ('Как читать свою карту', '12 мин'),
    ('Солнце: во что ты светишь', '18 мин'),
    ('Асцендент: как тебя видят', '15 мин'),
    ('Луна: что тебе нужно для покоя', '16 мин'),
    ('Венера: как ты любишь', '14 мин'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final done = state.lessonsDone;
    final current = List.generate(_lessons.length, (i) => i).firstWhere((i) => !done.contains(i), orElse: () => _lessons.length - 1);
    return Column(
      children: [
        const TopBar(title: 'Твоя карта за 21 день'),
        Expanded(
          child: ScreenBody(
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B2BB0), Color(0xFF0A0B4A)],
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned.fill(child: StarField(density: 40)),
                    const Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      right: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('УРОК ${current + 1}', style: AppText.label.copyWith(color: AppColors.glowLight)),
                          Text(_lessons[current].$1, style: AppText.h3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              NightCard(
                accent: AppColors.astro,
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person_pin_circle_outlined, color: AppColors.astro, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Твой асцендент — ${Demo.ascendant}. В этом уроке смотри на примеры для земных знаков: они про тебя.',
                        style: AppText.p.copyWith(fontSize: 12.5, color: AppColors.star),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('Пройдено ${done.length} из 21', style: AppText.small.copyWith(color: AppColors.star2)),
                  const Spacer(),
                  Text('${(done.length / 21 * 100).round()}%', style: AppText.small.copyWith(color: AppColors.glowLight)),
                ],
              ),
              const SizedBox(height: 6),
              ValueBar(value: done.length / 21),
              const SectionLabel('Уроки'),
              for (var i = 0; i < _lessons.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NightCard(
                    key: Key('lesson-$i'),
                    accent: i == current ? AppColors.glow : null,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    onTap: () => state.update(() => done.contains(i) ? done.remove(i) : done.add(i)),
                    child: Row(
                      children: [
                        Icon(
                          done.contains(i) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          color: done.contains(i) ? AppColors.good : AppColors.star3,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text('${i + 1}. ${_lessons[i].$1}', style: AppText.h3.copyWith(fontSize: 13.5))),
                        Text(_lessons[i].$2, style: AppText.small),
                      ],
                    ),
                  ),
                ),
              const SectionLabel('Задание к уроку'),
              NightCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Три ситуации за неделю', style: AppText.h3.copyWith(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Запиши, когда люди видели тебя не такой, какая ты внутри. Обсудим в чате потока.', style: AppText.p.copyWith(fontSize: 12.5)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              NightCard(
                onTap: () => showDemoSnack(context, 'Чат потока: 148 участников'),
                child: Row(
                  children: [
                    const Icon(Icons.forum_outlined, color: AppColors.glowLight),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Чат потока · 148 участников', style: AppText.h3.copyWith(fontSize: 13.5))),
                    const Pill('+23', color: AppColors.glow, filled: true),
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

class ConsultScreen extends StatelessWidget {
  const ConsultScreen({super.key});

  static const _days = [('ЧТ', 18), ('ПТ', 19), ('ПН', 22), ('ВТ', 23)];
  static const _times = ['10:00', '12:30', '16:00', '19:00', '20:30'];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final e = experts[state.expertIndex];
    if (state.booked) return _Booked(expert: e);
    return Column(
      children: [
        const TopBar(title: 'Запись на консультацию'),
        Expanded(
          child: ScreenBody(
            children: [
              NightCard(
                child: Row(
                  children: [
                    Avatar(initials: e.initials, color: e.color, size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name, style: AppText.h3.copyWith(fontSize: 14)),
                          Text('Консультация · 60 минут', style: AppText.small),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SectionLabel('Формат'),
              Row(
                children: [
                  for (final (i, label, icon) in [(0, 'Видео', Icons.videocam_outlined), (1, 'Голос', Icons.call_outlined), (2, 'Переписка', Icons.chat_bubble_outline)])
                    Expanded(
                      child: Tap(
                        onTap: () => state.update(() => state.format = i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: state.format == i ? AppColors.glow.withValues(alpha: 0.2) : AppColors.night2,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: state.format == i ? AppColors.glow : AppColors.nightLine),
                          ),
                          child: Column(
                            children: [
                              Icon(icon, size: 19, color: AppColors.star),
                              const SizedBox(height: 3),
                              Text(label, style: AppText.small.copyWith(color: AppColors.star)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SectionLabel('Когда'),
              Row(
                children: [
                  for (var d = 0; d < _days.length; d++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: d == 0 ? AppColors.night3 : AppColors.night2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: d == 0 ? AppColors.star3 : AppColors.nightLine),
                        ),
                        child: Column(
                          children: [
                            Text(_days[d].$1, style: AppText.label.copyWith(fontSize: 9)),
                            Text('${_days[d].$2}', style: AppText.h3),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var i = 0; i < _times.length; i++)
                    Tap(
                      key: Key('slot-$i'),
                      onTap: () => state.update(() => state.slot = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: state.slot == i ? AppColors.glow : AppColors.night2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: state.slot == i ? AppColors.glow : AppColors.nightLine),
                        ),
                        child: Text(_times[i], style: const TextStyle(color: AppColors.star, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Время по твоему часовому поясу', style: AppText.small.copyWith(fontSize: 10.5)),
              const SectionLabel('Вопрос эксперту'),
              NightCard(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Думаю сменить работу, но боюсь ошибиться со сроками. Когда и в какую сторону двигаться?',
                  style: AppText.p.copyWith(color: AppColors.star, fontSize: 13),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 15, color: AppColors.good),
                  const SizedBox(width: 6),
                  Expanded(child: Text('Эксперт получит твой код и вопрос заранее — встреча начнётся сразу с сути.', style: AppText.small.copyWith(color: AppColors.star2))),
                ],
              ),
              const SizedBox(height: 16),
              NightCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _PriceLine(label: 'Консультация', value: rub(e.price)),
                    _PriceLine(label: 'Скидка Портал+ · 10%', value: '−${rub(e.price ~/ 10)}', color: AppColors.good),
                    _PriceLine(label: 'Баллами', value: '−${rub(500)}', color: AppColors.good),
                    const Divider(color: AppColors.nightLine, height: 18),
                    _PriceLine(label: 'К оплате', value: rub(e.price - e.price ~/ 10 - 500), bold: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
          child: Column(
            children: [
              PrimaryButton(
                state.slot == null ? 'Выбери время' : 'Оплатить по СБП',
                enabled: state.slot != null,
                onTap: () => state.update(() => state.booked = true),
              ),
              const SizedBox(height: 6),
              Text('или картой · возврат, если эксперт перенёс встречу', style: AppText.small.copyWith(fontSize: 10.5)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.label, required this.value, this.color, this.bold = false});

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? AppText.h3 : AppText.p.copyWith(fontSize: 13);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style.copyWith(color: color ?? (bold ? AppColors.star : AppColors.star2))),
        ],
      ),
    );
  }
}

class _Booked extends StatelessWidget {
  const _Booked({required this.expert});

  final Expert expert;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      children: [
        const Positioned.fill(child: StarField()),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Orb(size: 170, color: AppColors.good),
                  Avatar(initials: expert.initials, color: expert.color, size: 70),
                ],
              ),
              const SizedBox(height: 10),
              Text('Ты записана', style: AppText.hero),
              const SizedBox(height: 8),
              Text(
                '${expert.name} · четверг, 18 сентября · ${ConsultScreen._times[state.slot ?? 0]}\n'
                'Напомним за день и за час. Ссылка на встречу появится здесь.',
                textAlign: TextAlign.center,
                style: AppText.p,
              ),
              const Spacer(),
              PrimaryButton('Готово', onTap: () => state.update(() {
                state.booked = false;
                state.slot = null;
                state.open(Screen.today);
              })),
              const SizedBox(height: 10),
              GhostButton('Добавить в календарь', icon: Icons.event_outlined, onTap: () => showDemoSnack(context, 'Добавлено в календарь')),
            ],
          ),
        ),
      ],
    );
  }
}

class PlusScreen extends StatelessWidget {
  const PlusScreen({super.key});

  static const _features = [
    (Icons.auto_awesome, 'Полные расшифровки всех 6 систем'),
    (Icons.forum_outlined, 'Проводник без лимита вопросов'),
    (Icons.event_note_outlined, 'Календарь периодов на год'),
    (Icons.people_alt_outlined, 'Совместимость с кем угодно'),
    (Icons.percent_rounded, '−10% на консультации и курсы экспертов'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      children: [
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.premium))),
        const Positioned.fill(child: StarField(density: 70)),
        Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Tap(
                key: const Key('plus-close'),
                onTap: state.back,
                child: const Padding(padding: EdgeInsets.all(14), child: Icon(Icons.close_rounded, color: AppColors.star)),
              ),
            ),
            Expanded(
              child: ScreenBody(
                children: [
                  const Center(child: Orb(size: 110, color: AppColors.gold)),
                  Text('Портал+', textAlign: TextAlign.center, style: AppText.hero.copyWith(fontSize: 34)),
                  const SizedBox(height: 6),
                  Text('Весь твой код — без замков', textAlign: TextAlign.center, style: AppText.p.copyWith(color: AppColors.star)),
                  const SizedBox(height: 18),
                  for (final (icon, text) in _features)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(icon, size: 19, color: AppColors.gold),
                          const SizedBox(width: 12),
                          Expanded(child: Text(text, style: AppText.p.copyWith(color: AppColors.star))),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  _Plan(
                    key: const Key('plan-0'),
                    title: 'Месяц',
                    price: rub(690),
                    note: 'в месяц',
                    selected: state.plan == 0,
                    onTap: () => state.update(() => state.plan = 0),
                  ),
                  _Plan(
                    key: const Key('plan-1'),
                    title: 'Год',
                    price: rub(4900),
                    note: '408 ₽ в месяц · выгода 40%',
                    badge: 'ВЫГОДНО',
                    selected: state.plan == 1,
                    onTap: () => state.update(() => state.plan = 1),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              child: Column(
                children: [
                  PrimaryButton(
                    'Попробовать 7 дней бесплатно',
                    gold: true,
                    onTap: () {
                      showDemoSnack(context, 'Портал+ подключён');
                      state.back();
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Оплата по СБП или картой · отмена в один тап', style: AppText.small.copyWith(color: AppColors.star2, fontSize: 10.5)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Plan extends StatelessWidget {
  const _Plan({super.key, required this.title, required this.price, required this.note, required this.selected, required this.onTap, this.badge});

  final String title;
  final String price;
  final String note;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Tap(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: selected ? 0.3 : 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? AppColors.gold : Colors.white24, width: selected ? 1.6 : 1),
          ),
          child: Row(
            children: [
              Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: selected ? AppColors.gold : AppColors.star2, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: AppText.h3),
                        if (badge != null) ...[const SizedBox(width: 8), Pill(badge!, color: AppColors.gold, filled: true)],
                      ],
                    ),
                    Text(note, style: AppText.small.copyWith(color: AppColors.star2)),
                  ],
                ),
              ),
              Text(price, style: AppText.h3.copyWith(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ScreenBody(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Avatar(initials: 'А', color: AppColors.glow, size: 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Demo.name, style: AppText.h2),
                  Text('${Demo.birthLabel} · ${Demo.birthTime} · ${Demo.birthPlace}', style: AppText.small),
                ],
              ),
            ),
            const Icon(Icons.settings_outlined, color: AppColors.star2),
          ],
        ),
        const SizedBox(height: 16),
        const CodeCard(compact: true),
        const SizedBox(height: 12),
        NightCard(
          gradient: const LinearGradient(colors: [Color(0xFF4A3A10), Color(0xFF15175C)]),
          accent: AppColors.gold,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('${Demo.points}', style: AppText.hero.copyWith(fontSize: 30, color: AppColors.gold)),
                  const SizedBox(width: 8),
                  Text('баллов · 1 балл = 1 ₽', style: AppText.small.copyWith(color: AppColors.star2)),
                ],
              ),
              const SizedBox(height: 6),
              Text('Пригласи друга: ему — неделя Портал+, тебе — 300 баллов.', style: AppText.p.copyWith(color: AppColors.star, fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                      ),
                      child: Text(Demo.referralCode, style: AppText.h3.copyWith(color: AppColors.gold, letterSpacing: 2)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton('Пригласить', gold: true, onTap: () => showDemoSnack(context, 'Ссылка скопирована')),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _MenuItem(icon: Icons.favorite_border_rounded, label: 'Близкие и совместимость', trailing: '1', onTap: () => state.open(Screen.match)),
        _MenuItem(icon: Icons.event_available_outlined, label: 'Мои консультации', onTap: () => state.open(Screen.consult)),
        _MenuItem(icon: Icons.school_outlined, label: 'Мои курсы', trailing: '1', onTap: () => state.open(Screen.course)),
        _MenuItem(icon: Icons.workspace_premium_outlined, label: 'Портал+', trailing: 'пробный', onTap: () => state.open(Screen.plus)),
        _MenuItem(icon: Icons.notifications_none_rounded, label: 'Уведомления', onTap: () {}),
        const SizedBox(height: 8),
        NightCard(
          key: const Key('open-cabinet'),
          onTap: () => state.open(Screen.cabinet),
          accent: AppColors.glow,
          child: Row(
            children: [
              const Icon(Icons.swap_horiz_rounded, color: AppColors.glowLight),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Я эксперт', style: AppText.h3.copyWith(fontSize: 14)),
                    Text('Перейти в кабинет эксперта', style: AppText.small),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.star3),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Center(child: Text('Удалить аккаунт и данные', style: AppText.small.copyWith(decoration: TextDecoration.underline))),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.trailing});

  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.star2),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppText.h3.copyWith(fontSize: 14, fontWeight: FontWeight.w400))),
            if (trailing != null) Text(trailing!, style: AppText.small),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.star3, size: 20),
          ],
        ),
      ),
    );
  }
}

class CabinetScreen extends StatelessWidget {
  const CabinetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final e = experts[0];
    return Column(
      children: [
        TopBar(
          title: 'Кабинет эксперта',
          trailing: const Pill('режим эксперта', color: AppColors.glowLight),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              Row(
                children: [
                  Avatar(initials: e.initials, color: e.color, size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.name, style: AppText.h3),
                        Text('${e.role} · ★ ${e.rating}', style: AppText.small),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              NightCard(
                gradient: AppGradients.code,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ДОХОД ЗА СЕНТЯБРЬ', style: AppText.label.copyWith(color: AppColors.glowLight)),
                    const SizedBox(height: 4),
                    Text(rub(186400), style: AppText.hero.copyWith(fontSize: 30)),
                    const SizedBox(height: 4),
                    Text('после комиссии платформы · выплата 1 октября', style: AppText.small.copyWith(color: AppColors.star2)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _MiniStat(value: '41', label: 'консультация'),
                        _MiniStat(value: '63', label: 'на курсе'),
                        _MiniStat(value: '128', label: 'подписок'),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionLabel('Твоя аудитория'),
              NightCard(
                child: Column(
                  children: [
                    const _SourceRow(label: 'Пришли по твоей ссылке', value: 214, share: 0.62, color: AppColors.glow, note: 'комиссия 15%'),
                    const SizedBox(height: 12),
                    const _SourceRow(label: 'Привела платформа', value: 131, share: 0.38, color: AppColors.star3, note: 'комиссия 35%'),
                    const SizedBox(height: 12),
                    Tap(
                      onTap: () => showDemoSnack(context, 'Ссылка скопирована: portal.app/m/vetrova'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.night3, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.link_rounded, size: 18, color: AppColors.glowLight),
                            const SizedBox(width: 8),
                            Expanded(child: Text('portal.app/m/vetrova', style: AppText.p.copyWith(color: AppColors.star, fontSize: 13))),
                            Text('копировать', style: AppText.small.copyWith(color: AppColors.glowLight)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SectionLabel('Новые заявки', trailing: Pill('3', color: AppColors.glow, filled: true)),
              const _Request(name: 'Анна, 35', when: 'чт, 18 сент · 12:30', question: 'Смена работы: когда и куда двигаться', code: 'Рыбы ↑ Телец · Путь 1 · Генератор'),
              const _Request(name: 'Светлана, 42', when: 'пт, 19 сент · 19:00', question: 'Отношения с дочерью-подростком', code: 'Дева ↑ Скорпион · Путь 7 · Проектор'),
              const SizedBox(height: 10),
              GhostButton('Опубликовать курс или практику', icon: Icons.add_rounded, onTap: () => showDemoSnack(context, 'Конструктор курса откроется здесь')),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.h2),
          Text(label, style: AppText.small.copyWith(fontSize: 10.5)),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.label, required this.value, required this.share, required this.color, required this.note});

  final String label;
  final int value;
  final double share;
  final Color color;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppText.h3.copyWith(fontSize: 13))),
            Text('$value', style: AppText.h3.copyWith(fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ValueBar(value: share, color: color),
        const SizedBox(height: 4),
        Text(note, style: AppText.small.copyWith(fontSize: 10.5)),
      ],
    );
  }
}

class _Request extends StatelessWidget {
  const _Request({required this.name, required this.when, required this.question, required this.code});

  final String name;
  final String when;
  final String question;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NightCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: AppText.h3.copyWith(fontSize: 14))),
                Text(when, style: AppText.small.copyWith(color: AppColors.glowLight)),
              ],
            ),
            const SizedBox(height: 4),
            Text('«$question»', style: AppText.p.copyWith(fontSize: 12.5, color: AppColors.star)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 13, color: AppColors.gold),
                const SizedBox(width: 6),
                Expanded(child: Text(code, style: AppText.small.copyWith(color: AppColors.gold))),
                Text('карта →', style: AppText.small.copyWith(color: AppColors.star2)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
