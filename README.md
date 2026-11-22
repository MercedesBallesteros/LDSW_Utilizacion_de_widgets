# LDSW MovieStream - Catálogo de Películas (Producto Integrador)

Este repositorio centraliza y unifica el desarrollo práctico de la materia **Diseño de aplicaciones móviles** (Laboratorio de Desarrollo de Software - LDSW) en **Flutter** para la **Universidad de Guadalajara (UDGVirtual)**:

- **Estudiante:** Mercedes de Jesús Ballesteros Chávez  
- **Código:** 210051657  
- **Materia:** Diseño de aplicaciones móviles (LDSW)  

---

## 📱 Producto Integrador: Catálogo de Películas

Consolidación total de la aplicación móvil con arquitectura en capas, consumo de APIs web HTTP (REST) y persistencia en base de datos en la nube (Firebase). Incorpora de manera integral los siguientes flujos y vistas:

1. **Pantalla de Inicio (`WelcomeScreen`)**:
   - Mensaje de bienvenida formal a la plataforma cinematográfica.
   - Acceso directo para usuarios registrados mediante el botón **"Ingresar como Usuario"** (navega al catálogo).
   - Botón **"Registrarse como Nuevo Usuario"** con formulario modal interactivo (nombre, correo y contraseña) y feedback reactivo mediante `SnackBar`.

2. **Pantalla de Catálogo (`CatalogScreen`)**:
   - Catálogo interactivo desplegado en una cuadrícula responsiva (`GridView.builder`) de dos columnas.
   - Cada tarjeta visualiza la **imagen de referencia o póster** (`Image.network` con indicador de progreso y fallback) y el **título de la película**.
   - **Menú superior en AppBar**: Menú desplegable (`PopupMenuButton`) que permite al usuario seleccionar explícitamente el **Catálogo de Películas**, navegar al **Panel de Administración (CRUD)** o **Cerrar Sesión**.
   - Menú lateral (`Drawer`) con datos del perfil del usuario y navegación accesible.
   - Botón de acción flotante (`FloatingActionButton`) para acceso rápido al panel de administración.

3. **Pantalla de Descripción Detallada (`MovieDetailScreen`)**:
   - Vista detallada al pulsar cualquier película del catálogo.
   - Visualización exhaustiva de todos los atributos obligatorios:
     - **Título** de la película en cabecera destacada.
     - **Año de estreno** (badge iconográfico).
     - **Director** cinematográfico (tarjeta personalizada con icono representativo).
     - **Género cinematográfico** (chip temático).
     - **Sinopsis completa** de la obra.
     - **Póster oficial** a gran resolución con degradado de contraste.
   - Botón para volver al catálogo.

4. **Pantalla de Administración (`AdminScreen`) - Altas y Bajas**:
   - Módulo segmentado mediante pestañas (`TabBar` y `TabBarView`):
     - **Dar de Alta (HTTP POST)**: Formulario con validación estricta para registrar **Título, Año, Director, Género, URL de imagen del póster y Sinopsis**. Al confirmar, envía una petición asíncrona a la base de datos y añade el registro.
     - **Dar de Baja (HTTP DELETE)**: Listado interactivo de todas las películas registradas en la base de datos con visualización de título, año y director. Cada elemento cuenta con un botón de eliminación que despliega un diálogo modal de confirmación (*¿Confirmar baja?*) antes de eliminar permanentemente la película de la base de datos en la nube.

5. **Peticiones HTTP y Persistencia en Base de Datos**:
   - Implementado en `MovieDatabaseService` mediante el paquete oficial `http`.
   - Métodos asíncronos para operaciones RESTful (`GET`, `POST`, `DELETE`).
   - Manejo de estados de carga (`FutureBuilder` / `CircularProgressIndicator`), errores y resiliencia offline mediante caché en memoria.
   - Persistencia conectada con base de datos en la nube (Google Firebase Cloud Firestore / Realtime Database).

---

## 📚 Evolución del Proyecto en la Unidad 3

Este repositorio conserva el historial y la progresión técnica de las actividades previas:
- **Actividad 3.4 (Utilización de widgets)**: Configuración y uso de `Text`, `Row`, `Column`, `Stack` y `Container`.
- **Actividad 3.5 (Home screen)**: Pantalla de inicio con imagen de fondo, logotipo, mensaje de bienvenida y navegación.
- **Actividad 3.6 (Peticiones HTTP)**: Consumo de APIs RESTful con `http`, decodificación JSON y manejo de estados asíncronos.
- **Actividad 3.7 (Integración de base de datos)**: Conexión con servicios de base de datos en la nube (Firebase Firestore).
- **Producto Integrador (Catálogo de películas)**: Integración final de todas las vistas, CRUD de altas y bajas, menú superior y persistencia completa.

---

## 🚀 Ejecución del Proyecto

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en emulador o dispositivo
flutter run
```
