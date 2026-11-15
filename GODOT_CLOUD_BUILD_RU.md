# Облачная сборка Godot APK — «Новая Жизнь»

Актуальная ветка исходников: `godot-v0.3.3-source-build`  
Ручной запуск: workflow в основной ветке `.github/workflows/godot-android-dispatch.yml`.

## Что изменилось

Раньше сборка ожидала бинарный ZIP, который нельзя было загрузить в репозиторий через доступный текстовый GitHub-коннектор. Теперь исходники проекта находятся непосредственно в ветке:
- `godot-project/project.godot`
- `godot-project/scenes/Main.tscn`
- `godot-project/export_presets.cfg`
- `godot-project/assets/city_map.svg`
- `godot-project/assets/apartment.svg`
- сжатый GDScript: `.github/source/main.gd.bz2.b64`

Workflow восстанавливает обычный `godot-project/scripts/main.gd` перед запуском Godot. Игровая логика V0.3.3 сохранена; ссылки на две иллюстрации заменены с PNG на SVG. После сборки публикуются два отдельных артефакта: APK и редактируемый ZIP проекта.

## Запуск с телефона

1. Откройте [ручной запуск Godot APK](https://github.com/kocetygovkirill591-stack/NewLife/actions/workflows/godot-android-dispatch.yml).
2. Нажмите **Run workflow**.
3. Оставьте ветку `main` — это только диспетчер. Он вызывает сборку исходников из `godot-v0.3.3-source-build`.
4. Дождитесь окончания задания.
5. В завершённом запуске откройте **Artifacts**:
   - `NewLife-Android-Debug-APK-V0.3.3` — APK для установки;
   - `NewLife-Godot-Source-V0.3.3` — обычный Godot-проект с исходным `main.gd`.

APK предназначен для Android ARM64 и подписывается тестовым debug-ключом. Это не релиз для Google Play.

## Что делает workflow

1. Проверяет и декодирует сжатый GDScript.
2. Проверяет наличие сцены, ресурсов и Android Export Preset.
3. Запускает импорт ресурсов в Godot 4.3 headless.
4. Выполняет короткий headless smoke test главной сцены.
5. Экспортирует APK `NewLife-V0.3.3-debug.apk`.
6. Проверяет целостность APK и ZIP исходников.
7. Публикует APK и исходный проект как artifacts на 14 дней.

## Ограничения и честный статус

- Наличие исходников и workflow в GitHub подтверждено.
- Локально выполнены проверки структуры, bzip2/base64-декодирования, XML/SVG и ZIP.
- Исполняемого Godot в рабочей среде нет. Компиляция GDScript движком, headless-запуск, экспорт APK и установка на Samsung Galaxy S24 пока не подтверждены.
- Ручной workflow создан в default branch, потому что GitHub принимает `workflow_dispatch` только для workflow-файлов, существующих в default branch.
- В `main` добавлен только отдельный диспетчер `.github/workflows/godot-android-dispatch.yml`; старый Android/Gradle-проект и его workflow не заменялись.

## Предыдущие архивы

Старый `NovayaZhizn_GitHub_AutoBuild_v1.2.zip` остаётся в прежней ветке и не используется новым конвейером. Ручная загрузка Godot ZIP больше не требуется.
