/// Расчёты, которые честно делаются из даты рождения без эфемерид.
///
/// Остальное в прототипе (асцендент, тип Human Design, столп дня Ба Цзы)
/// вписано руками: для них нужна точная астрономия и место рождения,
/// в продукте это сервер или внешнее API.
abstract final class AstroMath {
  static const _signs = [
    // (месяц, день начала) → знак; список по порядку года.
    (1, 20, 'Водолей'),
    (2, 19, 'Рыбы'),
    (3, 21, 'Овен'),
    (4, 20, 'Телец'),
    (5, 21, 'Близнецы'),
    (6, 21, 'Рак'),
    (7, 23, 'Лев'),
    (8, 23, 'Дева'),
    (9, 23, 'Весы'),
    (10, 23, 'Скорпион'),
    (11, 22, 'Стрелец'),
    (12, 22, 'Козерог'),
  ];

  static String sunSign(DateTime d) {
    var sign = 'Козерог';
    for (final (m, day, name) in _signs) {
      if (d.month > m || (d.month == m && d.day >= day)) sign = name;
    }
    return sign;
  }

  static int _digitSum(int n) => n.toString().split('').map(int.parse).fold(0, (a, b) => a + b);

  /// Сворачивает до одной цифры, мастер-числа 11 и 22 не трогает.
  static int _reduce(int n) {
    while (n > 9 && n != 11 && n != 22) {
      n = _digitSum(n);
    }
    return n;
  }

  /// Число жизненного пути: сумма всех цифр даты.
  static int lifePath(DateTime d) =>
      _reduce(_digitSum(d.day) + _digitSum(d.month) + _digitSum(d.year));

  /// Личный год: день и месяц рождения плюс текущий год.
  static int personalYear(DateTime birth, int year) =>
      _reduce(_digitSum(birth.day) + _digitSum(birth.month) + _digitSum(year));

  /// Личный день: личный год + месяц + день.
  static int personalDay(DateTime birth, DateTime today) => _reduce(
        personalYear(birth, today.year) + _digitSum(today.month) + _digitSum(today.day),
      );

  /// Аркан личности в матрице судьбы: день рождения, свёрнутый к 1..22.
  static int personalArcana(DateTime d) {
    var n = d.day;
    while (n > 22) {
      n -= 22;
    }
    return n;
  }

  static const _animals = [
    'Крыса', 'Бык', 'Тигр', 'Кролик', 'Дракон', 'Змея',
    'Лошадь', 'Коза', 'Обезьяна', 'Петух', 'Собака', 'Свинья',
  ];
  static const _elements = ['Металл', 'Металл', 'Вода', 'Вода', 'Дерево', 'Дерево', 'Огонь', 'Огонь', 'Земля', 'Земля'];

  /// Животное и стихия года. Граница — китайский Новый год; в прототипе
  /// считаем по григорианскому году, для дат января–февраля это неверно.
  static String chineseYear(DateTime d) =>
      '${_elements[d.year % 10]} · ${_animals[(d.year - 4) % 12]}';
}
