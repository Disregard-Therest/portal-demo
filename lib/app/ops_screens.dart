import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

String _rub(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
    b.write(s[i]);
  }
  return '$b ₽';
}

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(title: 'Приглашения'),
        Expanded(
          child: ScreenBody(
            children: [
              Row(
                children: [
                  const Avatar(initials: 'МВ', color: AppColors.numero, size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Марина Ветрова', style: AppText.h3),
                        Text('нумеролог · режим эксперта', style: AppText.small),
                      ],
                    ),
                  ),
                ],
              ),
              const SectionLabel('Твоя ссылка'),
              NightCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.link_rounded, size: 18, color: AppColors.glowLight),
                        const SizedBox(width: 8),
                        Expanded(child: Text('portal.app/m/vetrova', style: AppText.p.copyWith(color: AppColors.star, fontSize: 13))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.sell_outlined, size: 18, color: AppColors.gold),
                        const SizedBox(width: 8),
                        Text('Промокод VETROVA10', style: AppText.p.copyWith(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      'Скопировать ссылку',
                      icon: Icons.copy_rounded,
                      onTap: () => showDemoSnack(context, 'Ссылка скопирована: portal.app/m/vetrova'),
                    ),
                  ],
                ),
              ),
              const SectionLabel('С сентября'),
              Row(
                children: const [
                  _Counter(value: '184', label: 'перешли'),
                  SizedBox(width: 10),
                  _Counter(value: '96', label: 'завели профиль'),
                  SizedBox(width: 10),
                  _Counter(value: '31', label: 'оплатили'),
                ],
              ),
              const SizedBox(height: 12),
              NightCard(
                gradient: AppGradients.code,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('НАЧИСЛЕНО ЗА СЕНТЯБРЬ', style: AppText.label.copyWith(color: AppColors.glowLight)),
                    const SizedBox(height: 4),
                    Text(_rub(42800), style: AppText.hero.copyWith(fontSize: 30)),
                    const SizedBox(height: 4),
                    Text('процент с покупок приглашённых · выплата вручную, раз в месяц', style: AppText.small.copyWith(color: AppColors.star2)),
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

class _Counter extends StatelessWidget {
  const _Counter({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: AppColors.night2, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value, style: AppText.h2),
            Text(label, style: AppText.small.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  static const _times = ['08:00', '09:00', '12:00', '20:00', '21:00'];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      children: [
        const TopBar(title: 'Уведомления'),
        Expanded(
          child: ScreenBody(
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0B0C55), Color(0xFF000038)],
                      ),
                    ),
                    child: const StarField(density: 40),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    top: 14,
                    child: Column(
                      children: [
                        const _PushBanner(title: 'Задание дня готово', text: 'Выпиши три траты за месяц — 2 минуты'),
                        const SizedBox(height: 8),
                        const _PushBanner(title: 'Ты на 6 дне подряд', text: 'Не разрывай серию — загляни на минуту'),
                      ],
                    ),
                  ),
                ],
              ),
              const SectionLabel('Время напоминания'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _times.length; i++)
                    Tap(
                      key: Key('push-time-$i'),
                      onTap: () => state.update(() => state.pushTimeIndex = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: state.pushTimeIndex == i ? AppColors.glow : AppColors.night2,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: state.pushTimeIndex == i ? AppColors.glow : AppColors.nightLine),
                        ),
                        child: Text(_times[i], style: const TextStyle(color: AppColors.star, fontSize: 13.5, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Одно уведомление в день — своё время выбирает каждый.', style: AppText.small),
            ],
          ),
        ),
      ],
    );
  }
}

class _PushBanner extends StatelessWidget {
  const _PushBanner({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppColors.glowLight, AppColors.glow])),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Портал', style: AppText.small.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Text('сейчас', style: AppText.small.copyWith(color: Colors.white70, fontSize: 10)),
                  ],
                ),
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Разделы админки: статичная навигация, «Задания месяца» выбран по умолчанию.
const _adminSections = [
  ('Задания месяца', Icons.event_note_outlined, true),
  ('Тексты расшифровок', Icons.menu_book_outlined, false),
  ('Пользователи', Icons.people_outline_rounded, false),
  ('Платежи', Icons.payments_outlined, false),
  ('Промокоды', Icons.sell_outlined, false),
];

const _monthTasks = [
  (1, 'Выпиши три траты без радости', 'опубликовано'),
  (2, 'Назови одну сделку, которую откладываешь', 'опубликовано'),
  (3, 'Проверь три подписки, которыми не пользуешься', 'опубликовано'),
  (4, 'Договорись об оплате, которую переносишь', 'черновик'),
  (5, 'Запиши источник дохода, который хочешь усилить', 'черновик'),
];

/// Админка — не телефон, а широкая панель, поэтому её содержимое реагирует
/// на ширину само: колонкой на телефоне, двумя колонками на широком экране.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: LayoutBuilder(
        builder: (context, c) {
          final sections = _SectionsNav(wide: c.maxWidth >= 640);
          final table = const _TasksTable();
          if (c.maxWidth >= 640) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 210, child: sections),
                const SizedBox(width: 20),
                Expanded(child: SingleChildScrollView(child: table)),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [sections, const SizedBox(height: 16), table],
            ),
          );
        },
      ),
    );
  }
}

class _SectionsNav extends StatelessWidget {
  const _SectionsNav({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Портал · Админка', style: AppText.h2.copyWith(fontSize: 18)),
        const SizedBox(height: 14),
        for (final (label, icon, selected) in _adminSections)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: selected ? AppColors.glow.withValues(alpha: 0.18) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: selected ? AppColors.glow : Colors.transparent),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: selected ? AppColors.glowLight : AppColors.star2),
                  const SizedBox(width: 10),
                  Text(label, style: AppText.h3.copyWith(fontSize: 13.5, color: selected ? AppColors.star : AppColors.star2)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TasksTable extends StatelessWidget {
  const _TasksTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Задания месяца · сентябрь', style: AppText.h2.copyWith(fontSize: 18))),
            SizedBox(
              width: 150,
              child: PrimaryButton(
                'Добавить',
                icon: Icons.add_rounded,
                onTap: () => showDemoSnack(context, 'Новое задание добавлено в черновики'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final (day, text, status) in _monthTasks)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: NightCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text('$day', style: AppText.h3.copyWith(fontSize: 13, color: AppColors.star2)),
                  ),
                  Expanded(child: Text(text, style: AppText.h3.copyWith(fontSize: 13.5, fontWeight: FontWeight.w400))),
                  Pill(status, color: status == 'опубликовано' ? AppColors.good : AppColors.star3),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

const _nextSteps = [
  ('Публикация в магазинах и платежи в них', 'RuStore, App Store, Google Play — и приём оплаты через них.'),
  ('Дополнительные расшифровки, задания и контент', 'Больше текстов и заданий сверх того, что вошло в первую версию.'),
  ('Эфиры внутри приложения', 'Живые эфиры экспертов по теме месяца, без ухода в сторонние сервисы.'),
  ('Учебные продукты и покупки внутри', 'Курсы и разовые продукты экспертов прямо в приложении.'),
  ('Кабинет партнёра', 'Полноценный кабинет вместо одной страницы с цифрами и выгрузкой.'),
];

/// «Что дальше» — тоже панель, а не телефон: список карточек в порядке очереди.
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Портал · Что дальше', style: AppText.h2.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text('Порядок очереди, а не обещание сроков', style: AppText.p),
            const SizedBox(height: 16),
            for (var i = 0; i < _nextSteps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NightCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.glow.withValues(alpha: 0.18), shape: BoxShape.circle),
                        child: Text('${i + 1}', style: AppText.h3.copyWith(color: AppColors.glowLight)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_nextSteps[i].$1, style: AppText.h3.copyWith(fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(_nextSteps[i].$2, style: AppText.p.copyWith(fontSize: 12.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
