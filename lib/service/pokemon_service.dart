import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  int _limit = 50;
  int _offset = 0;

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?limit=$_limit&offset=$_offset'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final pokemons = await Future.wait(
          results.map((json) => _fetchPokemonDetails(Pokemon.fromJson(json))));

      _offset += _limit;
      return pokemons;
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  Future<Pokemon> _fetchPokemonDetails(Pokemon pokemon) async {
    final response = await http.get(Uri.parse(pokemon.url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final types = (data['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList();

      return Pokemon(
        id: pokemon.id,
        name: pokemon.name,
        url: pokemon.url,
        imageUrl: pokemon.imageUrl,
        types: types,
      );
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  Future<Pokemon> fetchPokemonById(int id) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final types = (data['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList();

      final stats = (data['stats'] as List).map((stat) {
        return {
          'stat_name': stat['stat']['name'],
          'base_stat': stat['base_stat'],
        };
      }).toList();

      return Pokemon(
        id: data['id'],
        name: data['name'],
        url: 'https://pokeapi.co/api/v2/pokemon/$id',
        imageUrl: data['sprites']['front_default'],
        types: types,
        stats: stats,
        weight: data['weight']
      );
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  Future<List<Pokemon>> fetchMorePokemons() async {
    return await fetchPokemons();
  }
}
