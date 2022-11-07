import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String uid, name, age;

  const Person({
    required this.uid,
    required this.name,
    required this.age,
  });

  Person copyWith({
    String? name,
    String? age,
  }) {
    return Person(
      uid: uid,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Person && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() => '$name ($age years old)';
}

class PersonsNotifier extends ChangeNotifier {
  final List<Person> _persons = <Person>[];

  int get count => _persons.length;

  UnmodifiableListView<Person> get persons => UnmodifiableListView(_persons);

  void add(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _persons.remove(person);
    notifyListeners();
  }

  void update(Person person) {
    final index = _persons.indexOf(person);
    if (index == -1) return;

    _persons[index] = person;
    notifyListeners();
  }
}

final personNotifierProvider = ChangeNotifierProvider((ref) => PersonsNotifier());

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Person'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddPersonDialog(context).then((person) {
          if (person != null) ref.read(personNotifierProvider).add(person);
        }),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final notifier = ref.watch(personNotifierProvider);

          return ListView.builder(
            itemCount: notifier.count,
            itemBuilder: (_, index) {
              final person = notifier.persons[index];

              return ListTile(
                title: Text(person.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => ref.read(personNotifierProvider).remove(person),
                ),
                onTap: () => _showAddPersonDialog(context, person).then((updatedPerson) {
                  if (updatedPerson != null) ref.read(personNotifierProvider).update(updatedPerson);
                }),
              );
            },
          );
        },
      ),
    );
  }
}

Future<Person?> _showAddPersonDialog(BuildContext context, [Person? person]) async {
  final nameCon = TextEditingController(text: person?.name);
  final ageCon = TextEditingController(text: (person?.age ?? '').toString());

  return showDialog<Person?>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(person == null ? 'Create Person' : 'Update Person'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCon,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: ageCon,
            decoration: const InputDecoration(hintText: 'Age'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(person == null ? 'Create' : 'Update'),
          onPressed: () {
            if (person == null) {
              Navigator.pop(
                context,
                Person(
                  uid: const Uuid().v4(),
                  name: nameCon.text.trim(),
                  age: ageCon.text.trim(),
                ),
              );
            } else {
              Navigator.pop(
                context,
                person.copyWith(
                  name: nameCon.text.trim(),
                  age: ageCon.text.trim(),
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}
