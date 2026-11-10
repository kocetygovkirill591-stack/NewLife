# Облачная сборка Godot APK — «Новая Жизнь»

Ветка: `godot-v0.3.1-cloud-build`

## Состояние

Ветка содержит отдельный workflow для Godot 4.3 с установкой Android SDK Platform 34, Build Tools 34.0.0, NDK r23c и CMake 3.10.2.4988404. Основная ветка `main` не изменялась: старый Android/Gradle workflow сохранён.

## Как запустить с телефона

1. Скачайте отдельный архив `NewLife_V0_3_1_CloudBuild.zip` из чата.
2. Загрузите его в корень данной ветки без переименования и распаковки.
3. После загрузки ZIP откройте Actions → «Новая Жизнь — Android Debug APK» → Run workflow.
4. После успешного запуска откройте Artifacts и скачайте `NewLife-Android-Debug-APK`.
5. Распакуйте artifact ZIP и установите APK на Samsung Galaxy S24.

## Что делает workflow

- Использует контейнер `barichello/godot-ci:4.3` с Godot, Android SDK, JDK 17 и debug keystore.
- Распаковывает архив проекта.
- Запускает headless import Godot для проверки ресурсов и GDScript.
- Экспортирует Android Debug APK для arm64-v8a.
- Публикует APK как artifact на 14 дней.

## Важно

Это debug APK для установки и проверки, не релиз Google Play. Release keystore и пароли не добавляются в репозиторий. APK ещё не собран: сборка начнётся только после загрузки ZIP в эту ветку.
