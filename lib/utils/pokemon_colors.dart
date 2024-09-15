import 'package:flutter/material.dart';

class PokemonColors {
  static Color getColorByType(String type) {
    switch (type) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.orange;
      case 'psychic':
        return Colors.purple;
      case 'rock':
        return Colors.brown;
      case 'ground':
        return const Color.fromARGB(255, 165, 153, 46);
      case 'ice':
        return Colors.lightBlueAccent;
      case 'poison':
        return Colors.deepPurpleAccent;
      case 'bug':
        return Colors.lightGreen;
      case 'flying':
        return Colors.lightBlue;
      case 'fighting':
        return Colors.orangeAccent;
      case 'fairy':
        return Colors.pinkAccent;
      case 'dragon':
        return Colors.indigo;
      case 'ghost':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}
