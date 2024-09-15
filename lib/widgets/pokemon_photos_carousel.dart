import 'dart:io';
import 'package:flutter/material.dart';

class PokemonPhotosCarousel extends StatelessWidget {
  final Map<int, File> pokemonImages;

  const PokemonPhotosCarousel({required this.pokemonImages, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: pokemonImages.isNotEmpty
          ? ListView.builder(
              itemCount: pokemonImages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              pokemonImages.values.elementAt(index),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      pokemonImages.values.elementAt(index),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            )
          : const Text('No pictures taken yet'),
    );
  }
}
