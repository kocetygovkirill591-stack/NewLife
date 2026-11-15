# Аудит V0.4.2 — первый успешный Android APK

Дата: 15.11.2026

## Итог

Первый Godot Android Debug APK успешно собран в GitHub Actions.

- Run ID: `43732336630`
- Run number: 14
- URL: https://github.com/kocetygovkirill591-stack/NewLife/actions/runs/43732336630
- Branch: `godot-v0.3.3-source-build`
- Build source commit: `e8ddfa72cbbeb9f9474eb3a8f526cdc0858f22b1`
- APK: `NewLife-V0.3.3-debug.apk`
- APK size: 24,203,042 bytes
- APK SHA-256: `c393ba6ab1bc7cc0a463dc914d4db24d8a49451274873b4047556ddb60485180`
- Architecture: `arm64-v8a`
- Package ID in export preset: `com.beryozovsk.newlife`
- Signature: debug keystore; local `jarsigner -verify` exit code 0.

## GitHub artifacts

- `NewLife-Android-Debug-APK-V0.3.3`, artifact ID `14169231849`, 23,962,639 bytes.
- `NewLife-Godot-Source-V0.3.3`, artifact ID `14168853105`, 64,030 bytes.

Expiry: 2026-11-29 15:54 UTC.

## Основная причина прежних ошибок экспорта

Godot 4.3 Android exporter в `has_valid_project_configuration()` проверяет `ResourceImporterTextureSettings::should_import_etc2_astc()`. Если ETC2/ASTC import выключен, export preset признаётся некорректным, но в этой проверке не добавляется отдельное сообщение в `r_error`. Это и давало общий пустой текст «configuration errors».

Исправлено в `godot-project/project.godot`:
`textures/vram_compression/import_etc2_astc=true`.

Дополнительно в CI:
- установлен `cmdline-tools;latest`;
- переменные `JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT` и PATH передаются в следующие шаги;
- записывается явный Godot EditorSettings;
- используется CI-only Export Preset с абсолютными путями к Android templates и debug keystore;
- локальный `export_presets.cfg` восстанавливается после экспорта.

## Проверки run #14

- Checkout source branch — success.
- Decode gzip/base64 GDScript — success.
- Проверка project files and SVG references — success.
- Godot 4.3 Android environment — success.
- Resource import and script validation — success.
- Headless startup test — success.
- Android Debug APK export — success.
- APK artifact upload — success.
- Source ZIP artifact upload — success.

## Локальная проверка скачанных артефактов

- APK ZIP integrity: OK.
- Внутри APK есть `AndroidManifest.xml`, `classes.dex`, `resources.arsc` и `lib/arm64-v8a/libgodot_android.so`.
- `jarsigner -verify` завершился с кодом 0.
- Source ZIP содержит `project.godot`, `scenes/Main.tscn`, обычный `scripts/main.gd`, обе SVG-иллюстрации и ETC2/ASTC настройку.
- SVG прошли XML parsing.

## Ограничения

APK создан, но ещё не установлен и не запущен на физическом Samsung Galaxy S24. Сенсорные зоны, пауза Android, локальное сохранение и производительность на устройстве пока не подтверждены.

## Следующий этап

Установить Debug APK на Samsung Galaxy S24 и проверить:
1. стартовое состояние персонажа;
2. переходы между шестью районами;
3. вход в места и интерактивные объекты квартиры;
4. сворачивание приложения и восстановление сохранения;
5. повторный запуск после принудительного закрытия.
