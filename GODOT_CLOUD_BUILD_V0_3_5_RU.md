# Облачная сборка «Новая Жизнь» V0.3.5

<badge>Build successful</badge>

- Ветка: `godot-v0.3.5-shift-window`
- Коммит: `ab903628b9023d8fb419139a823c8883f71c2db7`
- GitHub Actions run #23: [успешная сборка APK](https://github.com/kocetygovkirill591-stack/NewLife/actions/runs/43911242048)
- Движок: Godot 4.3
- Цель: Android Debug APK, arm64-v8a
- Package ID: `com.beryozovsk.newlife`
- Android versionCode: 5
- APK: `NewLife-V0.3.5-debug.apk`

## Артефакты

- `NewLife-Android-Debug-APK-V0.3.5`, ID `14248281557`, 23 967 899 байт (ZIP-артефакт с APK).
- `NewLife-Godot-Source-V0.3.5`, ID `14248885837`, 70 529 байт (ZIP-артефакт с исходниками).
- Артефакты GitHub Actions хранятся до 30 ноября 2026 года, 16:48 UTC.

## Проверки

- Восстановление GDScript из проверенного base + patch и SHA-256: успешно.
- Godot 4.3 импортировал ресурсы и проверил GDScript: успешно.
- Короткий headless запуск главной сцены: успешно.
- Android Debug APK экспортирован и загружен как артефакт: успешно.
- ZIP APK и ZIP исходников прошли проверку целостности.
- В APK присутствует `lib/arm64-v8a/libgodot_android.so`.
- APK прошёл `jarsigner -verify`.
- Сертификат подписи совпадает с V0.3.3 и V0.3.4, поэтому обновление поверх этих тестовых версий должно быть возможно без удаления приложения и потери локальных данных.

## Изменение V0.3.5

Начало рабочей смены теперь разрешено строго с 06:00 до 12:00 включительно. В 12:01 и позже смена не запускается. SAVE_VERSION=2 и прежние игровые системы сохранены.

Физический запуск на Samsung Galaxy S24, сенсорное управление и сохранения на устройстве ещё не проверены. Это Debug-сборка, не релиз Google Play.
