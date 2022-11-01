import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = (state ?? 0) + 1;
}

final counterProvider = StateNotifierProvider<Counter, num?>((ref) => Counter());

class CounterApp extends ConsumerWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Consumer(
          child: const Text('Count', style: TextStyle(fontSize: 30)),
          builder: (_, ref, child) {
            final count = ref.watch(counterProvider);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                child!,
                Text('${count ?? 0}', style: const TextStyle(fontSize: 30)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: ref.read(counterProvider.notifier).increment,
      ),
    );
  }
}
