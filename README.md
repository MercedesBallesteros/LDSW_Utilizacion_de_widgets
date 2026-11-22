# LDSW_Utilizacion_de_widgets - CineStream App

Este repositorio centraliza y unifica las entregas prácticas de la materia **Laboratorio de Desarrollo de Software (LDSW)** en Flutter (UDG Virtual):

- **Actividad 3.5: Home Screen en Flutter** (`HomeScreen`)
  - Pantalla inicial de bienvenida (`'/'`).
  - Imagen de fondo (`Image.network` con diseño adaptativo y fallback de gradiente).
  - Icono representativo de marca (`Icon`).
  - Nombre de la aplicación: **CineStream**.
  - Mensaje de bienvenida: **"Hello World - Flutter Mobile App"**.
  - Botón interactivo **"Explorar Catálogo"** que navega con `Navigator.push` hacia el catálogo de películas.

- **Actividad 3.4: Utilización de Widgets en Flutter** (`MovieCatalogScreen`)
  - Catálogo de películas que integra y demuestra el uso de los widgets fundamentales requeridos:
    - **`Container`**: Cajas contenedoras con márgenes, padding, bordes redondeados y sombras decorativas.
    - **`Stack`**: Superposición de póster, degradado inferior y etiquetas destacadas.
    - **`Column`**: Estructuración vertical de la ficha de película y textos.
    - **`Row`**: Distribución horizontal de metadatos (año, duración, calificación por estrellas).
    - **`Text`**: Formato y estilo para títulos, etiquetas, métricas y sinopsis.

## Estructura del Proyecto

```
lib/
└── main.dart   # Implementación unificada de HomeScreen (3.5) y MovieCatalogScreen (3.4)
```

## Ejecución

```bash
flutter pub get
flutter run
```
