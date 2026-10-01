# android-ui-kit

[English](README.md)

Лёгкий Material 3 Expressive и маленькие помощники для обычных View Android — Kotlin, без зависимостей (minSdk 26). Общие для моих
приложений [AppShelf](https://github.com/Xtratter/appshelf) и [DroidTop](https://github.com/Xtratter/droidtop).

| Файл | Что делает |
|---|---|
| `M3.kt` | **Лёгкий Material 3 Expressive** без библиотек: схема цветов с акцентами Material You из обоев (Android 12+), темы `SYSTEM`, `LIGHT`, `DARK`, `GRAPHITE`, `AMOLED` и свои (`M3.Custom`), тональные контейнеры и поверхности, прозрачность по желанию, цвета текста, `pill`, `ripple`, `textPaint`. |
| `M3Drawables.kt` | `M3Surface` — тональная (или «стеклянная») поверхность карточек, панелей и окон; `M3Background` — фон окна с мягкими цветными пятнами. |
| `M3Dialog.kt` | `M3Dialog.style(dialog)` — тональное окно, размытие экрана позади (Android 12+), кнопки цвета акцента, щелчки вибрацией, растворяющиеся края; `count` / `onAllClosed` — чтобы не перерисовывать экран под окном. |
| `Expressive.kt` | Формы Expressive: кнопки при нажатии «сплющиваются» из капсулы в скруглённый прямоугольник; строки списка группами — крупные внешние и мелкие внутренние углы. |
| `M3Widgets.kt` | Готовые элементы: кнопки (заполненная, тональная, контурная, опасная), чипы-фильтры, строка с переключателем, цвет акцента для галочек, радиокнопок и переключателей. |
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
// один раз, например в onCreate, — и снова при смене темы (потом пересобрать виды)
M3.apply(this, M3.Mode.SYSTEM, translucent = true)
window.setBackgroundDrawable(if (M3.aurora) M3Background() else ColorDrawable(M3.base))
card.background = M3Surface(this, 24f)
row.addView(M3Widgets.button(this, "Save", M3Widgets.ButtonKind.FILLED) { save() }, LinearLayout.LayoutParams(-1, M3.dp(this, 52f).toInt()))
dialog.show(); M3Dialog.style(dialog)
Haptics.onTouch = { v, e -> Expressive.morph(v, e) }   // «сплющивание» при нажатии у всех View с Haptics.onClick

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
