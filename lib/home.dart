import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_course/movie.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add To Favorite'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(builder: (context, ref, child) {
            final status = ref.watch(favoriteStatusProvider);
            switch (status) {
              case FavoriteStatus.all:
                return MoviesListWidget(provider: allMoviesProvider);
              case FavoriteStatus.favorite:
                return MoviesListWidget(provider: favoriteMoviesProvider);
              case FavoriteStatus.notFavorite:
                return MoviesListWidget(provider: notFavoriteMoviesProvider);
              default:
                return MoviesListWidget(provider: allMoviesProvider);
            }
          }),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------

enum FavoriteStatus { all, favorite, notFavorite }

final favoriteStatusProvider = StateProvider((ref) => FavoriteStatus.all);

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => DropdownButton<FavoriteStatus>(
        value: ref.watch(favoriteStatusProvider),
        items: FavoriteStatus.values
            .map((status) => DropdownMenuItem(
                  child: Text(status.name),
                  value: status,
                ))
            .toList(),
        onChanged: (status) {
          if (status != null) ref.read(favoriteStatusProvider.notifier).state = status;
        },
      ),
    );
  }
}

/// ---------------------------------------------------------------

class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier() : super(movies);

  void update(Movie movie, bool isFavorite) {
    state = state.map((e) {
      if (e == movie) {
        return e.copyWith(isFavorite: isFavorite);
      } else {
        return e;
      }
    }).toList();
  }
}

final allMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) => MoviesNotifier(),
);

final favoriteMoviesProvider = Provider(
  (ref) => ref.watch(allMoviesProvider).where((element) => element.isFavorite),
);

final notFavoriteMoviesProvider = Provider(
  (ref) => ref.watch(allMoviesProvider).where((element) => !element.isFavorite),
);

class MoviesListWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Movie>> provider;

  const MoviesListWidget({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(provider);

    return Expanded(
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (_, index) {
          final movie = movies.elementAt(index);
          final favIcon = movie.isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border);

          return ListTile(
            title: Text(movie.name),
            subtitle: Text(movie.description),
            trailing: IconButton(
              icon: favIcon,
              onPressed: () {
                ref.read(allMoviesProvider.notifier).update(movie, !movie.isFavorite);
              },
            ),
          );
        },
      ),
    );
  }
}
