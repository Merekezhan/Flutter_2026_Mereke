
# Practice 9 — Put It High, Subscribe Low

## Level 1 — Lifted State

The cart was stored in Shell above MaterialApp.

Data was passed down through constructors, and callbacks were used to update the cart.

To add the total to the badge, I updated 2 constructors:
- BooksScreen
- CartBadge

Files changed:
- main.dart
- books_screen.dart
- cart_badge.dart

### Rebuild Test

BooksScreen build messages after one Add: [measure]
Row build messages after one Add: [measure]

## Level 2 — ChangeNotifier

I created a Cart model using ChangeNotifier.

The model stores books, calculates the total, prevents duplicates, and notifies listeners when data changes.

Model test result: 1 items, 3100 ₸

The items getter returns an unmodifiable list.

## Level 3 — Provider

I used ChangeNotifierProvider above MaterialApp.

context.watch subscribes to changes.
context.read accesses the model without subscribing.
Consumer rebuilds its builder when the model changes.

### Provider Experiments

Using watch in an event callback:
[insert the exact error message from your console]

Using read for the badge inside build:
No exception, but the badge did not update automatically.

## Level 4 — Rebuild Optimization

Badge rebuilds with watch after three quantity changes:
[measure]

Badge rebuilds with select after three quantity changes:
[measure]

context.select helps avoid unnecessary rebuilds when the selected value does not change.

## Level 5 — Where does it live?

Cart — provided state, because both screens need access to the same data.

Search text — ephemeral state, because only BooksScreen uses it.

Total expanded/collapsed — ephemeral state, because it belongs only to CartScreen.

Theme mode — lifted or provided state, because the whole application needs it.

## Conclusion

In this practice, I learned the difference between lifting state and using Provider.

I used ChangeNotifier, notifyListeners, context.watch, context.read, context.select, and Consumer.

I also learned how to reduce unnecessary widget rebuilds and separate business logic from UI.
