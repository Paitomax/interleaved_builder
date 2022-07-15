# [Interleaved Builder](https://pub.dev/packages/interleaved_builder)

Interleave your items easily.

## How to Use

```yaml
# add this line to your dependencies
interleaved_builder: ^0.0.1
```

```dart
import 'package:interleaved_builder/interleaved_builder.dart';
```


| property                 | description                                                                | type                              | default          |
| -------------------------|----------------------------------------------------------------------------|-----------------------------------|------------------|
| `step`                   | Steps to interleave your items.                                            | `int`                             | required         |
| `initialOffset`          | Initial offset to begin interleaving, if not set, it will be equal `step`. | `int?`                            | same than `step` |
| `itemLength`             | Quantity of items                                                          | `int`                             | required         |
| `interleavedItemLength`  | Quantity of items to interleave                                            | `int`                             | required         |
| `itemBuilder`            | Item builder method                                                        | `Widget (BuildContext, int, int)` | required         |
| `interleavedItemBuilder` | Interleaved item builder method                                            | `Widget (BuildContext, int, int)` | required         |


## Usage Examples

Generate a `List<T>` calling `list` method:

```dart
final list = List.generate(10, (index) => index);
final anotherList = List.generate(3, (index) => index);

final itemBuilder = InterleavedBuilder(
  step: 2,
  initialOffset: 3,
  itemLength: list.length,
  interleavedItemLength: anotherList.length,
  itemBuilder: (context, interleaveIndex, listIndex) {
    return list[interleaveIndex];
  },
  interleavedItemBuilder: (context, interleaveIndex, listIndex) {
    return anotherList[interleaveIndex];
  },
);
final interleavedList = itemBuilder.list(context);
```

Build item passing index, calling `build` method (useful for ListView):

```dart
final list = List.generate(10, (index) => index);
final anotherList = List.generate(3, (index) => index);

final itemBuilder = InterleavedBuilder(
  step: 2,
  initialOffset: 3,
  itemLength: list.length,
  interleavedItemLength: anotherList.length,
  itemBuilder: (context, interleaveIndex, listIndex) {
    return Text('list ${list[interleaveIndex]}');
  },
  interleavedItemBuilder: (context, interleaveIndex, listIndex) {
    return Text('anotherList ${anotherList[interleaveIndex]}');
  },
);

return Scaffold(
  body: ListView.builder(
    itemCount: itemBuilder.length,
    itemBuilder: itemBuilder.build,
  ),
);
```