class Pokemon {
  final int id;
  final String name;
  final String url;
  final String imageUrl;
  final List<String> types;
  final List<Map<String, dynamic>>? stats;
  final int? weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.types,
    this.stats,
    this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = url.split('/').reversed.elementAt(1);
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: int.parse(id),
      name: json['name'],
      url: url,
      imageUrl: imageUrl,
      types: [],
      stats: [],
      weight: 10,
    );
  }
}
