import 'package:flutter/material.dart';

/// Две палитры в одном файле, и они разной природы.
///
/// Внутри телефона — ночная тема старого «Портала»: глубокий синий `#000038`
/// и светящийся голубой шар логотипа. Это и есть преемственность, которую
/// показываем Наталье. Снаружи, в панели пояснений, — светлая страница:
/// там читают длинный текст, и тёмный фон бы утомлял.
abstract final class AppColors {
  // ── Страница презентации (светлая) ───────────────────────────────────────
  static const page = Color(0xFFECEDF6);
  static const card = Color(0xFFFFFFFF);
  static const line = Color(0xFFDADCEC);
  static const ink = Color(0xFF12123A);
  static const ink2 = Color(0xFF474A6E);
  static const muted = Color(0xFF8588A6);
  static const accent = Color(0xFF2D5BFF);
  static const accentDeep = Color(0xFF1B3BB8);
  static const accentSoft = Color(0xFFE4EAFF);

  // Этапы в навигации презентации: цвет всегда вместе с подписью.
  static const stage1 = Color(0xFF2D5BFF);
  static const stage2 = Color(0xFF7B3FE4);
  static const stage3 = Color(0xFFD9467E);

  // ── Телефон (ночная тема «Портала») ──────────────────────────────────────
  static const night = Color(0xFF000038); // фирменный фон старого приложения
  static const night2 = Color(0xFF0A0B4A); // карточка
  static const night3 = Color(0xFF15175C); // карточка поверх карточки
  static const nightLine = Color(0xFF26297A);
  static const star = Color(0xFFF3F4FF); // основной текст
  static const star2 = Color(0xFFB4B7E6); // вторичный текст
  static const star3 = Color(0xFF7C80C0); // подписи

  /// Голубое свечение шара из логотипа — главный акцент действий.
  static const glow = Color(0xFF3D7BFF);
  static const glowLight = Color(0xFF8FD8FF);
  static const gold = Color(0xFFFFCF7A); // платное и «премиум»

  // ── Цвета методик: рубрики старого приложения, осветлённые под тёмный фон ─
  static const astro = Color(0xFF4D86FF); // был blueRibbon #0057FF
  static const numero = Color(0xFFEE86BB); // mauvelous — без изменений
  static const hd = Color(0xFF4FC0CF); // hippieBlue #46A0AD, светлее
  static const matrix = Color(0xFFC46BFF); // electricViolet #DB00FF, мягче
  static const tarot = Color(0xFF2ED6EE); // pictonBlue — без изменений
  static const bazi = Color(0xFFFF7A52); // pomegranate #ED3E13, светлее

  static const good = Color(0xFF5BE3A6);
}

abstract final class AppGradients {
  static const cta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2D5BFF), Color(0xFF3FA8FF)],
  );

  static const nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0B0C55), Color(0xFF000038)],
  );

  static const premium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3A2A8C), Color(0xFF7A3FC4), Color(0xFFC0628F)],
  );

  static const code = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B2BB0), Color(0xFF4B2FA8), Color(0xFF0A0B4A)],
  );
}

abstract final class AppText {
  // ── Страница презентации ─────────────────────────────────────────────────
  static const display = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    height: 1.18,
    letterSpacing: -0.4,
  );
  static const eyebrow = TextStyle(
    fontSize: 10,
    letterSpacing: 1.1,
    fontWeight: FontWeight.w600,
    color: AppColors.accentDeep,
  );
  static const body = TextStyle(fontSize: 14, height: 1.5, color: AppColors.ink);
  static const muted = TextStyle(fontSize: 12, height: 1.45, color: AppColors.muted);

  // ── Внутри телефона ──────────────────────────────────────────────────────
  static const hero = TextStyle(
    fontFamily: 'Playfair',
    fontWeight: FontWeight.w600,
    color: AppColors.star,
    fontSize: 28,
    height: 1.15,
  );
  static const h2 = TextStyle(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w800,
    color: AppColors.star,
    fontSize: 19,
    height: 1.2,
    letterSpacing: -0.2,
  );
  static const h3 = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.star,
    fontSize: 15,
    height: 1.3,
  );
  static const p = TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.star2);
  static const small = TextStyle(fontSize: 11.5, height: 1.4, color: AppColors.star3);
  static const label = TextStyle(
    fontSize: 10,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.star3,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Manrope',
    scaffoldBackgroundColor: AppColors.page,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
    splashFactory: InkRipple.splashFactory,
  );
  return base.copyWith(
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.night3,
      contentTextStyle: TextStyle(color: AppColors.star, fontSize: 13),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
