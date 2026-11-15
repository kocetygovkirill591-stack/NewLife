# Новая Жизнь — Godot source mirror V0.3.3

Текстовая копия исходников для облачной сборки. Игровая логика перенесена из V0.3.3 без изменения механик. Визуальные PNG заменены SVG-иллюстрациями, чтобы проект можно было хранить в GitHub как текстовые файлы.

Исходный GDScript хранится в `.github/source/main.gd.bz2.b64`; workflow декодирует его в `godot-project/scripts/main.gd` перед импортом и сборкой. После успешной сборки workflow публикует APK и обычный ZIP-проект Godot.

Открывать в Godot 4.3+: после распаковки artifact `NewLife-Godot-Source-V0.3.3` откройте `godot-project/project.godot`.
