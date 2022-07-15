import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interleaved_builder/interleaved_builder.dart';
import 'package:mocktail/mocktail.dart';

class MockBuildContext extends Mock implements BuildContext {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  final context = MockBuildContext();

  setUp(() {
    registerFallbackValue(FakeBuildContext());
  });

  group('InterleavedBuilder', () {
    test('should throw RangeError when index is out of range', () {
      final itemBuilder = InterleavedBuilder(
        step: 1,
        itemLength: 10,
        interleavedItemLength: 10,
        itemBuilder: (context, interleaveIndex, listIndex) {
          return 'item $interleaveIndex';
        },
        interleavedItemBuilder: (context, interleaveIndex, listIndex) {
          return 'interleaved $interleaveIndex';
        },
      );

      Object? error;
      try {
        itemBuilder.build(context, -1);
      } catch (e) {
        error = e;
      }
      expect(error is RangeError, true);

      error = null;

      try {
        itemBuilder.build(context, 21);
      } catch (e) {
        error = e;
      }

      expect(error is RangeError, true);
    });

    test('should return item when is on initial offset', () {
      const offset = 2;

      final itemBuilder = InterleavedBuilder(
        step: 1,
        initialOffset: offset,
        itemLength: 10,
        interleavedItemLength: 10,
        itemBuilder: (context, interleaveIndex, listIndex) {
          return 'item $interleaveIndex';
        },
        interleavedItemBuilder: (context, interleaveIndex, listIndex) {
          return 'interleaved $interleaveIndex';
        },
      );

      for (var i = 0; i < offset; i++) {
        expect(itemBuilder.build(context, i), 'item $i');
      }
      expect(itemBuilder.build(context, offset), 'interleaved 0');
    });

    test('initialOffset should be equal step', () {
      const step = 1;
      final itemBuilder = InterleavedBuilder(
        step: 1,
        itemLength: 10,
        interleavedItemLength: 10,
        itemBuilder: (context, interleaveIndex, listIndex) {
          return 'item $interleaveIndex';
        },
        interleavedItemBuilder: (context, interleaveIndex, listIndex) {
          return 'interleaved $interleaveIndex';
        },
      );

      for (var i = 0; i < step; i++) {
        expect(itemBuilder.build(context, i), 'item $i');
      }
      expect(itemBuilder.build(context, step), 'interleaved 0');
    });

    test('should start with interleaved item', () {
      final itemBuilder = InterleavedBuilder(
        step: 1,
        initialOffset: 0,
        itemLength: 10,
        interleavedItemLength: 10,
        itemBuilder: (context, interleaveIndex, listIndex) {
          return 'item $interleaveIndex';
        },
        interleavedItemBuilder: (context, interleaveIndex, listIndex) {
          return 'interleaved $interleaveIndex';
        },
      );

      expect(itemBuilder.build(context, 0), 'interleaved 0');
      expect(itemBuilder.build(context, 1), 'item 0');
    });
  });
}
