import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actividad 3.4 - Widgets en Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WidgetsDemoPage(),
    );
  }
}

class WidgetsDemoPage extends StatelessWidget {
  const WidgetsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilización de Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Text Widget
            const Text(
              '1. Widget Text',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este es un ejemplo del widget Text mostrando estilos tipográficos personalizados.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 32),

            // 2. Container Widget
            const Text(
              '2. Widget Container',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Container con padding, bordes redondeados y sombra decorativa.',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            const Divider(height: 32),

            // 3. Row Widget
            const Text(
              '3. Widget Row',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBox('Elemento 1', Colors.blue),
                _buildBox('Elemento 2', Colors.teal),
                _buildBox('Elemento 3', Colors.green),
              ],
            ),
            const Divider(height: 32),

            // 4. Column Widget
            const Text(
              '4. Widget Column',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildRowItem(Icons.star, 'Primer elemento vertical'),
                const SizedBox(height: 8),
                _buildRowItem(Icons.favorite, 'Segundo elemento vertical'),
                const SizedBox(height: 8),
                _buildRowItem(Icons.thumb_up, 'Tercer elemento vertical'),
              ],
            ),
            const Divider(height: 32),

            // 5. Stack Widget
            const Text(
              '5. Widget Stack',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Container(
                    width: 170,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const Text(
                    'Texto sobre Stack',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: const Icon(Icons.layers, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  static Widget _buildRowItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
