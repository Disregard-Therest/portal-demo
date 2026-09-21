import 'package:flutter/foundation.dart';

import 'demo_steps.dart';
import 'mock_content.dart';
import 'models.dart';

/// Состояние демо. Канонично только оно: номер шага презентации
/// вычисляется из экрана, поэтому панель пояснений не может разойтись
/// с тем, что показано в телефоне, куда бы ни ткнул человек.
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  Screen _screen = Screen.landing;
  Screen get screen => _screen;

  /// Откуда открыли «Портал+» — туда и вернёт крестик.
  Screen _plusReturn = Screen.today;

  /// Запрос, выбранный на входной анкете. Null — ещё не выбран.
  String? request;
  bool timeUnknown = false;

  /// Вход по номеру: код запрошен и поле SMS-кода показано.
  bool codeSent = false;

  /// Отметка задания дня на главной.
  bool taskDone = false;

  /// Сколько из трёх бесплатных вопросов в неделю уже задано в чате.
  /// Один пример ответа показан сразу, поэтому старт не с нуля.
  int chatAnswered = 1;

  /// Тариф на экране подписки: 0 — месяц, 1 — год.
  int plan = 1;

  /// Выбранное время ежедневного пуша — индекс в списке времени экрана.
  int pushTimeIndex = 0;

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
    // выбора из анкеты, получает разумное значение сам.
    if (demoSteps[i].screen.index > Screen.survey.index && request == null) {
      request = requestOptions.first.$1;
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
      Screen.survey => Screen.landing,
      Screen.code => Screen.survey,
      Screen.auth => Screen.code,
      Screen.reading || Screen.chat => Screen.today,
      Screen.plus => _plusReturn,
      Screen.invite || Screen.push => Screen.today,
      _ => Screen.today,
    });
  }

  /// Вкладка нижнего меню, к которой относится экран; null — меню скрыто.
  AppTab? get tab => switch (_screen) {
        Screen.today => AppTab.today,
        Screen.reading => AppTab.reading,
        Screen.chat => AppTab.chat,
        _ => null,
      };

  void selectRequest(String value) {
    request = value;
    notifyListeners();
  }

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }

  /// Сброс для тестов.
  @visibleForTesting
  void reset() {
    _screen = Screen.landing;
    request = null;
    timeUnknown = false;
    codeSent = false;
    taskDone = false;
    chatAnswered = 1;
    plan = 1;
    pushTimeIndex = 0;
    notifyListeners();
  }
}
