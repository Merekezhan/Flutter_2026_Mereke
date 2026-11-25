
# Practice 11 — A Real Server
### Android SDK Compatibility

permission_handler 13.0.2 caused an Android build
failure because it requires compileSdk 37, while
the project uses compileSdk 36.

The dependency constraint was changed to ^12.0.3
to maintain compatibility with the current Android SDK.
## Level 1 — Postman First

API: https://jsonplaceholder.typicode.com

### Requests

| Method | Endpoint | Expected status | Response |
|---|---|---|---|
| GET | /users | 200 | Array of 10 users |
| GET | /users/1 | 200 | One user object |
| GET | /users/999 | 404 | Empty object {} |
| GET | /users?id=3 | 200 | Array with one user |
| POST | /users | 201 | Created object with id 11 |

These are expected JSONPlaceholder results.
Actual requests must be checked in Postman or curl.

### User Fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| id | number | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| phone | string | String | No |
| website | string/null | String? | Yes |
| address | object | Address | No |
| company | object | Company record | No |

### Address Fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### Geo Fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| lat | string | double | No |
| lng | string | double | No |

### Company Fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | Not stored | No |

## Level 2 — JSON Model

User, Address and Geo use fromJson and toJson.

Geo coordinates are parsed from strings to doubles.
Website is nullable.
Phone digits are normalized using RegExp.
User equality is based on id.

### Negative Tests

Change lat parsing to a direct double cast:
Expected result: type cast error.

Change id from 1 to "1":
Expected result: type cast error.

Restore the correct model after both tests.

## Level 3 — Repository

ApiClient uses an injected http.Client.

- Timeout: 10 seconds
- 401: UnauthorizedException
- 404: NotFoundException
- 5xx: ServerException
- Invalid JSON: BadResponseException
- SocketException: NoConnectionException
- TimeoutException: NoConnectionException

UserRepository implements getAll, getById and create.

## Level 4 — UI

Expected behavior:
- Load 10 users
- Open user details
- Pull to refresh
- Show Offline screen when disconnected
- Retry after reconnecting

## Level 5 — Network Tests

### Airplane Mode

Measured time: TO BE TESTED
Result: TO BE TESTED

### Dead Wi-Fi

Measured time: TO BE TESTED
Result: TO BE TESTED

### POST Request

Expected status: 201
Actual status: TO BE VERIFIED

Save button must be disabled during the request.

### Screenshots

- screenshot_timeout.png
- screenshot_200.png

## Conclusion

This practice demonstrates how a Flutter application
communicates with a real REST API using HTTP.

The repository separates networking from the UI.
ChangeNotifier manages application state.
Custom exceptions handle different failure cases.
A timeout prevents requests from waiting indefinitely.
---

# Practice 12 — Survive a Restart

## Level 1 — Package Evaluation
### Package Verdicts

1. shared_preferences — verified publisher flutter.dev,
   version 2.5.6, released October 2026, supports Android,
   iOS, Linux, macOS, Web and Windows, 160 pub points,
   maintained by the Flutter team, depends on Flutter
   and platform-specific implementations, BSD-3-Clause.

2. flutter_secure_storage — verified publisher
   steenbakker.dev, version 11.2.0, released around
   September 2026, supports all six platforms,
   160 pub points, has a recent release, depends on
   Flutter, meta and platform-specific implementations,
   BSD-3-Clause.

3. path_provider — verified publisher flutter.dev,
   version 2.1.6, released around June 2026, supports
   Android, iOS, Linux, macOS and Windows,
   160 pub points, maintained by the Flutter team,
   depends on Flutter and platform-specific
   implementations, BSD-3-Clause.

4. image_picker — verified publisher flutter.dev,
   version 1.2.4, released October 2026, supports
   all six platforms, 160 pub points, maintained by
   the Flutter team, depends on Flutter and
   platform-specific implementations,
   Apache-2.0 and BSD-3-Clause.

5. permission_handler — verified publisher baseflow.com,
   version 13.0.2, released around September 2026,
   supports Android, iOS, Web and Windows,
   160 pub points, has 130 open GitHub issues and
   a recent release, depends on Flutter, meta and
   platform-specific implementations, MIT.

6. url_launcher — verified publisher flutter.dev,
   version 6.3.3, released October 2026,
   supports all six platforms, 160 pub points,
   maintained by the Flutter team, depends on Flutter
   and platform-specific implementations, BSD-3-Clause.

### Caret Versioning

The constraint ^1.2.0 accepts versions greater than
or equal to 1.2.0 and lower than 2.0.0.

Accepted: 1.2.0, 1.2.1, 1.3.0, 1.6.0.
Refused: 1.1.0, 2.0.0, 3.0.0.

The caret allows compatible updates without allowing
a new major version that may introduce breaking changes.

### Lock File

pubspec.lock stores the exact resolved dependency
versions.

It is committed to Git because all developers
should build and test the application using
the same dependency versions.
### Resolved HTTP Version

The exact HTTP version in pubspec.lock is 1.6.0.
The dependency constraint in pubspec.yaml is ^1.6.0.

### Flutter Pub Outdated

Package: cupertino_icons
Current version: 1.0.9
Upgradable version: 1.0.9
Resolvable version: 2.0.0
Latest version: 2.0.0

The package was not upgraded because the current
constraint ^1.0.8 does not allow version 2.0.0.
A new major version may introduce breaking changes.

All six required packages were installed successfully.