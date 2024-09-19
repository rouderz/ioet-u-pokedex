import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ioet_u_pokedex/models/pokemon.dart';
import 'package:ioet_u_pokedex/service/pokemon_service.dart';
import 'package:ioet_u_pokedex/utils/pokemon_colors.dart';
import 'package:ioet_u_pokedex/utils/pokemon_stats.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PokemonInfoScreen extends StatefulWidget {
  final int pokemonId;

  const PokemonInfoScreen({super.key, required this.pokemonId});

  @override
  _PokemonInfoScreenState createState() => _PokemonInfoScreenState();
}

class _PokemonInfoScreenState extends State<PokemonInfoScreen> {
  late Future<Pokemon> futurePokemon;
  final PokemonService _pokemonService = PokemonService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    futurePokemon = _pokemonService.fetchPokemonById(widget.pokemonId);
  }

  Future<void> _requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }

    if (cameraStatus.isGranted) {
      _takePicture();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera or Storage permission denied")),
      );
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final Directory? appDir = await getExternalStorageDirectory();
      if (appDir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to access storage directory')),
        );
        return;
      }
      final String savePath = path.join(appDir.path, 'Pictures');
      final Directory directory = Directory(savePath);

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final String newPath = path.join(savePath, path.basename(file.path));
      final File newFile = await file.copy(newPath);

      if (newFile.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to Pictures folder')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving image')),
        );
      }
    }
  }

  void _onCameraIconPressed() {
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Details'),
      ),
      body: FutureBuilder<Pokemon>(
        future: futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return Column(
              children: <Widget>[
                Container(
                  color: PokemonColors.getColorByType(pokemon.types[0]),
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        height: 200,
                        width: 200,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: _onCameraIconPressed,
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
                        child: Text(
                          '#${pokemon.id}',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Text(
                          '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1).toLowerCase()}',
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (pokemon.weight != null)
                          const Text(
                            'Weight:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Text(
                          '${pokemon.weight} Pounds',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Stats:',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: pokemon.stats?.length ?? 0,
                            itemBuilder: (context, index) {
                              final stat = pokemon.stats![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          stat['stat_name']
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
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
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
