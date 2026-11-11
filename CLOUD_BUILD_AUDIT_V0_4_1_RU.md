# Аудит CI V0.4.1 — 11.11.2026

## Цель этапа

Устранить неоднозначность входных файлов облачной сборки и добавить проверки до экспорта APK, не меняя игровой код V0.3.1 и основную ветку.

## Что установлено по фактическому состоянию GitHub

- Ветка: `godot-v0.3.1-cloud-build`.
- Основная ветка `main` не изменялась.
- В корне ветки был найден `NovayaZhizn_GitHub_AutoBuild_v1.2.zip`.
- Состав этого ZIP соответствует Android/Gradle-проекту (`build.gradle`, `app/build.gradle`, `AndroidManifest.xml`, `MainActivity.java`), а не текущему Godot-проекту.
- Требуемый `NewLife_V0_3_1_CloudBuild.zip` отсутствует в ветке.
- Три прежних запуска Godot workflow от 10.11.2026 завершились с `failure`; GitHub API показывает 0 jobs и 0 artifacts для этих запусков.
- В YAML тех ранних коммитов была лишняя открывающая кавычка перед `name:`. В текущей версии файла она исправлена.

## Изменения

1. Создана резервная копия прежнего workflow:
   `.github/workflows/godot-android.yml.backup-2026-11-11`.
2. Обновлён `.github/workflows/godot-android.yml`:
   - ручной запуск;
   - поддержка двух имён корректного архива;
   - явное отклонение старого Gradle ZIP;
   - проверка обязательных файлов Godot-проекта;
   - импорт ресурсов и поиск ошибок GDScript;
   - короткий headless smoke test;
   - Debug APK export и проверка ZIP-целостности.
3. Обновлён `GODOT_CLOUD_BUILD_RU.md` с точными инструкциями и текущим блокером.

Игровые файлы `project.godot`, `scripts/main.gd`, `scenes/Main.tscn` и изображения не менялись.

## Проверки

- GitHub API подтвердил наличие ветки и обновлённых файлов.
- Ветка `main` не затрагивалась.
- Workflow пока не запускался после исправления: правильный Godot ZIP отсутствует. Поэтому ни импорт Godot, ни smoke test, ни экспорт APK не подтверждены.

## Следующий шаг

Загрузить `NewLife_V0_3_1_CloudBuild.zip` в корень ветки `godot-v0.3.1-cloud-build`, затем вручную запустить workflow через GitHub Actions. Только успешный artifact будет основанием утверждать, что APK собран.
