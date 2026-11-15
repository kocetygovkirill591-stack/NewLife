# Облачная сборка Godot APK — «Новая Жизнь»

Актуальная ветка исходников: `godot-v0.3.3-source-build`.  
Ручной запуск: `.github/workflows/godot-android-dispatch.yml` в основной ветке `main`.

## Текущее устройство проекта

Исходники находятся в GitHub напрямую, без необходимости загружать бинарный ZIP:
- `godot-project/project.godot`
- `godot-project/scenes/Main.tscn`
- `godot-project/export_presets.cfg`
- `godot-project/assets/city_map.svg`
- `godot-project/assets/apartment.svg`
- сжатый GDScript: `.github/source/main.gd.gz.b64`

Workflow восстанавливает обычный `godot-project/scripts/main.gd` стандартными командами `base64` и `gzip` до запуска Godot. Игровая логика V0.3.3 сохранена; PNG-иллюстрации в source mirror заменены SVG-вариантами. После сборки публикуются APK и ZIP с редактируемым проектом.

## Запуск с телефона

1. Откройте [ручной запуск Godot APK](https://github.com/kocetygovkirill591-stack/NewLife/actions/workflows/godot-android-dispatch.yml).
2. Нажмите **Run workflow**.
3. Оставьте ветку `main`: это только диспетчер. Он вызывает сборку из `godot-v0.3.3-source-build`.
4. Дождитесь окончания задания.
5. В завершённом запуске откройте **Artifacts**:
   - `NewLife-Android-Debug-APK-V0.3.3` — APK для установки;
   - `NewLife-Godot-Source-V0.3.3` — обычный Godot-проект с исходным `main.gd`.

APK предназначен для Android ARM64 и подписывается тестовым debug-ключом. Это не релиз для Google Play.

## Этапы сборки

1. Восстановление GDScript из gzip/base64.
2. Проверка сцены, ресурсов и Android Export Preset.
3. Импорт ресурсов в Godot 4.3 headless.
4. Короткий headless smoke test главной сцены.
5. Экспорт `NewLife-V0.3.3-debug.apk`.
6. Проверка APK и ZIP проекта.
7. Публикация двух artifacts на 14 дней.

## Почему ручной запуск находится в main

GitHub принимает событие `workflow_dispatch` только для workflow-файла, который существует в default branch. Поэтому в `main` добавлен отдельный небольшой диспетчер, а сам Godot-проект и сборочная логика остаются в отдельной ветке. Старый Android/Gradle-проект в `main` не заменялся.

## Статус и ограничения

- Исходники и оба workflow-файла записаны в GitHub.
- Локально проверены ZIP, XML/SVG, соответствие путей и декодирование GDScript.
- Первый push-run выявил, что в контейнере `barichello/godot-ci:4.3` нет `python3`; декодирование переведено на `base64 + gzip`.
- Исполняемого Godot локально нет. Компиляция GDScript, экспорт APK и запуск на Samsung Galaxy S24 считаются подтверждёнными только после успешного GitHub Actions run и проверки на устройстве.
