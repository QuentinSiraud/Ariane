import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalculPage extends StatefulWidget {
  const CalculPage({super.key});

  @override
  State<CalculPage> createState() => _CalculPageState();
}

class _CalculPageState extends State<CalculPage> with SingleTickerProviderStateMixin {
  late int a, b, answer;
  List<Offset> points = [];
  String feedback = '';
  bool showFeedback = false;
  int recognizedDigit = -1;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _generateOperation();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  void _generateOperation() {
    a = math.Random().nextInt(6);
    b = math.Random().nextInt(6);
    answer = a + b;
    points.clear();
    feedback = '';
    showFeedback = false;
    recognizedDigit = -1;
    setState(() {});
  }

  int _recognizeDigit() {
    if (points.isEmpty) return -1;
    final cleanPoints = points.where((p) => p != Offset.zero).toList();
    if (cleanPoints.length < 5) return -1;

    double minX = cleanPoints.first.dx;
    double maxX = cleanPoints.first.dx;
    double minY = cleanPoints.first.dy;
    double maxY = cleanPoints.first.dy;

    for (final point in cleanPoints) {
      minX = math.min(minX, point.dx);
      maxX = math.max(maxX, point.dx);
      minY = math.min(minY, point.dy);
      maxY = math.max(maxY, point.dy);
    }

    double width = maxX - minX;
    double height = maxY - minY;

    List<Offset> normalizedPoints = [];
    for (final point in cleanPoints) {
      normalizedPoints.add(Offset(
        (point.dx - minX) / (width == 0 ? 1 : width),
        (point.dy - minY) / (height == 0 ? 1 : height),
      ));
    }

    return _recognizePattern(normalizedPoints, width / (height == 0 ? 1 : height));
  }

  int _recognizePattern(List<Offset> points, double aspectRatio) {
    int strokeCount = _countStrokes();
    bool hasLoop = _detectLoop(points);
    bool isVertical = aspectRatio < 0.5;
    bool isCircular = aspectRatio > 0.7 && aspectRatio < 1.3;

    if (hasLoop && isCircular && strokeCount == 1) return 0;
    if (strokeCount == 1 && isVertical && points.length < 30) return 1;
    if (_hasZigZag(points) && strokeCount == 1) {
      if (_hasHorizontalBottom(points)) return 2;
      if (_countDirectionChanges(points) > 3) return 3;
    }
    if (strokeCount == 2 || strokeCount == 3) {
      if (_hasVerticalLine(points) && _hasHorizontalLine(points)) return 4;
    }
    if (_hasHorizontalTop(points) && _hasVerticalLine(points)) return 5;
    if (hasLoop && _hasTopCurve(points)) return 6;
    if (strokeCount <= 2 && _hasAngledLine(points)) return 7;
    if (hasLoop && _countLoops(points) >= 2) return 8;
    if (hasLoop && _hasBottomLine(points)) return 9;

    if (points.length > 50) return 8;
    if (points.length > 30) return 3;
    if (points.length < 15) return 1;

    return -1;
  }

  int _countStrokes() {
    int count = 0;
    bool inStroke = false;

    for (final point in points) {
      if (point == Offset.zero) {
        inStroke = false;
      } else if (!inStroke) {
        count++;
        inStroke = true;
      }
    }

    return count;
  }

  bool _detectLoop(List<Offset> points) {
    if (points.length < 15) return false;
    double distance = (points.first - points.last).distance;
    return distance < 0.3;
  }

  bool _hasZigZag(List<Offset> points) => _countDirectionChanges(points) >= 2;

  int _countDirectionChanges(List<Offset> points) {
    if (points.length < 3) return 0;
    int changes = 0;
    double lastDx = points[1].dx - points[0].dx;

    for (int i = 2; i < points.length; i++) {
      double dx = points[i].dx - points[i - 1].dx;
      if (dx * lastDx < 0) changes++;
      if (dx.abs() > 0.01) lastDx = dx;
    }

    return changes;
  }

  bool _hasHorizontalLine(List<Offset> points) =>
      points.any((p) => (p.dx - points.first.dx).abs() > 0.1);

  bool _hasVerticalLine(List<Offset> points) =>
      points.any((p) => (p.dy - points.first.dy).abs() > 0.1);

  bool _hasHorizontalBottom(List<Offset> points) =>
      points.where((p) => p.dy > 0.7).length > points.length * 0.2;

  bool _hasHorizontalTop(List<Offset> points) =>
      points.where((p) => p.dy < 0.3).length > points.length * 0.2;

  bool _hasTopCurve(List<Offset> points) =>
      points.where((p) => p.dy < 0.5).length > points.length * 0.6;

  bool _hasBottomLine(List<Offset> points) =>
      points.where((p) => p.dy > 0.8).length > 5;

  bool _hasAngledLine(List<Offset> points) {
    if (points.length < 10) return false;
    double totalAngle = 0;
    int count = 0;

    for (int i = 1; i < points.length - 1; i++) {
      double angle = math.atan2(
        points[i + 1].dy - points[i].dy,
        points[i + 1].dx - points[i].dx,
      );
      totalAngle += angle;
      count++;
    }

    double avgAngle = totalAngle / count;
    return avgAngle.abs() > 0.3 && avgAngle.abs() < 1.2;
  }

  int _countLoops(List<Offset> points) {
    int crossings = 0;
    for (int i = 0; i < points.length - 10; i++) {
      for (int j = i + 10; j < points.length; j++) {
        if ((points[i] - points[j]).distance < 0.1) {
          crossings++;
        }
      }
    }
    return crossings > 5 ? 2 : 1;
  }

  void _validate() {
    recognizedDigit = _recognizeDigit();
    print('Reconnu : $recognizedDigit / Attendu : $answer');

    setState(() {
      if (recognizedDigit == answer) {
        feedback = '🎉 Bravo ! C\'est correct !';
        _animationController.forward();
      } else if (recognizedDigit == -1) {
        feedback = '🤔 Je n\'ai pas reconnu le chiffre. Essaie encore !';
      } else {
        feedback = '😊 J\'ai vu un $recognizedDigit, mais la réponse est $answer';
      }
      showFeedback = true;
    });

    if (recognizedDigit == answer) {
      Future.delayed(const Duration(seconds: 3), () {
        _animationController.reset();
        _generateOperation();
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      points.clear();
      showFeedback = false;
      recognizedDigit = -1;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Trace le Bon Chiffre !'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateOperation,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.orange.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Text(
              '$a + $b = ?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
          if (!showFeedback)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Dessine le chiffre $answer', style: TextStyle(color: Colors.grey.shade600)),
            ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onPanStart: (details) {
                      if (showFeedback && recognizedDigit == answer) return;
                      RenderBox box = context.findRenderObject() as RenderBox;
                      setState(() => points.add(box.globalToLocal(details.localPosition)));
                    },
                    onPanUpdate: (details) {
                      if (showFeedback && recognizedDigit == answer) return;
                      RenderBox box = context.findRenderObject() as RenderBox;
                      setState(() => points.add(box.globalToLocal(details.localPosition)));
                    },
                    onPanEnd: (_) => setState(() => points.add(Offset.zero)),
                    child: CustomPaint(
                      painter: _DrawingPainter(points),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (recognizedDigit != -1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tu as dessiné : $recognizedDigit',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showFeedback ? 80 : 0,
            child: showFeedback
                ? ScaleTransition(
                    scale: _scaleAnimation,
                    child: Center(
                      child: Text(
                        feedback,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: feedback.contains('Bravo') ? Colors.green : Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _validate,
                  child: const Text('Valider'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearCanvas,
                  child: const Text('Effacer'),
                ),
              ],
            ),
          ),
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
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool penDown = false;

    for (final point in points) {
      if (point == Offset.zero) {
        penDown = false;
      } else {
        if (!penDown) {
          path.moveTo(point.dx, point.dy);
          penDown = true;
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}
