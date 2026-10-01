# android-ui-kit

[Русский](README.ru.md)

Small, dependency-free Kotlin helpers for plain Android Views (minSdk 26), shared by my apps
[AppShelf](https://github.com/Xtratter/appshelf) and [DroidTop](https://github.com/Xtratter/droidtop).

| File | What it does |
|---|---|
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
