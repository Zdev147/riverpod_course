import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const names = [
  'Name 1',
  'Name 2',
  'Name 3',
  'Name 4',
  'Name 5',
  'Name 6',
  'Name 7',
  'Name 8',
  'Name 9',
  'Name 10',
];

final tickerProvider = StreamProvider<int?>(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider((ref) {
  final tickStream = ref.watch(tickerProvider.stream);

    return tickStream.map((index) => names.getRange(0, index ?? 0));

});

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Names'),
      ),
      body: names.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(data.elementAt(i)),
          ),
        ),
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
