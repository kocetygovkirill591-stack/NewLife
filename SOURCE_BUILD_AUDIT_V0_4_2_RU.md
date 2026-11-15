# Аудит V0.4.2 — прямой Godot source build

Дата: 15.11.2026

## Цель

Убрать блокер бинарной загрузки ZIP и сделать ручной запуск GitHub Actions доступным из default branch, не заменяя старый Android/Gradle-проект.

## Фактические изменения

Ветка `godot-v0.3.3-source-build`:
- Добавлен `.github/source/main.gd.bz2.b64` — сжатый текстовый GDScript из V0.3.3.
- Добавлены `godot-project/project.godot`, `scenes/Main.tscn`, `export_presets.cfg`.
- Добавлены SVG-ресурсы карты Берёзовска и стартовой квартиры.
- Добавлен README для source mirror.
- Обновлён `.github/workflows/godot-android.yml`: декодирование исходника, импорт Godot, headless smoke test, экспорт APK и два artifacts.
- Добавлены `push` и `workflow_call`; reusable workflow явно checkout-ит ветку исходников.

Default branch `main`:
- Добавлен только `.github/workflows/godot-android-dispatch.yml`.
- Он вызывает reusable workflow из `godot-v0.3.3-source-build`.
- Существующие файлы старого Android/Gradle-проекта не заменялись.

## Почему добавлен dispatcher в main

GitHub требует, чтобы файл workflow с `workflow_dispatch` существовал в default branch. Поэтому отдельный минимальный dispatcher находится в `main`, а сам проект и сборочная логика остаются в отдельной ветке.

## Локальные проверки

- Source ZIP: 12 файлов, архив проходит `ZipFile.testzip()`.
- GDScript после bzip2/base64 декодирования совпадает с подготовленным локальным файлом.
- SVG-файлы проходят XML parsing.
- В GDScript ссылки на `city_map.svg` и `apartment.svg` совпадают с добавленными ресурсами.
- Проверены наличие `project.godot`, сцены и Android Export Preset.
- GitHub API подтвердил создание файлов и коммитов в обеих ветках.

## Не выполнено / не подтверждено

- Godot 4.3 не установлен в локальной среде.
- Облачный workflow пока не запущен вручную.
- GDScript не скомпилирован самим Godot.
- APK не создан, не установлен и не проверен на Samsung Galaxy S24.

## Следующий шаг

Открыть workflow `godot-android-dispatch.yml` в GitHub Actions и нажать **Run workflow**. После успешного завершения проверить APK на телефоне.
