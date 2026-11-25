# Practice 13: Where Things Go

Feature-first Flutter Users API. Repository interface, fake for offline tests, HTTP implementation, extracted widgets, and layer checker.

## Run
```sh
flutter pub get
flutter run -d chrome
flutter test
bash tool/check_layers.sh
```

The main.dart file is the composition root. Fake repository is in `test/fakes` and can be copied into lib for a no-network demo build (do not import `test/` from production code).

## Quality checklist (replace placeholders with YOUR actual console output)
```text
flutter analyze
[PASTE ACTUAL OUTPUT]

dart format .
[PASTE ACTUAL OUTPUT]

flutter test
[PASTE ACTUAL OUTPUT]

bash tool/check_layers.sh
[PASTE ACTUAL OUTPUT — must be empty]
```
