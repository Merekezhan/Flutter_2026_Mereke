# Practice 13 notes

## Dependency rule
Screens → Models → UserRepository interface → HttpUserRepository → ApiClient.
The model receives a repository through its constructor; it does not create one.

## Why extracted widgets (not helper build methods)?
StatelessWidgets can be const, have independent rebuild scopes, appear by name in DevTools, and have their own widget tests.
A helper method does not create a separate widget identity.

## Why the old model is difficult to test
When the model creates its own HTTP repository, the test cannot arrange an offline repository without making a real network request. Constructor injection solves this.

## Trace activity: paste YOUR real trace here
1. Temporarily change a Geo.fromJson input to numeric `lat` (-37.3159) and reproduce the TypeError locally.
2. Paste the exact stack trace below (including actual line and column); do not invent one.
3. Annotate: **message**, **first project frame (#0 Geo.fromJson)** and **path to UsersModel.load**, including `<asynchronous suspension>` when present.
4. State the bad field (`address.geo.lat`) and affected user.
5. Restore input. The repository test `malformed numeric lat maps to BadResponseException` checks the fix.

Why #0 is right place to throw but wrong place to fix: Geo.fromJson enforces the data contract; HttpUserRepository translates unexpected data into an API-facing BadResponseException.

## Demonstration of layer rule
Temporarily import `package:http/http.dart` in `users_screen.dart`: check_layers.sh should flag that file. Remove the import afterward.
