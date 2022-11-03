import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  lahore,
  karachi,
  islamabad,
  peshawar,
  quetta,
  multan,
}

typedef WeatherEmoji = String;

final weatherConditionEmojis = <WeatherEmoji>['☀', '🌧', '❄', '💨', '🌪', '🌨', '🌈'];
const WeatherEmoji unknownWeatherEmoji = '🤷';
const WeatherEmoji errorEmoji = '❌';

Future<WeatherEmoji> getWeather(City? city) async {
  final index = Random().nextInt(weatherConditionEmojis.length + 2);
  await Future.delayed(const Duration(seconds: 1));

  try {
    return weatherConditionEmojis[index];
  } catch (e) {
    return errorEmoji;
  }
}

final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city == null) {
    return unknownWeatherEmoji;
  } else {
    return getWeather(city);
  }
});

class WeatherApp extends ConsumerWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(currentCityProvider);
    final cityWeather = ref.watch(weatherProvider);

    const textStyle = TextStyle(fontSize: 40, color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: cityWeather.when(
              data: (data) => Text(data, style: textStyle),
              error: (error, stackTrace) => Text('Error $error', style: textStyle),
              loading: () => const CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (_, index) {
                final city = City.values[index];

                return ListTile(
                  title: Text(city.name.toLowerCase()),
                  trailing: selectedCity == city ? const Icon(Icons.check) : null,
                  onTap: () {
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
