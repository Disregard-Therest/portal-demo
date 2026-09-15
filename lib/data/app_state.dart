import 'package:flutter/foundation.dart';

import 'demo_steps.dart';
import 'models.dart';

/// Состояние демо. Канонично только оно: номер шага презентации
/// вычисляется из экрана, поэтому панель пояснений не может разойтись
/// с тем, что показано в телефоне, куда бы ни ткнул человек.
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  Screen _screen = Screen.welcome;
  Screen get screen => _screen;

  /// Откуда открыли «Портал+» — туда и вернёт крестик.
  Screen _plusReturn = Screen.today;

  final Set<String> intents = {};
  bool cardRevealed = false;
  bool partnerAdded = false;
  bool timeUnknown = false;
  int guideAnswered = 0;
  String methodFilter = '';
  int expertIndex = 0;
  int? slot;
  int format = 0;
  bool booked = false;
  int plan = 1;
  final Set<int> lessonsDone = {0, 1};
  bool remindersOn = true;

  int get stepIndex => demoSteps.indexWhere((s) => s.screen == _screen);
  DemoStep get step => demoSteps[stepIndex];

  void open(Screen screen) {
    if (screen == Screen.plus && _screen != Screen.plus) _plusReturn = _screen;
    _screen = screen;
    notifyListeners();
  }

  void goToStep(int index) {
    final i = index.clamp(0, demoSteps.length - 1);
    // Шаги можно открывать в любом порядке, поэтому экран, требующий
    // выбора из прошлого шага, получает разумное значение сам.
    if (demoSteps[i].screen.index > Screen.intent.index && intents.isEmpty) {
      intents.addAll(['Отношения', 'Предназначение']);
    }
    if (demoSteps[i].screen == Screen.plus) _plusReturn = Screen.reading;
    _screen = demoSteps[i].screen;
    notifyListeners();
  }

  void nextStep() => goToStep(stepIndex + 1);
  void prevStep() => goToStep(stepIndex - 1);

  /// Куда ведёт «назад» внутри телефона.
  void back() {
    open(switch (_screen) {
      Screen.intent => Screen.welcome,
      Screen.birth => Screen.intent,
      Screen.code => Screen.birth,
      Screen.save => Screen.code,
      Screen.reading || Screen.match => Screen.methods,
      Screen.calendar => Screen.today,
      Screen.expert => Screen.experts,
      Screen.course || Screen.consult => Screen.expert,
      Screen.plus => _plusReturn,
      Screen.cabinet => Screen.profile,
      _ => Screen.today,
    });
  }

  /// Вкладка нижнего меню, к которой относится экран; null — меню скрыто.
  AppTab? get tab => switch (_screen) {
        Screen.today || Screen.calendar => AppTab.today,
        Screen.methods || Screen.reading || Screen.match => AppTab.methods,
        Screen.guide => AppTab.guide,
        Screen.experts || Screen.expert || Screen.course || Screen.consult => AppTab.experts,
        Screen.profile => AppTab.profile,
        _ => null,
      };

  void toggleIntent(String value) {
    intents.contains(value) ? intents.remove(value) : intents.add(value);
    notifyListeners();
  }

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }

  /// Сброс для тестов.
  @visibleForTesting
  void reset() {
    _screen = Screen.welcome;
    intents.clear();
    cardRevealed = false;
    partnerAdded = false;
    timeUnknown = false;
    guideAnswered = 0;
    methodFilter = '';
    expertIndex = 0;
    slot = null;
    format = 0;
    booked = false;
    plan = 1;
    lessonsDone
      ..clear()
      ..addAll({0, 1});
    remindersOn = true;
    notifyListeners();
  }
}
