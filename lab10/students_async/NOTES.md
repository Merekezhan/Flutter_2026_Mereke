
# Practice 10 — The Data Arrives Later

## Level 1 — Event Loop

### Predicted Order

```text
A
C
fetchStudents #1
B
6 students
```

### Actual Order

```text
A
C
fetchStudents #1
B
6 students
```

### Observation

The predicted and actual orders were the same.

- A and C appeared immediately.
- The API request started after C.
- After 2 seconds, B and 6 students appeared.
- Future.delayed() did not block the application.

### Conclusion

I learned how Future, async, await, and Future.delayed()
work in Dart.

Asynchronous operations allow the application to
continue running while waiting for data.

---

### Experiment 1 — Unhandled Exception

I called fetchStudents() three times.

Actual console output:

```text
A
C
fetchStudents #1
fetchStudents #2
fetchStudents #3
B
DartError: Instance of 'NoConnectionException'
```

### Observation

The third API request failed because FakeApi
throws an exception every third call.

### Conclusion

Unhandled asynchronous errors appear in the console.
We should use try/catch to handle these errors.

---

### Experiment 2 — Blocking the Event Loop

I temporarily replaced Future.delayed() with
a blocking while loop.

Actual console output:

```text
A
C
fetchStudents #1
fetchStudents #2
fetchStudents #3
Request 1: 6 students
Request 2: 6 students
B
DartError: Instance of 'NoConnectionException'
```

### Observation

The blocking loop prevented other events from running.

The timer callback B was delayed until the
blocking operations finished.

### Conclusion

A blocking loop prevents the event loop from
processing other tasks.

Future.delayed() allows asynchronous operations
without blocking the UI.

After the experiment, I restored Future.delayed().

---

## Level 2 — Four States by Hand

I implemented four UI states manually using
StatefulWidget and setState().

### Loading State

A loading indicator appears while the API
request is running.

### Data State

The application displays a list of 6 students.

### Error State

Every third API request throws
NoConnectionException.

The application displays an error screen.

### Retry

The Retry button starts a new API request.

After retrying, the students are displayed
successfully.

### Empty State

I tested FakeApi(empty: true).

The application displayed:

"No students yet"

After testing, I restored FakeApi().

---

### Experiment — Mounted Check

I temporarily removed both mounted checks
from the _load() method.

I opened the By hand screen and pressed Back
before the API request finished.

Actual error:

```text
DartError: setState() called after dispose()
```

### Observation

The API response arrived after the screen
had already been closed.

Flutter tried to update a disposed widget.

After restoring the mounted checks, the
error did not occur.

### Conclusion

The mounted check prevents setState() from
being called after the widget is disposed.

---

## Level 3 — FutureBuilder

I implemented FutureBuilder to display
asynchronous student data.

The Future was initialized once in initState().

### Correct Implementation

I stored the Future in the State object.

Switching Compact mode did not create
additional API requests.

Console output:

```text
fetchStudents #1
```

### Incorrect Implementation

I temporarily called fetchStudents()
directly inside build().

Each widget rebuild created another
API request.

The console showed multiple requests:

```text
fetchStudents #1
fetchStudents #2
fetchStudents #3
fetchStudents #4
fetchStudents #5
```

### Conclusion

A Future should be stored in State to avoid
unnecessary API calls during rebuilds.

After the experiment, I restored:

```dart
future: _future
```

---

## Level 4 — Countdown with Stream

I implemented a countdown using:

- Stream<int>
- async*
- yield
- Future.delayed()
- StreamBuilder

### Observation

The countdown started at 10 and decreased
by 1 every second until it reached 0.

The Restart button created a new Stream
and restarted the countdown from 10.

### Reopening the Screen

I opened Countdown and waited until
the number reached 5.

Then I pressed Back and opened Countdown again.

The countdown started again from 10.

### Conclusion

A Stream can provide multiple asynchronous values.

StreamBuilder listens to the Stream and updates
the UI when new values arrive.

Opening a new Countdown screen creates
a new Stream.

---

## Level 5 — Save and Error Handling

I implemented and tested asynchronous
saving using async/await.

The Save button calls FakeApi.save().

### Successful Save

The first Save operation completed successfully.

The application returned to the home screen.

### Failed Save

The second Save operation failed.

The application displayed a SnackBar:

```text
server rejected 6
```

The application remained on the Students screen.

### Retry Save

I pressed Save again.

The third Save operation completed successfully
and returned to the home screen.

### Conclusion

- try handles asynchronous operations.
- catch handles errors.
- finally resets the saving state.
- SnackBar displays an error message.
- The saving flag prevents repeated button presses.

The application can handle both successful
and failed asynchronous operations.

---

## Final Conclusion

In Practice 10, I learned how to work with
asynchronous operations in Flutter.

I practiced:

- Future, async, and await
- The Dart event loop
- Future.delayed()
- Exception handling
- StatefulWidget and setState()
- The mounted check
- FutureBuilder
- Stream and StreamBuilder
- Asynchronous saving with try/catch/finally

I learned how to manage loading, data,
empty, and error states in a Flutter application.

I also learned how to prevent unnecessary
API requests and handle asynchronous errors.
