# Облачная сборка Godot APK — «Новая Жизнь»

Ветка: `godot-v0.3.1-cloud-build`

## Актуальное состояние на 11.11.2026

- Основная ветка `main` не изменялась.
- Ветка Godot содержит workflow `.github/workflows/godot-android.yml` и инструкцию.
- В корне ветки сейчас лежит `NovayaZhizn_GitHub_AutoBuild_v1.2.zip`. Проверка состава показала, что это старый Android/Gradle-проект: внутри есть `build.gradle`, `app/build.gradle`, `AndroidManifest.xml` и `MainActivity.java`. Это **не** проект Godot.
- Архив `NewLife_V0_3_1_CloudBuild.zip`, который нужен для текущего прототипа, в ветке пока отсутствует. Поэтому APK ещё не собран.

## Какой архив загрузить

Скачайте из чата один из двух архивов:
- `NewLife_V0_3_1_CloudBuild.zip` — предпочтительный вариант;
- `NewLife_V0_4_CloudBuild_Kit.zip` — полный комплект, тоже поддерживается workflow.

Загрузите ZIP **в корень** ветки `godot-v0.3.1-cloud-build`, не распаковывая и не переименовывая. Не используйте `NovayaZhizn_GitHub_AutoBuild_v1.2.zip`: это другой, старый Gradle-проект.

## Запуск с телефона

1. Откройте [ветку Godot](https://github.com/kocetygovkirill591-stack/NewLife/tree/godot-v0.3.1-cloud-build).
2. Нажмите **Add file → Upload files**, загрузите правильный ZIP в корень и сохраните commit в эту же ветку.
3. Откройте [GitHub Actions](https://github.com/kocetygovkirill591-stack/NewLife/actions).
4. Выберите **«Новая Жизнь — Android Debug APK»** → **Run workflow**.
5. Выберите ветку `godot-v0.3.1-cloud-build`.
6. После успешного запуска откройте **Artifacts** и скачайте `NewLife-Android-Debug-APK`.
7. Распакуйте artifact ZIP и установите APK на Samsung Galaxy S24.

## Что проверяет обновлённый workflow

- Версию Godot 4.3, Java и наличие debug-keystore.
- Наличие именно Godot-архива, `project.godot`, Android export preset, главной сцены, скрипта и двух игровых изображений.
- Импорт ресурсов и ошибки GDScript.
- Короткий headless-запуск главной сцены.
- Экспорт подписанного **Debug APK** для `arm64-v8a` и целостность APK-архива.
- Публикацию APK как artifact на 14 дней.

Workflow запускается вручную, чтобы случайная загрузка старого Gradle ZIP не создавала бесполезные сборки. Если правильный архив отсутствует, журнал теперь явно укажет, какой файл найден и какой нужно загрузить.

## История неудачных запусков

Три ранних запуска workflow от 10.11.2026 завершились с `failure`, без созданных jobs и без artifacts. В исходной версии YAML этих коммитов была лишняя кавычка перед `name:`. В текущем коммите эта ошибка исправлена; обновлённый workflow пока не запускался, потому что правильный Godot ZIP ещё не загружен.

## Ограничения

Это тестовая Debug-сборка, не релиз для Google Play. Debug-keystore не предназначен для публикации или гарантированного обновления приложения, подписанного другим ключом. APK не считается проверенным на Samsung Galaxy S24, пока его не установят и не запустят на устройстве.
