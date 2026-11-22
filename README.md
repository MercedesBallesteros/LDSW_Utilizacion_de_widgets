# LDSW_Utilizacion_de_widgets - CineStream App

Este repositorio centraliza y unifica las entregas prácticas de la materia **Laboratorio de Desarrollo de Software (LDSW)** en Flutter (UDG Virtual):

- **Actividad 3.6: Peticiones HTTP y Consumo de API en Flutter** (`MovieService` & `FutureBuilder`)
  - Implementación de peticiones asíncronas HTTP (GET) para consumir datos en tiempo real mediante el paquete `http`.
  - Servicio `MovieService` con manejo asíncrono (`async`/`await`), deserialización de JSON a modelos estructurados (`Movie`), y control de códigos de estado HTTP (200 OK y manejo de excepciones/errores).
  - Integración en la interfaz de usuario mediante `FutureBuilder`, gestionando los tres estados clave del ciclo de vida asíncrono:
    - **Cargando:** Indicador de progreso visual (`CircularProgressIndicator`).
    - **Éxito:** Renderizado dinámico del catálogo con datos reales obtenidos del servidor.
    - **Error:** Retroalimentación visual de fallos en la conexión o en la petición de red.

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
└── main.dart   # Implementación unificada de HomeScreen (3.5), MovieCatalogScreen (3.4) y MovieService / peticiones HTTP (3.6)
```

## Ejecución

```bash
flutter pub get
flutter run
```
