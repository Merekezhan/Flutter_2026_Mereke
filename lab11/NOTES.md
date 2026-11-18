
# Practice 11 — A Real Server

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
