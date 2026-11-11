# Аудит CI V0.4.1 — 11.11.2026

## Цель этапа

Устранить неоднозначность входных файлов облачной сборки и добавить проверки до экспорта APK, не меняя игровой код V0.3.1 и основную ветку.

## Фактическое состояние GitHub

- Ветка: `godot-v0.3.1-cloud-build`.
- Основная ветка `main` не изменялась.
- В корне ветки найден `NovayaZhizn_GitHub_AutoBuild_v1.2.zip`. Его состав соответствует старому Android/Gradle-проекту (`build.gradle`, `app/build.gradle`, `AndroidManifest.xml`, `MainActivity.java`), а не текущему Godot-проекту.
- Требуемый `NewLife_V0_3_1_CloudBuild.zip` в ветке отсутствует.
- Три прежних запуска Godot workflow от 10.11.2026 завершились с `failure`; GitHub API показывает 0 jobs и 0 artifacts.
- В YAML ранних коммитов была лишняя открывающая кавычка перед `name:`. В текущем workflow эта ошибка исправлена.

## Изменения

1. Создана резервная копия прежнего workflow:
   `.github/workflows/godot-android.yml.backup-2026-11-11`.
2. Обновлён `.github/workflows/godot-android.yml`:
   - ручной запуск;
   - проверка входного ZIP **до** установки Android SDK-компонентов;
   - поддержка двух имён корректного архива;
   - явное отклонение старого Gradle ZIP;
   - проверка обязательных файлов Godot-проекта;
   - импорт ресурсов и поиск ошибок GDScript;
   - короткий headless smoke test;
   - Debug APK export и проверка целостности APK.
3. Обновлён `GODOT_CLOUD_BUILD_RU.md` с точными инструкциями и текущим блокером.

Игровые файлы `project.godot`, `scripts/main.gd`, `scenes/Main.tscn` и изображения не менялись.

## Проверки

- YAML разобран локальным PyYAML без ошибок.
- Все shell-блоки workflow прошли `bash -n`.
- Preflight проверен на трёх сценариях: правильный Godot ZIP принят; старый Gradle ZIP отклонён с точным сообщением; отсутствие ZIP объясняется отдельно.
- GitHub API подтвердил обновлённые файлы и сохранение резервной копии.
- Ветка `main` не затрагивалась.

Workflow пока не запускался после исправления: правильный Godot ZIP отсутствует. Поэтому импорт Godot, runtime smoke test, экспорт APK и запуск на Samsung Galaxy S24 не подтверждены.

## Следующий шаг

Загрузить `NewLife_V0_3_1_CloudBuild.zip` в корень ветки `godot-v0.3.1-cloud-build`, затем вручную запустить workflow через GitHub Actions. Только успешный artifact будет основанием утверждать, что APK собран.
