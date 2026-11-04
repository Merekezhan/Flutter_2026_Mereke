# Practice 9 — Put It High, Subscribe Low

## Level 1 — Lifting State Up

In the first version, the cart state was stored in the `Shell` widget above `MaterialApp`.

The cart data was passed to `BooksScreen` and `CartScreen` through constructor parameters and callbacks.

I used `setState()` to update the cart when a book was added or removed.

**Observation:**

The console displayed `BooksScreen build`, `badge build`, and messages for the book rows. This demonstrated how rebuilding the parent widget can affect its child widgets.

## Level 2 — ChangeNotifier Model

I created two model files:

- `models/book.dart` — stores book information.
- `models/cart.dart` — manages the shopping cart.

The `Cart` class extends `ChangeNotifier` and stores book quantities using `Map<Book, int>`.

The model includes:

- `add()` — adds a new book and prevents duplicates.
- `increment()` — increases the quantity of a book.
- `remove()` — removes a book.
- `clear()` — clears the shopping cart.
- `qtyOf()` — returns the quantity of a book.
- `count` — returns the number of distinct books.
- `total` — calculates the total price.

The `items` getter returns an unmodifiable list to prevent external changes.

The model calls `notifyListeners()` after successful changes.

## Level 3 — Provider

I used the `provider` package to manage shared application state.

`ChangeNotifierProvider` creates and provides the `Cart` model to the application.

I used three Provider methods:

- `context.watch<Cart>()` — listens to changes and rebuilds the widget.
- `context.read<Cart>()` — accesses the model without subscribing to changes.
- `context.select<Cart, int>()` — listens only to a selected value.

**Provider usage rules:**

`context.read()` is suitable for button callbacks.

`context.watch()` and `context.select()` are used when a widget needs to react to state changes.

Using `context.watch()` in an event callback is incorrect because listening should happen during the widget build process.

Using `context.read()` to display a changing value does not automatically rebuild the widget when that value changes.

## Level 4 — Quantities and Rebuild Experiment

I implemented book quantities using `Map<Book, int>`.

When the user presses `+`, the quantity increases and the total price is recalculated.

The cart badge displays the number of distinct books, not the total number of copies.

### Experiment: context.watch vs context.select

I added `debugPrint()` to `CartBadge` to observe widget rebuilds.

I added two different books to the cart and pressed the `+` button four times.

| Method | Quantity changes | Observed badge builds |
|---|---:|---:|
| `context.watch<Cart>().count` | 4 | 4 |
| `context.select<Cart, int>((cart) => cart.count)` | 4 | 4 |

**Observation:**

Both experiments produced four badge build messages during the test.

The `context.watch()` method subscribes to all notifications from `Cart`.

The `context.select()` method subscribes only to the selected `count` value. However, the badge can still rebuild when its parent widget rebuilds.

In this implementation, the observed results did not demonstrate a reduction in badge rebuilds.

**Conclusion:**

`context.select()` can reduce unnecessary rebuilds caused by Provider notifications, but it does not prevent rebuilds triggered by parent widgets.

## Level 5 — User Experience and State Separation

I implemented the following features:

- Search books by title or author.
- Show a SnackBar after successfully adding a book.
- Increase book quantity in the cart.
- Remove books from the cart.
- Show a confirmation dialog before clearing the cart.
- Expand or collapse the total price section.

### Where Does It Live?

| State or behavior | Location |
|---|---|
| Book information | `models/book.dart` |
| Cart items and quantities | `models/cart.dart` |
| Total price calculation | `models/cart.dart` |
| Search text | `books_screen.dart` |
| Cart badge count | `cart_badge.dart` |
| Expanded/collapsed total | `cart_screen.dart` |
| SnackBar | `books_screen.dart` |
| Confirmation dialog | `cart_screen.dart` |

The cart model contains business logic, while the widgets manage the user interface and temporary UI state.

## Testing and Validation

I used Flutter commands to check the application:

- `flutter analyze` — checked for code issues.
- `flutter test` — ran automated tests.
- `dart format .` — formatted the Dart code.

I also manually tested adding books, increasing quantities, calculating totals, removing books, clearing the cart, and searching.

The application worked during manual testing.

## Final Conclusion

In this practice, I learned how to move from `setState()` and passing data through constructors to shared state management with Provider.

I implemented a `ChangeNotifier` cart model, book quantities, reactive UI updates, and basic user interactions.

The rebuild experiment helped me understand the difference between `context.watch()` and `context.select()` and the influence of parent widget rebuilds.