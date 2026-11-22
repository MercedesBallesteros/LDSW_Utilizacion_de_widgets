import 'package:flutter/material.dart';

void main() {
  runApp(const CineStreamApp());
}

class CineStreamApp extends StatelessWidget {
  const CineStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineStream - Catálogo de Películas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/catalog': (context) => const MovieCatalogScreen(),
      },
    );
  }
}

/// ============================================================================
/// PANTALLA 1: HomeScreen (Actividad 3.5)
/// - Image de fondo
/// - Icon de marca
/// - Nombre 'CineStream'
/// - Bienvenida 'Hello World - Flutter Mobile App'
/// - Botón 'Explorar Catálogo' hacia MovieCatalogScreen
/// ============================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Image de fondo
          Image.network(
            'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=1200&auto=format&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
          ),
          // Capa oscura translúcida para contraste
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
          // Contenido principal de bienvenida
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon de marca
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                      ),
                      child: const Icon(
                        Icons.movie_creation_rounded,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Nombre 'CineStream'
                    const Text(
                      'CineStream',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Mensaje de bienvenida 'Hello World - Flutter Mobile App'
                    const Text(
                      'Hello World - Flutter Mobile App',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Actividad 3.5 & Actividad 3.4 Unificadas',
                        style: TextStyle(fontSize: 13, color: Colors.white60),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Botón 'Explorar Catálogo'
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MovieCatalogScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.video_library_rounded),
                      label: const Text(
                        'Explorar Catálogo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// PANTALLA 2: MovieCatalogScreen (Actividad 3.4)
/// Utilización estructurada de:
/// - Container (cajas con padding, márgenes, bordes, decoración)
/// - Stack (superposición de póster, etiquetas y gradiente)
/// - Column (disposición vertical de información)
/// - Row (disposición horizontal de metadatos: año, duración, rating)
/// - Text (títulos, sinopsis, géneros, calificaciones)
/// ============================================================================
class MovieCatalogScreen extends StatelessWidget {
  const MovieCatalogScreen({super.key});

  final List<Map<String, dynamic>> movies = const [
    {
      'title': 'Inception (El Origen)',
      'genre': 'Ciencia Ficción / Acción',
      'year': '2010',
      'duration': '148 min',
      'rating': '8.8/10',
      'badge': 'ESTRENO DESTACADO',
      'description':
          'Un ladrón que roba secretos corporativos mediante la tecnología de compartir sueños tiene la última oportunidad de borrar su pasado realizando una inserción de idea.',
      'imageUrl':
          'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=800&auto=format&fit=crop',
    },
    {
      'title': 'Interstellar',
      'genre': 'Aventura / Drama / Sci-Fi',
      'year': '2014',
      'duration': '169 min',
      'rating': '8.7/10',
      'badge': 'PREMIADA',
      'description':
          'Un grupo de exploradores viaja a través de un agujero de gusano en el espacio en un intento por asegurar la supervivencia de la humanidad.',
      'imageUrl':
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=800&auto=format&fit=crop',
    },
    {
      'title': 'Spider-Man: Across the Spider-Verse',
      'genre': 'Animación / Aventura',
      'year': '2023',
      'duration': '140 min',
      'rating': '8.7/10',
      'badge': 'POPULAR',
      'description':
          'Miles Morales es catapultado a través del Multiverso, donde se encuentra con un equipo de Spider-People encargados de proteger su existencia.',
      'imageUrl':
          'https://images.unsplash.com/photo-1635805737707-575885ab0820?q=80&w=800&auto=format&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Catálogo de Películas (3.4)'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _buildMovieCard(context, movie);
        },
      ),
    );
  }

  /// Construye cada ficha de película utilizando:
  /// Container, Stack, Column, Row y Text
  Widget _buildMovieCard(BuildContext context, Map<String, dynamic> movie) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // STACK: Superpone imagen de la película, gradiente y etiqueta de destacado
          Stack(
            children: [
              Image.network(
                movie['imageUrl'] as String,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.deepPurple.shade900,
                    child: const Center(
                      child: Icon(Icons.movie, size: 60, color: Colors.white54),
                    ),
                  );
                },
              ),
              // Gradiente inferior del Stack
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xFF1E1E2E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Etiqueta destacada en la esquina superior izquierda
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    movie['badge'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // CONTAINER con padding para la información de texto y filas
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TEXT: Título de la película
                Text(
                  movie['title'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),

                // TEXT: Género
                Text(
                  movie['genre'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // ROW: Metadatos horizontales (Año, Duración, Rating)
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white60),
                    const SizedBox(width: 4),
                    Text(
                      movie['year'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time_rounded, size: 14, color: Colors.white60),
                    const SizedBox(width: 4),
                    Text(
                      movie['duration'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      movie['rating'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // TEXT: Sinopsis / Descripción
                Text(
                  movie['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
