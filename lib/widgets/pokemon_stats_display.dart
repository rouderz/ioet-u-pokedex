import 'package:flutter/material.dart';
import 'package:ioet_u_pokedex/models/pokemon.dart';
import 'package:ioet_u_pokedex/utils/pokemon_stats.dart';

class PokemonStatsDisplay extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonStatsDisplay({required this.pokemon, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1).toLowerCase()}',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Weight: ",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${pokemon.weight} Pounds',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            'Stats:',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: pokemon.stats?.length ?? 0,
              itemBuilder: (context, index) {
                final stat = pokemon.stats![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            getStatImage(stat['stat_name']),
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 25),
                          Text(
                            stat['stat_name'].toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        stat['base_stat'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
