import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'astro_math.dart';
import 'models.dart';

/// Пользователь-пример. Цифры, помеченные в [AstroMath], посчитаны из даты;
/// остальное вписано руками и в панели так и названо.
abstract final class Demo {
  static const appName = 'Портал';
  static const name = 'Анна';
  static final birth = DateTime(1991, 3, 14);
  static const birthLabel = '14 марта 1991';
  static const birthTime = '07:40';
  static const birthPlace = 'Екатеринбург';

  static String get sun => AstroMath.sunSign(birth);
  static const ascendant = 'Телец';
  static int get lifePath => AstroMath.lifePath(birth);
  static int get arcana => AstroMath.personalArcana(birth);
  static String get chinese => AstroMath.chineseYear(birth);
  static const hdType = 'Генератор';
  static const hdProfile = '2/4';

  static const partnerName = 'Максим';
  static const partnerBirth = '22 июля 1989';

  static const points = 1250;
  static const referralCode = 'ANNA-7K2';
}

const intents = [
  'Отношения',
  'Деньги и дело',
  'Предназначение',
  'Энергия и здоровье',
  'Семья и дети',
  'Просто узнать себя',
];

final methods = [
  Method(
    id: 'astro',
    name: 'Астрология',
    color: AppColors.astro,
    icon: Icons.brightness_3_rounded,
    answers: 'Характер, сценарии и циклы жизни',
    result: 'Солнце в знаке ${Demo.sun} · асцендент ${Demo.ascendant}',
    needs: 'дата · время · место',
  ),
  Method(
    id: 'numero',
    name: 'Нумерология',
    color: AppColors.numero,
    icon: Icons.tag_rounded,
    answers: 'Задачи, таланты и личные годы',
    result: 'Число пути ${Demo.lifePath}',
    needs: 'дата',
  ),
  const Method(
    id: 'hd',
    name: 'Human Design',
    color: AppColors.hd,
    icon: Icons.hexagon_outlined,
    answers: 'Как принимать решения и тратить энергию',
    result: '${Demo.hdType} · профиль ${Demo.hdProfile}',
    needs: 'дата · время · место',
  ),
  Method(
    id: 'matrix',
    name: 'Матрица судьбы',
    color: AppColors.matrix,
    icon: Icons.auto_awesome_mosaic_rounded,
    answers: 'Кармические задачи и ресурсы',
    result: 'Аркан личности ${Demo.arcana} · Умеренность',
    needs: 'дата',
  ),
  Method(
    id: 'bazi',
    name: 'Ба Цзы',
    color: AppColors.bazi,
    icon: Icons.local_fire_department_outlined,
    answers: 'Стихии, удачные периоды, фэн-шуй дня',
    result: Demo.chinese,
    needs: 'дата · время',
  ),
  const Method(
    id: 'tarot',
    name: 'Таро и карты',
    color: AppColors.tarot,
    icon: Icons.style_outlined,
    answers: 'Вопрос здесь и сейчас',
    result: 'Расклад на вопрос',
    needs: 'ничего',
  ),
];

Method methodById(String id) => methods.firstWhere((m) => m.id == id);

const experts = [
  Expert(
    name: 'Марина Ветрова',
    role: 'Астролог',
    methodIds: ['astro'],
    rating: 4.9,
    reviews: 312,
    price: 4500,
    initials: 'МВ',
    color: AppColors.astro,
    years: 12,
    students: 2140,
  ),
  Expert(
    name: 'Алексей Ким',
    role: 'Ба Цзы и фэн-шуй',
    methodIds: ['bazi'],
    rating: 4.8,
    reviews: 187,
    price: 6000,
    initials: 'АК',
    color: AppColors.bazi,
    years: 9,
    students: 960,
  ),
  Expert(
    name: 'Ольга Лучезарная',
    role: 'Нумерология · Матрица судьбы',
    methodIds: ['numero', 'matrix'],
    rating: 4.9,
    reviews: 541,
    price: 3000,
    initials: 'ОЛ',
    color: AppColors.numero,
    years: 7,
    students: 3870,
  ),
  Expert(
    name: 'Дана Смирнова',
    role: 'Аналитик Human Design',
    methodIds: ['hd'],
    rating: 4.7,
    reviews: 96,
    price: 5000,
    initials: 'ДС',
    color: AppColors.hd,
    years: 5,
    students: 610,
  ),
  Expert(
    name: 'Вера Нордман',
    role: 'Таро и метафорические карты',
    methodIds: ['tarot'],
    rating: 4.8,
    reviews: 228,
    price: 2500,
    initials: 'ВН',
    color: AppColors.tarot,
    years: 10,
    students: 1320,
  ),
];

const guideSuggestions = [
  ChatExchange(
    question: 'Почему мне так тяжело даются решения?',
    answer:
        'У тебя в Human Design эмоциональный авторитет: ясность приходит не в моменте, '
        'а после волны. Решение, принятое «на пике», ты часто потом отменяешь. '
        'Попробуй правило одной ночи: важное — только на следующий день.\n\n'
        'Это же видно и в числе пути 1 — ты привыкла решать быстро и сама, '
        'поэтому пауза ощущается как слабость. Это не слабость, это твоя стратегия.',
    expertHint: 'Дана Смирнова разбирает авторитет на консультации',
  ),
  ChatExchange(
    question: 'Когда лучше менять работу?',
    answer:
        'У тебя 2026-й — личный год 9, год завершения: хорошо закрывать старое, '
        'хуже — начинать с нуля. Новый цикл откроется в 2027-м.\n\n'
        'Если решение уже созрело, самые благоприятные окна до конца года — '
        'первая половина октября и конец ноября. Их можно добавить в календарь.',
    expertHint: 'Марина Ветрова построит прогноз по транзитам на год',
  ),
  ChatExchange(
    question: 'Подходим ли мы с Максимом друг другу?',
    answer:
        'По тому, что видно из двух дат, у вас сильная эмоциональная связь '
        'и разный темп: ты действуешь, он чувствует. Главное трение — в быту и планах.\n\n'
        'Полный разбор пары откроется, когда Максим примет приглашение: '
        'для точной совместимости нужно его время рождения.',
  ),
];
