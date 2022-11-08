class Movie {
  final String id, name, description;
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.name,
    required this.description,
    this.isFavorite = false,
  });

  Movie copyWith({bool? isFavorite}) {
    return Movie(
      id: id,
      name: name,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const movies = [
  Movie(
    id: '1',
    name: 'House of the Dragon',
    description: 'An internal succession war within House Targaryen at the height of its power, 172 years before the birth of Daenerys Targaryen.',
  ),
  Movie(
    id: '2',
    name: 'The Watcher',
    description: 'A married couple moving into their dream home are threatened by terrifying letters from a stalker, signed.',
  ),
  Movie(
    id: '3',
    name: 'Luckiest Girl Alive',
    description: 'A woman in New York, who seems to have things under control, is faced with a trauma that makes her life unravel.',
  ),
  Movie(
    id: '4',
    name: 'Mr. Harrigan\'s Phone',
    description: 'When Mr. Harrigan dies, Craig, the teen who befriended and did odd jobs for him, puts his smart phone in his pocket before burial.'
        ' When the lonely youth sends his dead friend a message, he is shocked to get a return text.',
  ),
  Movie(
    id: '5',
    name: 'The Good Nurse',
    description: 'An infamous caregiver is implicated in the deaths of hundreds of hospital patients.',
  ),
];
