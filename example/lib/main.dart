import 'package:flutter/material.dart';
import 'package:interleaved_builder/interleaved_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (index) => index);
    final interleavedItems = List.generate(3, (index) => index);

    final itemBuilder = InterleavedBuilder(
      step: 2,
      initialOffset: 3,
      itemLength: items.length,
      interleavedItemLength: interleavedItems.length,
      // initialOffset: 0,
      itemBuilder: (context, interleaveIndex, listIndex) {
        return Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red,
            child: Text('Item ${items[interleaveIndex]}'),
          ),
        );
      },
      interleavedItemBuilder: (context, interleaveIndex, listIndex) {
        return Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: Text(
              'Interleaved Item ${interleavedItems[interleaveIndex]}',
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: ListView.builder(
        itemCount: itemBuilder.length,
        itemBuilder: itemBuilder.build,
      ),
    );
  }
}
