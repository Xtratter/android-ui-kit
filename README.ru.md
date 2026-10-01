# android-ui-kit

[English](README.md)

Маленькие вспомогательные файлы на Kotlin для обычных View Android (minSdk 26) без зависимостей. Общие для моих
приложений [AppShelf](https://github.com/Xtratter/appshelf) и [DroidTop](https://github.com/Xtratter/droidtop).

| Файл | Что делает |
|---|---|
| `EdgeBlur.kt` | Мягкие края, как в Telegram: прокручиваемое содержимое у верхнего и нижнего края плавно размывается (несколько ступеней, сильнее к краю) и растворяется. Рисуется в том же кадре, что и содержимое, — ничего не отстаёт при прокрутке. Размытие — Android 12+, ниже — только растворение. |
| `Haptics.kt` | Чёткий отклик вибрацией с уровнями силы (выключена / лёгкая / средняя / сильная) и лучшим способом для телефона: примитивы Android 11+, эффекты производителя или короткий импульс. |
| `Help.kt` | Справка по удержанию: задержите палец на кнопке — всплывёт подсказка с названием и тем, что она делает. |

## Как подключить

Файлы **копируются** в проект (без зависимости в Gradle — приложение по-прежнему собирается без сети, в F-Droid и в Termux):

```sh
./install.sh ~/projects/MyApp          # → MyApp/app/src/main/java/io/github/xtratter/uikit/
CHECK=1 ./install.sh ~/projects/MyApp  # только показать, какие файлы отличаются
```

Править файлы — здесь, потом заново запустить `install.sh` в каждом проекте.

```kotlin
// один раз, например в onCreate
Haptics.init(this, getSharedPreferences("prefs", MODE_PRIVATE))
Help.style = { Help.Style(background = …, border = …, title = …, text = …) }   // цвета текущей темы

// мягкие края у ListView / ScrollView
val edges = EdgeBlur.wrap(listView, bandDp = 56f, fadeTop = bgColor)!!
edges.alwaysTop = true          // полоса и до прокрутки (например, под плавающей панелью)
EdgeBlur.wrap(dialogScroller, 40f, 0, 0)?.dissolve = true   // в окнах: растворение в стекле окна

// вибрация и справка
Haptics.onClick(button)                     // щелчок, когда палец отпускает кнопку
Haptics.attachAll(dialog.window!!.decorView) // всё нажимаемое внутри: кнопки — щелчок, галочки — тик
Haptics.play(Haptics.Kind.SUCCESS)
Help.attach(button, R.string.title, R.string.text)
```

Окно настроек — за приложением: `Haptics.level()` / `setLevel()`, `engineChoice()` / `setEngine()`, `supports(engine)`.
`Haptics.onTouch` — своя анимация нажатия для всех View, подключённых через `onClick`.

## Лицензия

Apache-2.0
