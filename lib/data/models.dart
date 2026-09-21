/// Экран внутри телефона. Один экран — один шаг презентации.
enum Screen {
  landing,
  survey,
  code,
  auth,
  today,
  reading,
  chat,
  plus,
  invite,
  push,
  admin,
  next,
}

/// Вкладки нижнего меню приложения.
enum AppTab { today, reading, chat }

/// Этап пути пользователя — ряд бейджей в шапке презентации.
enum Stage { entry, product, ops }

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

/// Вопрос-ответ в чате с ИИ-проводником.
class ChatExchange {
  const ChatExchange({required this.question, required this.answer});

  final String question;
  final String answer;
}
