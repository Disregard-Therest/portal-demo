import 'package:flutter/material.dart';

/// Экран внутри телефона. Один экран — один шаг презентации.
enum Screen {
  welcome,
  intent,
  birth,
  code,
  save,
  today,
  methods,
  reading,
  match,
  guide,
  calendar,
  experts,
  expert,
  course,
  consult,
  plus,
  profile,
  cabinet,
}

/// Вкладки нижнего меню приложения.
enum AppTab { today, methods, guide, experts, profile }

/// Этап пути пользователя — ряд бейджей в шапке презентации.
enum Stage { entry, daily, money }

class DemoStep {
  const DemoStep({
    required this.title,
    required this.navLabel,
    required this.screen,
    required this.stage,
    required this.whatIs,
    required this.why,
    required this.whyThisWay,
    required this.discuss,
  });

  final String title;
  final String navLabel;
  final Screen screen;
  final Stage stage;

  /// «Что это» — роль экрана в пути человека, одной-двумя фразами.
  final String whatIs;

  /// «Зачем» — что экран даёт пользователю и продукту.
  final List<String> why;

  /// «Почему так, а не иначе» — решение и отвергнутая альтернатива.
  final List<String> whyThisWay;

  /// «Обсудить» — открытые вопросы; первый главный.
  final List<String> discuss;
}

class Method {
  const Method({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.answers,
    required this.result,
    required this.needs,
  });

  final String id;
  final String name;
  final Color color;
  final IconData icon;

  /// На какой вопрос человека отвечает система.
  final String answers;

  /// Результат пользователя-примера — короткой строкой.
  final String result;

  /// Какие данные рождения нужны.
  final String needs;
}

class Expert {
  const Expert({
    required this.name,
    required this.role,
    required this.methodIds,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.initials,
    required this.color,
    required this.years,
    required this.students,
  });

  final String name;
  final String role;
  final List<String> methodIds;
  final double rating;
  final int reviews;
  final int price;
  final String initials;
  final Color color;
  final int years;
  final int students;
}

class ChatExchange {
  const ChatExchange({required this.question, required this.answer, this.expertHint});

  final String question;
  final String answer;

  /// Подсказка «разобрать глубже с экспертом» под ответом.
  final String? expertHint;
}
