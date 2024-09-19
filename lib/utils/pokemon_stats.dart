import 'package:flutter/material.dart';

String getStatImage(String statName) {
  switch (statName.toLowerCase()) {
    case 'hp':
      return 'assets/images/stats/hp.png';
    case 'attack':
      return 'assets/images/stats/attack.png';
    case 'defense':
      return 'assets/images/stats/defense.png';
    case 'speed':
      return 'assets/images/stats/speed.png';
    case 'special-attack':
      return 'assets/images/stats/special_attack.png';
    case 'special-defense':
      return 'assets/images/stats/special_defense.png';
    default:
      return 'assets/images/default.png';
  }
}
