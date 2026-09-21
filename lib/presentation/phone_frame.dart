import 'package:flutter/material.dart';

import '../app/entry_screens.dart';
import '../app/ops_screens.dart';
import '../app/product_screens.dart';
import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';

/// Дизайн-размер «телефона»; снаружи масштабируется FittedBox'ом.
const phoneSize = Size(390, 812);

/// Рамка телефона для широкого экрана: корпус, статус-бар и приложение.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: phoneSize.width,
      height: phoneSize.height,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B3A),
        borderRadius: BorderRadius.circular(48),
        boxShadow: const [
          BoxShadow(color: Color(0x5512123A), blurRadius: 50, offset: Offset(0, 22)),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: AppViewport(statusBar: true),
      ),
    );
  }
}

/// Режим без рамки телефона — для admin и next: это не приложение на экране
/// человека, а панель, которая работает в браузере. Форма окна вместо формы
/// телефона, но палитра и компоненты внутри те же.
class PanelFrame extends StatelessWidget {
  const PanelFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: AppColors.nightLine)),
        child: const AppViewport(),
      ),
    );
  }
}

/// Само приложение без корпуса. На телефоне показывается во весь экран:
/// рамка внутри настоящего телефона только отнимает место.
class AppViewport extends StatelessWidget {
  const AppViewport({super.key, this.statusBar = false});

  final bool statusBar;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.nightSky),
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          // Без const: экраны читают состояние напрямую, и константный
          // экземпляр Flutter не перестроил бы при его изменении.
          final content = switch (state.screen) {
            Screen.landing => LandingScreen(),
            Screen.survey => SurveyScreen(),
            Screen.code => CodeScreen(),
            Screen.auth => AuthScreen(),
            Screen.today => TodayScreen(),
            Screen.reading => ReadingScreen(),
            Screen.chat => ChatScreen(),
            Screen.plus => PlusScreen(),
            Screen.invite => InviteScreen(),
            Screen.push => PushScreen(),
            Screen.admin => AdminScreen(),
            Screen.next => NextScreen(),
          };
          final tab = state.tab;
          return ScaffoldMessenger(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  if (statusBar) const _StatusBar() else const SizedBox(height: 6),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: KeyedSubtree(key: ValueKey(state.screen), child: content),
                    ),
                  ),
                  if (tab != null) _TabBar(current: tab, bottomInset: statusBar ? 20 : 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 24, 6),
      child: Row(
        children: [
          const Text('9:41', style: TextStyle(fontSize: 13, color: AppColors.star, fontWeight: FontWeight.w700)),
          const Spacer(),
          Container(
            width: 100,
            height: 26,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
          ),
          const Spacer(),
          const Icon(Icons.signal_cellular_alt_rounded, size: 14, color: AppColors.star),
          const SizedBox(width: 4),
          const Icon(Icons.battery_full_rounded, size: 16, color: AppColors.star),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.current, required this.bottomInset});

  final AppTab current;
  final double bottomInset;

  static const _items = [
    (AppTab.today, Screen.today, Icons.wb_twilight_rounded, 'Сегодня'),
    (AppTab.reading, Screen.reading, Icons.menu_book_outlined, 'Расшифровка'),
    (AppTab.chat, Screen.chat, Icons.chat_bubble_outline_rounded, 'Чат'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, bottomInset),
      decoration: BoxDecoration(
        color: AppColors.night.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: AppColors.nightLine)),
      ),
      child: Row(
        children: [
          for (final (tab, screen, icon, label) in _items)
            Expanded(
              child: Tap(
                key: Key('tab-${tab.name}'),
                onTap: () => AppState.instance.open(screen),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 23, color: tab == current ? AppColors.glowLight : AppColors.star3),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        color: tab == current ? AppColors.star : AppColors.star3,
                        fontWeight: tab == current ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
