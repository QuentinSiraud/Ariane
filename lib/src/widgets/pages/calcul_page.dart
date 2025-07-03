import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CalculPage extends StatefulWidget {
  const CalculPage({Key? key}) : super(key: key);

  @override
  State<CalculPage> createState() => _CalculPageState();
}

class _CalculPageState extends State<CalculPage> {
  late int a, b, answer;
  List<Offset> points = [];
  String feedback = '';
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    _generateOperation();
  }

  void _generateOperation() {
    a = 1 + (DateTime.now().millisecondsSinceEpoch % 5);
    b = 1 + (DateTime.now().millisecondsSinceEpoch ~/ 1000 % 5);
    answer = a + b;
    points.clear();
    feedback = '';
    showFeedback = false;
    setState(() {});
  }

  // Simule la reconnaissance (toujours "5" si answer == 5)
  bool _recognizeDigit() {
    // Ici tu peux intégrer ton modèle ML ou une logique de reconnaissance
    // Pour la démo, on simule que si l'utilisateur clique "Valider" et la réponse est 5, c'est bon
    // Remplace cette logique par la vraie reconnaissance plus tard
    return answer == 5;
  }

  void _validate() {
    setState(() {
      if (_recognizeDigit()) {
        feedback = '🎉 Bravo !';
      } else {
        feedback = 'Essaie encore !';
      }
      showFeedback = true;
    });
  }

  void _clearCanvas() {
    setState(() {
      points.clear();
      showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trace le Bon Chiffre !'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateOperation,
            tooltip: 'Nouvelle opération',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            '$a + $b = ?',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orangeAccent, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox box = context.findRenderObject() as RenderBox;
                    points.add(box.globalToLocal(details.globalPosition));
                  });
                },
                onPanEnd: (_) => points.add(Offset.zero),
                child: CustomPaint(
                  painter: _DrawingPainter(points),
                  child: Container(),
                ),
              ),
            ),
          ),
          if (showFeedback)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                feedback,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: feedback.contains('Bravo') ? Colors.green : Colors.red,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _validate,
                icon: const Icon(Icons.check),
                label: const Text('Valider'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _clearCanvas,
                icon: const Icon(Icons.clear),
                label: const Text('Effacer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}