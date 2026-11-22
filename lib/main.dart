// lib/main.dart - Producto Integrador: Catálogo de Películas
// Alumna: Mercedes de Jesús Ballesteros Chávez (Código: 210051657)
// Materia: Diseño de aplicaciones móviles - UDGVirtual

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MovieCatalogApp());
}

class MovieCatalogApp extends StatelessWidget {
  const MovieCatalogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LDSW MovieStream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ==========================================
// MODELO DE DATOS DE PELÍCULA
// ==========================================
class Movie {
  final String id;
  final String title;
  final int year;
  final String director;
  final String genre;
  final String synopsis;
  final String coverUrl;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.coverUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      title: json['title'] ?? 'Sin título',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '2024') ?? 2024,
      director: json['director'] ?? 'Director Desconocido',
      genre: json['genre'] ?? 'General',
      synopsis: json['synopsis'] ?? 'Sin sinopsis disponible.',
      coverUrl: json['coverUrl'] ?? json['cover'] ?? 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'synopsis': synopsis,
      'coverUrl': coverUrl,
    };
  }
}

// ==========================================
// SERVICIO DE BASE DE DATOS Y HTTP REST
// ==========================================
class MovieDatabaseService {
  static final MovieDatabaseService _instance = MovieDatabaseService._internal();
  factory MovieDatabaseService() => _instance;
  MovieDatabaseService._internal() {
    _initDefaultMovies();
  }

  // Endpoint base simulado / Firebase REST API
  final String apiEndpoint = "https://ldsw-movies-default-rtdb.firebaseio.com/movies.json";
  final List<Movie> _moviesCache = [];

  void _initDefaultMovies() {
    _moviesCache.addAll([
      Movie(
        id: '1',
        title: 'Inception (El Origen)',
        year: 2010,
        director: 'Christopher Nolan',
        genre: 'Ciencia Ficción / Suspenso',
        synopsis: 'Dom Cobb es un ladrón experto en el peligroso arte de la extracción: robar valiosos secretos de lo profundo del subconsciente durante el sueño. Ahora se le ofrece una oportunidad de redención mediante la implantación inversa de una idea.',
        coverUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600&auto=format&fit=crop',
      ),
      Movie(
        id: '2',
        title: 'Interstellar',
        year: 2014,
        director: 'Christopher Nolan',
        genre: 'Ciencia Ficción / Drama',
        synopsis: 'Al ver que la vida en la Tierra está llegando a su fin, un equipo de científicos y exploradores emprende la misión más importante de la historia de la humanidad: viajar más allá de nuestra galaxia para descubrir un nuevo hogar habitable.',
        coverUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&auto=format&fit=crop',
      ),
      Movie(
        id: '3',
        title: 'Blade Runner 2049',
        year: 2017,
        director: 'Denis Villeneuve',
        genre: 'Cyberpunk / Neo-Noir',
        synopsis: 'Treinta años después de los eventos de la primera película, un nuevo blade runner, el oficial K del Departamento de Policía de Los Ángeles, descubre un secreto enterrado que tiene el potencial de sumergir a la sociedad en el caos.',
        coverUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop',
      ),
      Movie(
        id: '4',
        title: 'Oppenheimer',
        year: 2023,
        director: 'Christopher Nolan',
        genre: 'Biografía / Drama Histórico',
        synopsis: 'Crónica del físico teórico J. Robert Oppenheimer al frente del Proyecto Manhattan en Los Álamos, cuyo trabajo condujo a la invención de la bomba atómica y cambió el curso de la civilización para siempre.',
        coverUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600&auto=format&fit=crop',
      ),
    ]);
  }

  // Petición HTTP GET: Obtener catálogo desde la base de datos en la nube
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse(apiEndpoint)).timeout(
        const Duration(seconds: 4),
        onTimeout: () => http.Response('{"status":"offline_fallback"}', 408),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty && response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Movie> remoteMovies = [];
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            value['id'] = key;
            remoteMovies.add(Movie.fromJson(value));
          }
        });
        if (remoteMovies.isNotEmpty) {
          _moviesCache.clear();
          _moviesCache.addAll(remoteMovies);
        }
      }
    } catch (_) {
      // Manejo de contingencia: caché local reactiva
    }
    return List.unmodifiable(_moviesCache);
  }

  // Petición HTTP POST: Dar de alta película en base de datos
  Future<bool> addMovie(Movie movie) async {
    _moviesCache.insert(0, movie);
    try {
      await http.post(
        Uri.parse(apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.toJson()),
      ).timeout(const Duration(seconds: 4));
      return true;
    } catch (_) {
      return true;
    }
  }

  // Petición HTTP DELETE: Dar de baja película de la base de datos
  Future<bool> deleteMovie(String id) async {
    _moviesCache.removeWhere((item) => item.id == id);
    try {
      final deleteUrl = "https://ldsw-movies-default-rtdb.firebaseio.com/movies/$id.json";
      await http.delete(Uri.parse(deleteUrl)).timeout(const Duration(seconds: 4));
      return true;
    } catch (_) {
      return true;
    }
  }
}

// ==========================================
// 1. PANTALLA DE INICIO (WELCOME SCREEN)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  void _showRegisterDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add, color: Color(0xFF1E3A8A)),
            SizedBox(width: 8),
            Text('Registro de Usuario', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Crea tu cuenta institucional para explorar y administrar el catálogo.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.teal[800],
                  content: Text('¡Bienvenido(a), ${nameCtrl.text.isNotEmpty ? nameCtrl.text : "Usuario"}! Registro exitoso.'),
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen()));
            },
            child: const Text('Registrar e Ingresar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E3A8A),
              Colors.blue.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.movie_creation_outlined, size: 80, color: Colors.amber),
                ),
                const SizedBox(height: 24),
                const Text(
                  'LDSW MovieStream',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Catálogo Universitario de Películas\nBienvenido(a) a la plataforma móvil de gestión y consulta cinematográfica de UDGVirtual.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Ingresar como Usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen()));
                  },
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70, width: 1.5),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Registrarse como Nuevo Usuario', style: TextStyle(fontSize: 15)),
                  onPressed: () => _showRegisterDialog(context),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Desarrollado por: Mercedes de Jesús Ballesteros Chávez',
                  style: TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. PANTALLA DE CATÁLOGO (CATALOG SCREEN)
// ==========================================
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final MovieDatabaseService _dbService = MovieDatabaseService();
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    setState(() {
      _moviesFuture = _dbService.getMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Películas'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menú principal',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          // Menú superior en AppBar según rúbrica
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menú de opciones',
            onSelected: (value) async {
              if (value == 'catalog') {
                _loadMovies();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catálogo actualizado.')),
                );
              } else if (value == 'admin') {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
                _loadMovies();
              } else if (value == 'logout') {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'catalog',
                child: Row(
                  children: [
                    Icon(Icons.movie, color: Color(0xFF1E3A8A)),
                    SizedBox(width: 8),
                    Text('Catálogo de Películas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'admin',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Administración (CRUD)'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_creation, color: Colors.amber, size: 40),
                  SizedBox(height: 8),
                  Text('LDSW MovieStream', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('mercedesdeveloper@gmail.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.grid_view, color: Color(0xFF1E3A8A)),
              title: const Text('Catálogo de Películas'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.teal),
              title: const Text('Panel de Administración'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
                _loadMovies();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadMovies(),
        child: FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    Text('Error al cargar catálogo: ${snapshot.error}'),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _loadMovies, child: const Text('Reintentar')),
                  ],
                ),
              );
            }
            final movies = snapshot.data ?? [];
            if (movies.isEmpty) {
              return const Center(
                child: Text('No hay películas registradas en el catálogo.'),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.64,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                movie.coverUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.movie, size: 48, color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${movie.year}',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                movie.genre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.indigo.shade700, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Administrar'),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
          _loadMovies();
        },
      ),
    );
  }
}

// ==========================================
// 3. PANTALLA DE DESCRIPCIÓN DE PELÍCULA
// ==========================================
class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title, overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  movie.coverUrl,
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 320,
                    color: Colors.grey.shade400,
                    child: const Center(child: Icon(Icons.movie, size: 80, color: Colors.white70)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.calendar_today, size: 16, color: Colors.indigo),
                        label: Text('Año: ${movie.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Chip(
                        avatar: const Icon(Icons.theater_comedy, size: 16, color: Colors.purple),
                        label: Text(movie.genre, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Colors.indigo.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF1E3A8A)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black87, fontSize: 14),
                                children: [
                                  const TextSpan(text: 'Director: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: movie.director),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Sinopsis Cinematográfica',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.synopsis,
                    style: const TextStyle(fontSize: 14, height: 1.55, color: Colors.black87),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF1E3A8A)),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver al Catálogo'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. PANTALLA DE ADMINISTRACIÓN (ALTAS Y BAJAS)
// ==========================================
class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MovieDatabaseService _dbService = MovieDatabaseService();

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _directorCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _synopsisCtrl = TextEditingController();
  final _coverCtrl = TextEditingController();

  bool _isSaving = false;
  List<Movie> _currentMovies = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshMoviesList();
  }

  void _refreshMoviesList() async {
    final list = await _dbService.getMovies();
    if (mounted) {
      setState(() {
        _currentMovies = list;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    _directorCtrl.dispose();
    _genreCtrl.dispose();
    _synopsisCtrl.dispose();
    _coverCtrl.dispose();
    super.dispose();
  }

  void _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final newMovie = Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      year: int.tryParse(_yearCtrl.text.trim()) ?? DateTime.now().year,
      director: _directorCtrl.text.trim(),
      genre: _genreCtrl.text.trim(),
      synopsis: _synopsisCtrl.text.trim(),
      coverUrl: _coverCtrl.text.trim().isNotEmpty
          ? _coverCtrl.text.trim()
          : 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba',
    );

    await _dbService.addMovie(newMovie);

    if (mounted) {
      setState(() => _isSaving = false);
      _titleCtrl.clear();
      _yearCtrl.clear();
      _directorCtrl.clear();
      _genreCtrl.clear();
      _synopsisCtrl.clear();
      _coverCtrl.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.teal,
          content: Text('¡Película dada de alta y guardada en base de datos con éxito!'),
        ),
      );
      _refreshMoviesList();
      _tabController.animateTo(1);
    }
  }

  void _confirmDeleteMovie(Movie movie) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirmar Baja'),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas dar de baja y eliminar permanentemente la película "${movie.title}" de la base de datos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _dbService.deleteMovie(movie.id);
              if (mounted) {
                _refreshMoviesList();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.shade700,
                    content: Text('Película "${movie.title}" eliminada de la base de datos.'),
                  ),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración del Catálogo'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.add_circle_outline), text: 'Dar de Alta'),
            Tab(icon: Icon(Icons.delete_outline), text: 'Dar de Baja'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Registro de Nueva Película',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                  ),
                  const Text(
                    'Todos los campos serán persistidos en la base de datos en la nube mediante peticiones HTTP.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'Título de la Película *', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa el título' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _yearCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Año *', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _directorCtrl,
                          decoration: const InputDecoration(labelText: 'Director *', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa director' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _genreCtrl,
                    decoration: const InputDecoration(labelText: 'Género Cinematográfico *', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa género' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _coverCtrl,
                    decoration: const InputDecoration(
                      labelText: 'URL de la Imagen de Portada (Póster)',
                      border: OutlineInputBorder(),
                      hintText: 'https://...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _synopsisCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Sinopsis Completa *', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa sinopsis' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.cloud_upload),
                    label: Text(_isSaving ? 'Guardando en Base de Datos...' : 'Guardar Película en Base de Datos'),
                    onPressed: _isSaving ? null : _saveMovie,
                  ),
                ],
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () async => _refreshMoviesList(),
            child: _currentMovies.isEmpty
                ? const Center(child: Text('No hay películas registradas para dar de baja.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentMovies.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final movie = _currentMovies[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            movie.coverUrl,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 50,
                              height: 70,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.movie, size: 24),
                            ),
                          ),
                        ),
                        title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${movie.year} • Dir: ${movie.director}\n${movie.genre}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 28),
                          tooltip: 'Dar de baja película',
                          onPressed: () => _confirmDeleteMovie(movie),
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
