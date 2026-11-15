# Облачная сборка Godot APK — «Новая Жизнь»

## Первый успешный APK

<badge>Build successful</badge>

- GitHub Actions run: [#14 — успешная сборка](https://github.com/kocetygovkirill591-stack/NewLife/actions/runs/43732336630)
- Исходная ветка: `godot-v0.3.3-source-build`
- Коммит проекта: `e8ddfa72cbbeb9f9474eb3a8f526cdc0858f22b1`
- APK: `NewLife-V0.3.3-debug.apk`
- Платформа: Android ARM64
- Package ID: `com.beryozovsk.newlife`
- Подпись: debug keystore; это тестовая сборка, не релиз Google Play.

## Артефакты первого успешного запуска

1. `NewLife-Android-Debug-APK-V0.3.3` — APK artifact, ID `14169231849`, 23 962 639 байт.
2. `NewLife-Godot-Source-V0.3.3` — ZIP исходного Godot-проекта, ID `14168853105`, 64 030 байт.

Артефакты GitHub Actions хранятся до **29 ноября 2026, 15:54 UTC**. После этого срока их нужно будет собрать повторно.

## Что исправлено для успешного экспорта

Godot 4.3 отклонял Android preset без подробного сообщения, потому что проект не включал ETC2/ASTC texture import. Проверка исходного кода Godot 4.3 показала, что `has_valid_project_configuration()` возвращает ошибку, когда `ResourceImporterTextureSettings::should_import_etc2_astc()` выключен.

Исправление в `godot-project/project.godot`:
```ini
[rendering]
textures/vram_compression/import_etc2_astc=true
```

Дополнительно:
- Android SDK, JDK 17 и Godot export templates проверяются и настраиваются в CI;
- создан CI-only preset с явными путями к Android templates и debug keystore;
- локальный Export Preset восстанавливается после экспорта, чтобы не оставлять CI-пути в исходном ZIP.

## Запуск следующей сборки

1. Откройте [ручной запуск Godot APK](https://github.com/kocetygovkirill591-stack/NewLife/actions/workflows/godot-android-dispatch.yml).
2. Нажмите **Run workflow** на ветке `main`.
3. Диспетчер вызывает reusable workflow из `godot-v0.3.3-source-build`.
4. После успешного завершения откройте **Artifacts** и скачайте APK и ZIP исходников.

## Установка на Samsung Galaxy S24

1. Скачайте `NewLife-V0.3.3-debug.apk` на телефон.
2. Откройте файл через «Мои файлы» → «Загрузки».
3. Если Android запросит разрешение, разрешите установку приложений из этого источника.
4. Нажмите «Установить» и запустите «Новая Жизнь».

Если Android сообщит о конфликте подписи с более старой установкой, удалите старую тестовую версию и установите новую. Перед удалением сохраните нужные данные: локальные сохранения могут быть удалены вместе с приложением.

## Что проверено

- Godot 4.3 импортировал ресурсы без ошибок скрипта.
- Главная сцена прошла короткий headless startup test.
- Android Debug APK экспортирован и загружен как GitHub artifact.
- APK прошёл ZIP integrity check.
- В APK присутствует `lib/arm64-v8a`.
- Локальный `jarsigner -verify` завершился с кодом 0.
- ZIP исходников содержит обычный `scripts/main.gd`, сцену, SVG-ресурсы и проектные настройки.

## Что ещё не проверено

- Установка и первый запуск на физическом Samsung Galaxy S24.
- Реальное нажатие по районам и объектам на сенсорном экране.
- Сохранение после сворачивания/перезапуска на устройстве.
- Длительная работа и производительность на телефоне.

Основная ветка `main` содержит только отдельный workflow-диспетчер; прежний Android/Gradle-проект не заменялся.
