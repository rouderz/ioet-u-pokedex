import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ioet_u_pokedex/utils/pokemon_colors.dart';

class PokemonImageDisplay extends StatelessWidget {
  final File? currentImage;
  final String originalImageUrl;
  final VoidCallback onCameraPressed;
  final VoidCallback onRefreshPressed;
  final int pokemonId;
  final String pokemonType;

  const PokemonImageDisplay({
    required this.currentImage,
    required this.originalImageUrl,
    required this.onCameraPressed,
    required this.onRefreshPressed,
    required this.pokemonId,
    required this.pokemonType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PokemonColors.getColorByType(pokemonType),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          currentImage != null
              ? Image.file(
                  currentImage!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: originalImageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 200,
                  width: 200,
                ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onCameraPressed,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: onRefreshPressed,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: Text(
              '#$pokemonId',
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
