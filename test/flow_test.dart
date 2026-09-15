import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portal_demo/data/app_state.dart';
import 'package:portal_demo/data/astro_math.dart';
import 'package:portal_demo/data/demo_steps.dart';
import 'package:portal_demo/data/mock_content.dart';
import 'package:portal_demo/data/models.dart';
import 'package:portal_demo/main.dart';
import 'package:portal_demo/presentation/phone_frame.dart';
import 'package:portal_demo/widgets/ui_kit.dart';

/// Настоящие шрифты вместо тестового: у тестового каждая буква — квадрат
/// шириной в кегль, и переполнения, которых в браузере нет, валили бы тест.
Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(Future.value(ByteData.sublistView(File(f).readAsBytesSync())));
    }
    await loader.load();
  }

  await load('Manrope', [
    'assets/fonts/manrope-v20-cyrillic_latin-regular.ttf',
    'assets/fonts/manrope-v20-cyrillic_latin-600.ttf',
    'assets/fonts/manrope-v20-cyrillic_latin-800.ttf',
  ]);
  await load('Playfair', ['assets/fonts/playfair-display-v40-cyrillic_latin-600.ttf']);
}

void main() {
  setUpAll(() async {
    Orb.pulse = false;
    await _loadFonts();
  });
  setUp(() => AppState.instance.reset());

  Future<void> pump(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    // Списки внутри телефона ленивые: кнопку внизу сначала надо докрутить.
    if (f.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        f,
        200,
        scrollable: find.descendant(of: find.byType(AppViewport), matching: find.byType(Scrollable)).first,
      );
    }
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  final state = AppState.instance;

  for (final (name, size) in [
    ('широкий экран', const Size(1600, 1000)),
    ('ноутбук', const Size(1280, 720)),
    ('телефон', const Size(390, 760)),
    ('маленький телефон', const Size(360, 640)),
  ]) {
    testWidgets('$name: все шаги рисуются без переполнений', (tester) async {
      await pump(tester, size);
      for (var i = 0; i < demoSteps.length; i++) {
        state.goToStep(i);
        await tester.pumpAndSettle();
        expect(state.stepIndex, i);
        expect(tester.takeException(), isNull, reason: 'шаг ${i + 1} · ${demoSteps[i].title}');
      }
    });
  }

  testWidgets('вход: без запроса дальше не пускает, дальше — код и главная', (tester) async {
    await pump(tester, const Size(1600, 1000));

    await tap(tester, find.text('Узнать свой код'));
    expect(state.screen, Screen.intent);
    expect(state.stepIndex, 1, reason: 'панель догоняет экран');

    await tap(tester, find.text('Дальше'));
    expect(state.screen, Screen.intent, reason: 'без выбранного запроса кнопка неактивна');

    await tap(tester, find.byKey(const Key('intent-0')));
    await tap(tester, find.text('Дальше'));
    expect(state.screen, Screen.birth);

    await tap(tester, find.byKey(const Key('time-unknown')));
    expect(find.textContaining('будут приблизительными'), findsOneWidget);

    await tap(tester, find.text('Рассчитать мой код'));
    expect(state.screen, Screen.code);
    await tap(tester, find.text('Сохранить мой код'));
    expect(state.screen, Screen.save);

    await tap(tester, find.text('Продолжить с Telegram'));
    expect(state.screen, Screen.today);
    expect(find.byKey(const Key('tab-today')), findsOneWidget, reason: 'после входа есть нижнее меню');
  });

  testWidgets('проводник отвечает по одному вопросу и считает лимит', (tester) async {
    await pump(tester, const Size(1600, 1000));
    state.goToStep(demoSteps.indexWhere((s) => s.screen == Screen.guide));
    await tester.pumpAndSettle();

    expect(find.textContaining('осталось 3 из 3'), findsOneWidget);
    await tap(tester, find.byKey(const Key('guide-q-0')));
    expect(state.guideAnswered, 1);
    expect(find.textContaining('осталось 2 из 3'), findsOneWidget);
  });

  testWidgets('консультация: без времени не оплатить, с временем — запись', (tester) async {
    await pump(tester, const Size(1600, 1000));
    state.goToStep(demoSteps.indexWhere((s) => s.screen == Screen.consult));
    await tester.pumpAndSettle();

    await tap(tester, find.text('Выбери время'));
    expect(state.booked, isFalse);

    await tap(tester, find.byKey(const Key('slot-1')));
    await tap(tester, find.text('Оплатить по СБП'));
    expect(state.booked, isTrue);
    expect(find.text('Ты записана'), findsOneWidget);
  });

  testWidgets('подписка закрывается туда, откуда открыта', (tester) async {
    await pump(tester, const Size(1600, 1000));
    state.goToStep(demoSteps.indexWhere((s) => s.screen == Screen.reading));
    await tester.pumpAndSettle();

    await tap(tester, find.text('Открыть расшифровку · 490 ₽'));
    expect(state.screen, Screen.plus);
    await tap(tester, find.byKey(const Key('plus-close')));
    expect(state.screen, Screen.reading);
  });

  testWidgets('телефон: список шагов и пояснения открываются слоями', (tester) async {
    await pump(tester, const Size(390, 760));

    await tap(tester, find.byKey(const Key('narrow-next')));
    expect(state.stepIndex, 1);

    await tap(tester, find.byKey(const Key('narrow-steps')));
    await tap(tester, find.byKey(const Key('narrow-step-11')));
    expect(state.screen, Screen.experts);

    await tap(tester, find.byKey(const Key('narrow-explain')));
    expect(find.text('ОБСУДИТЬ'), findsOneWidget);
    await tap(tester, find.text('Дальше →'));
    expect(state.screen, Screen.expert);
  });

  test('расчёты по дате примера', () {
    expect(AstroMath.sunSign(Demo.birth), 'Рыбы');
    expect(AstroMath.lifePath(Demo.birth), 1); // 1+4+3+1+9+9+1 = 28 → 10 → 1
    expect(AstroMath.personalArcana(Demo.birth), 14);
    expect(AstroMath.chineseYear(Demo.birth), 'Металл · Коза');
    expect(AstroMath.personalYear(Demo.birth, 2026), 9);
    expect(AstroMath.sunSign(DateTime(1989, 7, 22)), 'Рак');
    expect(AstroMath.sunSign(DateTime(2000, 1, 5)), 'Козерог');
    expect(AstroMath.personalArcana(DateTime(2000, 1, 29)), 7);
  });
}
