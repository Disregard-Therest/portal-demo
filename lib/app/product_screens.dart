import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

const _months = [
  'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
];
const _weekdays = ['понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье'];

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final now = DateTime.now();
    final month = Demo.personalMonth(now);
    final word = personalNumberWord[month] ?? 'фокус';
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
            const Avatar(initials: 'А', color: AppColors.glow, size: 40),
          ],
        ),
        const SizedBox(height: 16),
        NightCard(
          gradient: AppGradients.premium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Pill('МЕСЯЦ КЛУБА', color: AppColors.gold),
              const SizedBox(height: 8),
              Text('Деньги', style: AppText.hero.copyWith(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                'Тема месяца одна для всего клуба — про неё эфир эксперта в конце месяца.',
                style: AppText.p.copyWith(color: AppColors.star),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NightCard(
          accent: AppColors.numero,
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.numero.withValues(alpha: 0.16), shape: BoxShape.circle),
                child: Text('$month', style: AppText.h2.copyWith(color: AppColors.numero, fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ТВОЙ ЛИЧНЫЙ МЕСЯЦ', style: AppText.label.copyWith(color: AppColors.numero)),
                    const SizedBox(height: 2),
                    Text('У тебя личный месяц $month — $word', style: AppText.h3.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SectionLabel('Задание дня'),
        NightCard(
          key: const Key('daily-task'),
          onTap: () => state.update(() => state.taskDone = !state.taskDone),
          accent: state.taskDone ? AppColors.good : null,
          child: Row(
            children: [
              Icon(
                state.taskDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: state.taskDone ? AppColors.good : AppColors.star3,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Три траты без радости', style: AppText.h3.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Выпиши три траты за месяц, которые не приносят радости — без анализа, просто список.', style: AppText.small),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Pill(state.taskDone ? 'готово' : 'отметить', color: state.taskDone ? AppColors.good : AppColors.glow, filled: state.taskDone),
            ],
          ),
        ),
        const SectionLabel('Карта дня · Ба Цзы'),
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
              Text('День Огненной Лошади', style: AppText.h2.copyWith(fontSize: 17)),
              const SizedBox(height: 6),
              Text(
                'Для тебя, Металлической Козы, это день напора. Хорошо для переговоров и спорта; '
                'крупные покупки лучше отложить до завтра.',
                style: AppText.p.copyWith(color: AppColors.star),
              ),
              const SizedBox(height: 10),
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
        const SectionLabel('Серия дней'),
        const _StreakStrip(days: 6),
      ],
    );
  }
}

class _StreakStrip extends StatelessWidget {
  const _StreakStrip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return NightCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Серия: $days дней подряд', style: AppText.h3.copyWith(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (var i = 0; i < 7; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < days ? AppColors.glow : Colors.transparent,
                            border: Border.all(color: i < days ? AppColors.glow : AppColors.nightLine),
                          ),
                          child: i < days ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    void unlock() => state.open(Screen.plus);
    return Column(
      children: [
        const TopBar(title: 'Твоя расшифровка'),
        Expanded(
          child: ScreenBody(
            children: [
              const SectionLabel('Открыто'),
              const _OpenSection(
                title: 'Число пути 1 — как ты действуешь',
                text: 'Ты запускаешь то, на что другие не решаются, и быстро берёшь ответственность. '
                    'Обратная сторона — тебе трудно просить о помощи и ждать чужого темпа.',
              ),
              const _OpenSection(
                title: 'Личный год — на чём фокус сейчас',
                text: 'Год завершения не про начало нового, а про то, чтобы закрыть хвосты и отпустить '
                    'то, что уже отжило. Прожитый честно, он освобождает место под следующий цикл.',
              ),
              const SectionLabel('В подписке'),
              LockedRow('Личный месяц — как меняется фокус внутри года', subtitle: '12 текстов на год', onTap: unlock),
              LockedRow('Аркан личности — твой архетип', subtitle: '3 страницы', onTap: unlock),
              LockedRow('Сильные и слабые числа в дате', subtitle: 'интерактивная таблица', onTap: unlock),
              LockedRow('План на год по личным месяцам', subtitle: '12 разворотов', onTap: unlock),
              const SizedBox(height: 8),
              PrimaryButton('Открыть полностью · Портал+', onTap: unlock, gold: true),
            ],
          ),
        ),
      ],
    );
  }
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

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final answered = state.chatAnswered;
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
                    Text('знает твой код и твой запрос', style: AppText.small),
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
                text: 'Привет, Анна. Я знаю твой код и то, что для тебя сейчас важно. '
                    'Спроси о любой ситуации — отвечу с опорой на твои числа.',
              ),
              for (var i = 0; i < answered; i++) ...[
                _Bubble(mine: true, text: chatExchanges[i].question),
                _Bubble(mine: false, text: chatExchanges[i].answer),
              ],
              if (answered < chatExchanges.length) ...[
                const SizedBox(height: 6),
                Text('ПОПРОБУЙ СПРОСИТЬ', style: AppText.label),
                const SizedBox(height: 8),
                for (var i = answered; i < chatExchanges.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Tap(
                      key: Key('chat-q-$i'),
                      onTap: i == answered ? () => state.update(() => state.chatAnswered++) : () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: i == answered ? AppColors.glow : AppColors.nightLine),
                        ),
                        child: Text(
                          chatExchanges[i].question,
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
                  left > 0 ? 'Осталось $left из 3 вопросов на этой неделе · безлимит в Портал+' : 'Вопросы на этой неделе закончились · безлимит в Портал+',
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
  const _Bubble({required this.mine, required this.text});

  final bool mine;
  final String text;

  @override
  Widget build(BuildContext context) {
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
        child: Text(text, style: AppText.p.copyWith(color: AppColors.star, fontSize: 13)),
      ),
    );
  }
}

class PlusScreen extends StatelessWidget {
  const PlusScreen({super.key});

  static const _features = [
    (Icons.auto_awesome, 'Полная расшифровка: месяцы, аркан, план на год'),
    (Icons.forum_outlined, 'Проводник без лимита вопросов'),
    (Icons.notifications_active_outlined, 'Персональные пуши каждый день'),
    (Icons.calendar_month_outlined, 'Все задания месяца, а не только сегодняшнее'),
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
                    price: '790 ₽',
                    note: 'в месяц',
                    selected: state.plan == 0,
                    onTap: () => state.update(() => state.plan = 0),
                  ),
                  _Plan(
                    key: const Key('plan-1'),
                    title: 'Год',
                    price: '5 990 ₽',
                    note: '499 ₽ в месяц · выгода 37%',
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
                    '7 дней бесплатно',
                    gold: true,
                    onTap: () {
                      showDemoSnack(context, 'Портал+ подключён');
                      state.back();
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Оплата по СБП или картой · отмена в любой момент', style: AppText.small.copyWith(color: AppColors.star2, fontSize: 10.5)),
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
