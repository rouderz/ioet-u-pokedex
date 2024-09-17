import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ioet_u_pokedex/models/pokemon.dart';
import 'package:ioet_u_pokedex/service/pokemon_service.dart';
import 'package:ioet_u_pokedex/widgets/pokemon_image_display.dart';
import 'package:ioet_u_pokedex/widgets/pokemon_stats_display.dart';
import 'package:ioet_u_pokedex/widgets/pokemon_photos_carousel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

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
  Map<int, File> _pokemonImages = {};
  File? _currentPokemonImage;
  String? _originalPokemonImageUrl;

  @override
  void initState() {
    super.initState();
    futurePokemon = _pokemonService.fetchPokemonById(widget.pokemonId);
    _loadSavedImages();
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

      final String newPath = path.join(savePath,
          '${widget.pokemonId}_${DateTime.now().millisecondsSinceEpoch}.png');
      final File newFile = await file.copy(newPath);

      if (newFile.existsSync()) {
        setState(() {
          int newKey = _pokemonImages.length + 1;
          _pokemonImages[newKey] = newFile;
          _currentPokemonImage = newFile;
        });
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

  Future<void> _loadSavedImages() async {
    final Directory? appDir = await getExternalStorageDirectory();
    if (appDir != null) {
      final String savePath = path.join(appDir.path, 'Pictures');
      final Directory directory = Directory(savePath);

      if (directory.existsSync()) {
        final List<File> images = directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.contains('${widget.pokemonId}_'))
            .toList();

        setState(() {
          int index = 1;
          for (var image in images) {
            _pokemonImages[index] = image;
            index++;
          }
          _currentPokemonImage = _pokemonImages[widget.pokemonId];
        });
      }
    }
  }

  void _onCameraIconPressed() {
    _requestPermissions();
  }

  void _onRefreshIconPressed() {
    setState(() {
      _currentPokemonImage = null;
    });
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
            _originalPokemonImageUrl ??= pokemon.imageUrl;
            return Column(
              children: <Widget>[
                PokemonImageDisplay(
                  currentImage: _currentPokemonImage,
                  originalImageUrl: _originalPokemonImageUrl!,
                  onCameraPressed: _onCameraIconPressed,
                  onRefreshPressed: _onRefreshIconPressed,
                  pokemonId: pokemon.id,
                  pokemonType: pokemon.types[0],
                ),
                PokemonStatsDisplay(pokemon: pokemon),
                PokemonPhotosCarousel(pokemonImages: _pokemonImages),
              ],
            );
          }
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
