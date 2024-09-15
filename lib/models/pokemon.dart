class Pokemon {
  final String name;
  final String url;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = url.split('/').reversed.elementAt(1);
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      name: json['name'],
      url: url,
      imageUrl: imageUrl,
      types: [],
    );
  }
}
