# android-ui-kit

[Русский](README.ru.md)

A light Material 3 Expressive and small helpers for plain Android Views — Kotlin, no dependencies (minSdk 26), shared by my apps
[AppShelf](https://github.com/Xtratter/appshelf) and [DroidTop](https://github.com/Xtratter/droidtop).

| File | What it does |
|---|---|
| `M3.kt` | **Light Material 3 Expressive** without libraries: colour scheme with Material You accents from the wallpaper (Android 12+), themes `SYSTEM`, `LIGHT`, `DARK`, `GRAPHITE`, `AMOLED` plus your own (`M3.Custom`), tonal containers and surfaces, optional transparency, text colours, `pill`, `ripple`, `textPaint`. |
| `M3Drawables.kt` | `M3Surface` — tonal (or glass) surface for cards, bars and windows; `M3Background` — window background with soft accent blobs. |
| `M3Dialog.kt` | `M3Dialog.style(dialog)` — tonal window, blurred screen behind (Android 12+), accent buttons, haptic clicks, dissolving edges; `count` / `onAllClosed` to pause redraws under dialogs. |
| `Expressive.kt` | Expressive shapes: buttons squash from a pill into a rounded rectangle when pressed; grouped list rows with big outer and small inner corners. |
| `M3Widgets.kt` | Ready-made widgets: filled / tonal / outlined / danger buttons, filter chips, a switch row, accent tint for checkboxes, radios and switches. |
| `EdgeBlur.kt` | Telegram-like soft edges: scrolling content is progressively blurred (several blur steps, stronger towards the edge) and fades out at the top and bottom. Drawn in the same frame as the content — no lag while scrolling. Android 12+ blur, a plain fade below. |
| `Haptics.kt` | Crisp haptic feedback with strength levels (off / light / medium / strong) and the best method for the phone: Android 11+ primitives, vendor effects or a short pulse. |
| `Help.kt` | Long-press help: hold a finger on a button to see a bubble with its name and what it does. |

## Use

The files are **copied** into a project (no Gradle dependency — the app still builds offline, on F-Droid, in Termux):

```sh
./install.sh ~/projects/MyApp          # → MyApp/app/src/main/java/io/github/xtratter/uikit/
CHECK=1 ./install.sh ~/projects/MyApp  # only show which files differ
```

Edit the files here, then re-run `install.sh` in every project.

```kotlin
// once, e.g. in onCreate — and again when the theme changes (then rebuild the views)
M3.apply(this, M3.Mode.SYSTEM, translucent = true)
window.setBackgroundDrawable(if (M3.aurora) M3Background() else ColorDrawable(M3.base))
card.background = M3Surface(this, 24f)
row.addView(M3Widgets.button(this, "Save", M3Widgets.ButtonKind.FILLED) { save() }, LinearLayout.LayoutParams(-1, M3.dp(this, 52f).toInt()))
dialog.show(); M3Dialog.style(dialog)
Haptics.onTouch = { v, e -> Expressive.morph(v, e) }   // squash on press for every Haptics.onClick view

// once, e.g. in onCreate
Haptics.init(this, getSharedPreferences("prefs", MODE_PRIVATE))
Help.style = { Help.Style(background = …, border = …, title = …, text = …) }   // current theme colours

// soft edges around a ListView / ScrollView
val edges = EdgeBlur.wrap(listView, bandDp = 56f, fadeTop = bgColor)!!
edges.alwaysTop = true          // keep the band even before scrolling (e.g. under a floating toolbar)
EdgeBlur.wrap(dialogScroller, 40f, 0, 0)?.dissolve = true   // in dialogs: fade into the window's glass

// haptics and help
Haptics.onClick(button)                     // click when the finger lifts on the button
Haptics.attachAll(dialog.window!!.decorView) // every clickable inside: tap, checkboxes: tick
Haptics.play(Haptics.Kind.SUCCESS)
Help.attach(button, R.string.title, R.string.text)
```

Settings UI is up to the app: `Haptics.level()` / `setLevel()`, `engineChoice()` / `setEngine()`, `supports(engine)`.
`Haptics.onTouch` lets the app add a press animation to every view set up with `onClick`.

## License

Apache-2.0
