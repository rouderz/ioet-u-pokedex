import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ioet_u_pokedex/models/pokemon.dart';
import 'package:ioet_u_pokedex/screens/pokemon_info_screen.dart';
import 'package:ioet_u_pokedex/service/pokemon_service.dart';
import 'package:ioet_u_pokedex/utils/pokemon_colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Pokemon> _pokemons = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final PokemonService _pokemonService = PokemonService();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  Future<void> _loadPokemons({bool loadMore = false}) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (loadMore) _currentPage++;

      final newPokemons =
          await _pokemonService.fetchPokemons();
      if (newPokemons.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          _pokemons.addAll(newPokemons);
        });
      }
    } catch (e) {
      print('Error loading more Pokémon: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = _pokemons[index];
          final pokemonTypeColor =
              PokemonColors.getColorByType(pokemon.types.first);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonInfoScreen(pokemonId: pokemon.id),
                ),
              );
            },
            child: Card(
              color: pokemonTypeColor,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1).toLowerCase()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Types: ${pokemon.types.join(', ')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _hasMore
          ? FloatingActionButton(
              onPressed: () => _loadPokemons(loadMore: true),
              tooltip: 'Load more pokemons',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
