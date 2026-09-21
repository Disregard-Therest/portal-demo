/// Расчёты, которые честно делаются из даты рождения без эфемерид.
///
/// Первая версия продукта — только нумерология: число пути, аркан личности,
/// личный год, личный месяц и личный день. Знак зодиака, китайский год и всё,
/// для чего нужны эфемериды и место рождения, здесь не считаются — этого нет
/// ни на одном из новых экранов.
abstract final class AstroMath {
  static int _digitSum(int n) => n.toString().split('').map(int.parse).fold(0, (a, b) => a + b);

  /// Сворачивает до одной цифры, мастер-числа 11, 22 и 33 не трогает.
  static int _reduce(int n) {
    while (n > 9 && n != 11 && n != 22 && n != 33) {
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

  /// Личный месяц: личный год плюс текущий месяц.
  static int personalMonth(DateTime birth, DateTime today) =>
      _reduce(personalYear(birth, today.year) + _digitSum(today.month));

  /// Личный день: личный год плюс месяц и день.
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
}
