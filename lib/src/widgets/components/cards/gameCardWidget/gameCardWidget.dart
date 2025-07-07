import 'package:flutter/material.dart';

class GameCardWidget extends StatelessWidget {
  final String title;        
  final String description;  
  final String imagePath;    
  final Widget page;         
  final Color gradientStart; 
  final Color gradientEnd;   

  const GameCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.page,
    this.gradientStart = const Color(0xFFFDE7E7),
    this.gradientEnd = const Color(0xFFFAB5B5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Fond avec dégradé en forme de triangle
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _TriangleGradientPainter(
                        gradientStart: gradientStart,
                        gradientEnd: gradientEnd,
                      ),
                    ),
                  ),
                  // Icône et titre à gauche
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black87,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bulle blanche avec le texte
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    left: 100,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TriangleGradientPainter extends CustomPainter {
  final Color gradientStart;
  final Color gradientEnd;

  _TriangleGradientPainter({
    required this.gradientStart,
    required this.gradientEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);
    path.lineTo(size.width * 0.45, size.height / 2);
    path.lineTo(size.width * 0.35, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}