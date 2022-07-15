library interleaved_builder;

import 'package:flutter/material.dart';

typedef InterleavedItemBuilder<T> = T Function(
  BuildContext context,
  int interleaveIndex,
  int listIndex,
);

class InterleavedBuilder<T> {
  /// Steps to build the interleaved widget.
  final int step;

  /// Initial offset to build the interleaved widget.
  final int initialOffset;

  /// Items quantity.
  final int itemLength;

  /// Interleaved items quantity.
  final int interleavedItemLength;

  /// The builder for the items.
  final InterleavedItemBuilder<T> itemBuilder;

  /// The builder for the interleaved widget.
  final InterleavedItemBuilder<T> interleavedItemBuilder;

  /// Total items length (items + interleaved items)
  int get length => itemLength + interleavedItemLength;

  /// Interleaving item max index
  int get _maxInterleavingItemIndex => interleavedItemLength * step - step + initialOffset;

  /// Interleaving items quantity that can be showed interleaving with items
  int get _maxInterleavingItems => ((itemLength) / step).truncate() + 1 - initialOffset;

  /// Items quantity (items + interleavingItems) that can be showed interleaving
  int get _maxItemsInterleaved => itemLength + _maxInterleavingItems;

  const InterleavedBuilder({
    required int step,
    int? initialOffset,
    required this.itemLength,
    required this.interleavedItemLength,
    required this.itemBuilder,
    required this.interleavedItemBuilder,
  })  : step = step + 1,
        initialOffset = initialOffset ?? step,
        assert(step > 0, 'step must be greater than 0'),
        assert((initialOffset ?? 0) >= 0, 'initialOffset must be greater than or equal to 0'),
        assert(itemLength >= 0, 'itemLength must be greater than or equal to 0'),
        assert(interleavedItemLength >= 0, 'interleavedItemLength must be greater than or equal to 0'),
        assert(itemLength > 0 || interleavedItemLength > 0, 'itemLength or interleavedItemLength must be greater than 0');

  /// Generate list with interleaved items
  List<T> list(BuildContext context, {bool growable = true}) {
    return List.generate(
      length,
      (index) => build(context, index),
      growable: growable,
    );
  }

  /// Build the item at the given index.
  T build(BuildContext context, int index) {
    if (index > length || index < 0) throw RangeError.range(index, 0, length - 1);

    final isInitialOffset = index < initialOffset;
    final shouldInitialOffset = isInitialOffset && index < itemLength;

    // If index is less than initial offset, then needs to build item
    if (shouldInitialOffset) {
      return itemBuilder(context, index, index);
    }

    // should build initial offset item but index is greater than item length
    final cantInitialOffset = isInitialOffset && !shouldInitialOffset;

    final isInterleavingItemIndex = (index - initialOffset) % step == 0 || cantInitialOffset;

    var interleavingItemIndex = ((index - initialOffset) / step).truncate();
    var itemIndex = index - (interleavingItemIndex + 1);

    final canShowItem = itemIndex < itemLength;
    final canShowInterleavingItem = interleavingItemIndex < interleavedItemLength;

    final shouldShowInterleavingItem = (canShowInterleavingItem && isInterleavingItemIndex) || !canShowItem;

    if (shouldShowInterleavingItem) {
      /// Verify that should be show item and if already showed all of them
      if (!isInterleavingItemIndex || !canShowItem) {
        /// Adjust interleaving item index case all items already had been showed
        interleavingItemIndex = _maxInterleavingItems + (index - _maxItemsInterleaved);
      }

      /// Build interleaved item
      return interleavedItemBuilder(context, interleavingItemIndex, index);
    }

    /// Verify if [index] is greater than [_maxInterleavingItemIndex]
    if (index > _maxInterleavingItemIndex) {
      /// Diff between [index] with last showed [interleavingItemIndex]
      final indexDiff = index - (_maxInterleavingItemIndex);

      /// Interleaving items quantity that has not been showed
      final bannerMissed = (indexDiff / step).truncate();

      /// Adjust [itemIndex] case has already showed all interleaving items
      itemIndex = itemIndex + bannerMissed;
    }

    /// Build item
    return itemBuilder(context, itemIndex, index);
  }
}
