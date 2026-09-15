/// Метка сборки, которую подставляет deploy.sh через --dart-define.
///
/// Ссылку на демку открывают в мессенджерах, а те кэшируют страницу живуче —
/// по подписи внизу сразу видно, свежая версия или старая.
const String buildStamp = String.fromEnvironment('BUILD_STAMP', defaultValue: 'dev');
