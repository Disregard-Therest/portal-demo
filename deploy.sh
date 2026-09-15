#!/usr/bin/env bash
# Сборка и деплой демки на GitHub Pages с кэш-бастингом.
# Запуск из корня проекта: ./deploy.sh
# Pages раздаёт docs/ с ветки master.
set -euo pipefail

BASE_HREF="/portal-demo/"
BRANCH="master"
TS=$(date +%s)
# Без пробелов: значение уезжает в --dart-define.
STAMP=$(date +'%d.%m.%Y-%H:%M')

flutter test

# Без service worker: для демки он только мешает обновлениям —
# получатель ссылки увидит старую сборку из кэша.
flutter build web --release \
  --base-href "$BASE_HREF" \
  --pwa-strategy=none \
  --dart-define=BUILD_STAMP="$STAMP"

for f in manifest.json favicon.png icons/Icon-192.png; do
  [ -f "build/web/$f" ] || { echo "FAIL: build/web/$f отсутствует, пересобери"; exit 1; }
done

# Kill-switch на месте воркера: вычищает кэш, если когда-то сборка была с PWA.
cp tools/sw-killswitch.js build/web/flutter_service_worker.js

# ── Кэш-бастинг ────────────────────────────────────────────────────────────
# GitHub Pages и вебвью мессенджеров кэшируют по URL — единственный надёжный
# способ обновиться — сменить URL. perl, а не sed -i: у BSD и GNU разный синтаксис.
perl -pi -e "s|flutter_bootstrap.js\"|flutter_bootstrap.js?v=$TS\"|" build/web/index.html
perl -pi -e "s|href=\"manifest.json\"|href=\"manifest.json?v=$TS\"|" build/web/index.html
perl -pi -e "s|href=\"favicon.png\"|href=\"favicon.png?v=$TS\"|" build/web/index.html
perl -pi -e "s|\"main.dart.js\"|\"main.dart.js?v=$TS\"|g" build/web/flutter_bootstrap.js

for pat in 'flutter_bootstrap.js?v=' 'manifest.json?v=' 'favicon.png?v='; do
  grep -qF "$pat" build/web/index.html \
    || { echo "FAIL: кэш-бастинг не применился к '$pat' в index.html"; exit 1; }
done
grep -qF "main.dart.js?v=" build/web/flutter_bootstrap.js \
  || { echo "FAIL: кэш-бастинг не применился к main.dart.js"; exit 1; }

rm -rf docs
mkdir -p docs
cp -r build/web/* docs/
touch docs/.nojekyll

git add -A
git commit -m "deploy $TS"
git push origin "$BRANCH"

echo "Готово: сборка $STAMP → https://disregard-therest.github.io/portal-demo/ (Pages обновится за 1–2 минуты)"
