# wattpad-translate

Read Wattpad stories in your language, offline. A tiny SwiftUI app (February 2023) that takes a Wattpad chapter URL — pasted, or shared from Safari through the bundled Share Extension — scrapes the chapter text, translates it on-device with ML Kit, and shows it as a reader with a "next chapter" link.

## How it works

- **Scraping** — `WattpadService` fetches the page with Alamofire and parses it with SwiftSoup: chapter text from `.panel-reading` blocks, `rel="next"` for pagination. `getPageInfo(byStringRecursive:)` follows in-chapter pages and concatenates them, then resolves the link to the next chapter.
- **On-device translation** — `TranslateService` wraps ML Kit's `Translator` (EN → RU by default; `TranslatorOptions` is the only line to change). The language model is downloaded once via `downloadModelIfNeeded` (Wi-Fi only, background allowed) and everything after that runs offline.
- **Share Extension** — `share-extension/ShareViewController` receives a URL from any app, stores it in an App Group `UserDefaults` (`group.WattpadTranslate`) and opens the main app through the `wattpadtranslate://` URL scheme; `HomeScreen.onAppear` picks it up.
- **Reader** — `WattpadReaderScreen` in a sheet, shows the translated text and a `NavigationLink` to the next chapter, which recursively opens another reader.

## Layout

```
wattpad-translate/
├── Screens/     HomeScreen (search field + Go), WattpadReaderScreen
└── Services/    WattpadService (Alamofire + SwiftSoup), TranslateService (ML Kit), ConstantsService
share-extension/ ShareViewController — URL → App Group → main app
```

SwiftUI, Alamofire, SwiftSoup, GoogleMLKit/Translate (CocoaPods). iOS 16+.

## Run

```bash
pod install
open wattpad-translate.xcworkspace
```

Pick your team for both targets (app + extension; they share the `group.WattpadTranslate` App Group). ML Kit ships no arm64 simulator slice, so run on a device or an x86_64 (Rosetta) simulator.

No screenshots: the app can't be run in an Apple Silicon simulator (see above) and the output is Russian prose by design.

## License

MIT © Nick Popov
