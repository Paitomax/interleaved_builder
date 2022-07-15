Interleave your items easily.

## Usage

To use this package, add `interleaved_builder` as a dependency in your project yaml file.


- You can generate a `List<T>` calling `list` method:

```dart
final list = InterleavedBuilder(
...
).list(context);
```

- Build item passing index calling `build` method (useful for ListView):

```
InterleavedBuilder(
...
).build(context, index);
```

**InterleavedBuilder** params:

`step:` Steps to interleave your items.

`initialOffset:` Initial offset to begin interleaving, if not set, it will be equal `step`.

`itemLength:` Quantity of items

`interleavedItemLength:` Quantity of items to interleave

`itemBuilder:` Item builder method

`interleavedItemBuilder:` Interleaved item builder method


## Examples

Example using `list` method:

```dart
final items = List.generate(10, (index) => index);
final interleavedItems = List.generate(3, (index) => index);

final itemBuilder = InterleavedBuilder(
  step: 2,
  initialOffset: 3,
  itemLength: items.length,
  interleavedItemLength: interleavedItems.length,
  itemBuilder: (context, interleaveIndex, listIndex) {
    return items[interleaveIndex];
  },
  interleavedItemBuilder: (context, interleaveIndex, listIndex) {
    return interleavedItems[interleaveIndex];
  },
);
final interleavedList = itemBuilder.list(context);
```

---

Example using `build` method:

```dart
final items = List.generate(10, (index) => index);
final interleavedItems = List.generate(3, (index) => index);

final itemBuilder = InterleavedBuilder(
  step: 2,
  initialOffset: 3,
  itemLength: items.length,
  interleavedItemLength: interleavedItems.length,
  itemBuilder: (context, interleaveIndex, listIndex) {
    return Text('item ${items[interleaveIndex]}');
  },
  interleavedItemBuilder: (context, interleaveIndex, listIndex) {
    return Text('interleavedItems ${interleavedItems[interleaveIndex]}');
  },
);

return Scaffold(
body: ListView.builder(
itemCount: itemBuilder.length,
itemBuilder: itemBuilder.build,
),
);
```