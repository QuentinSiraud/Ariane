import 'package:flutter/material.dart';
import 'dart:math';

class GeometirePage extends StatefulWidget {
  const GeometirePage({Key? key}) : super(key: key);

  @override
  State<GeometirePage> createState() => _GeometirePageState();
}

class _GeometirePageState extends State<GeometirePage> {
  List<Offset> points = [];
  String feedback = '';
  String targetShape = 'cercle'; // ou 'carré', 'triangle'
  final List<String> shapes = ['cercle', 'carré', 'triangle'];

  void _clear() {
    setState(() {
      points.clear();
      feedback = '';
    });
  }

  void _validate() {
    String detected = _detectShape(points);
    setState(() {
      if (detected == targetShape) {
        feedback = '🎉 Bravo, tu as tracé un $targetShape !';
        Future.delayed(const Duration(seconds: 1), _nextShape);
      } else {
        feedback = 'Essaie encore ! (Tu as tracé : $detected)';
      }
    });
  }

  String _detectShape(List<Offset> pts) {
    if (pts.length < 10) return 'inconnu';
    final clean = pts.where((p) => p != Offset.zero).toList();
    if (clean.length < 10) return 'inconnu';
    final simplified = _simplify(clean, target: 32);
    final norm = _normalize(simplified);
    final first = norm.first;
    final last = norm.last;
    final closed = (first - last).distance < 0.35; // seuil augmenté

    int corners = _countCorners(norm);

    // Debug : affiche le nombre de coins détectés
    print('Corners: $corners');

    if (closed) {
      // Triangle : 2 à 4 coins
      if (corners >= 2 && corners <= 3) return 'triangle';
      // Carré : 3 à 7 coins
      if (corners >= 4 && corners <= 7) return 'carré';
      // Cercle : très peu de coins et forme ronde
      if (corners < 2 && _isRound(norm)) return 'cercle';
    }
    return 'inconnu';
  }

  int _countCorners(List<Offset> pts) {
    int corners = 0;
    double minAngle = 1.0; // ~57°
    double minDist = 0.12; // plus strict
    Offset? lastCorner;

    // On prend des points plus espacés pour éviter les petits zigzags
    for (int i = 6; i < pts.length - 6; i++) {
      final a = pts[i - 6];
      final b = pts[i];
      final c = pts[i + 6];
      final ab = (b - a);
      final bc = (c - b);
      final angle = acos(
        ((ab.dx * bc.dx + ab.dy * bc.dy) /
        (ab.distance * bc.distance + 1e-6)).clamp(-1.0, 1.0)
      );
      if (angle < minAngle) {
        if (lastCorner == null || (b - lastCorner).distance > minDist) {
          corners++;
          lastCorner = b;
        }
      }
    }
    return corners;
  }

  bool _isRound(List<Offset> pts) {
    final center = Offset(
      pts.map((p) => p.dx).reduce((a, b) => a + b) / pts.length,
      pts.map((p) => p.dy).reduce((a, b) => a + b) / pts.length,
    );
    final dists = pts.map((p) => (p - center).distance).toList();
    final avg = dists.reduce((a, b) => a + b) / dists.length;
    final variance = dists.map((d) => (d - avg) * (d - avg)).reduce((a, b) => a + b) / dists.length;
    return variance < 0.06; // plus tolérant
  }

  List<Offset> _normalize(List<Offset> pts) {
    double minX = pts.map((p) => p.dx).reduce(min);
    double maxX = pts.map((p) => p.dx).reduce(max);
    double minY = pts.map((p) => p.dy).reduce(min);
    double maxY = pts.map((p) => p.dy).reduce(max);
    double width = maxX - minX + 1e-5;
    double height = maxY - minY + 1e-5;
    return pts.map((p) => Offset((p.dx - minX) / width, (p.dy - minY) / height)).toList();
  }

  List<Offset> _simplify(List<Offset> pts, {int target = 32}) {
    if (pts.length <= target) return pts;
    List<Offset> result = [];
    double step = pts.length / target;
    for (int i = 0; i < target; i++) {
      result.add(pts[(i * step).round()]);
    }
    return result;
  }

  void _nextShape() {
    int idx = shapes.indexOf(targetShape);
    setState(() {
      targetShape = shapes[(idx + 1) % shapes.length];
      points.clear();
      feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Géométrie'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Trace un $targetShape !',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.orangeAccent, width: 2),
                  ),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      RenderBox box = context.findRenderObject() as RenderBox;
                      // Utilise localPosition pour éviter le décalage
                      Offset local = details.localPosition;
                      setState(() => points.add(local));
                    },
                    onPanEnd: (_) => setState(() => points.add(Offset.zero)),
                    child: CustomPaint(
                      painter: _ShapePainter(points),
                      child: Container(),
                    ),
                  ),
                );
              },
            ),
          ),
          if (feedback.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                feedback,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: feedback.contains('Bravo') ? Colors.green : Colors.red,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _validate,
                child: const Text('Valider'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _clear,
                child: const Text('Effacer'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _nextShape,
                child: const Text('Forme Suivante'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final List<Offset> points;
  _ShapePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) => true;
}