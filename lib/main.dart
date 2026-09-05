import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roleta Espacial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const RouletteScreen(),
    );
  }
}

class RouletteScreen extends StatefulWidget {
  const RouletteScreen({super.key});

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentRotation = 0;
  int? _resultIndex;
  bool _isSpinning = false;

  // Dados da roleta
  final List<Color> segmentColors = [
    const Color(0xFF2196F3), // Azul - 10
    const Color(0xFFE91E63), // Rosa - 80
    const Color(0xFF4CAF50), // Verde - -10
    const Color(0xFFFF9800), // Laranja - 60
    const Color(0xFF9C27B0), // Roxo - 30
    const Color(0xFFFFEB3B), // Amarelo - 100
    const Color(0xFF00BCD4), // Ciano - 50
    const Color(0xFFFF5722), // Vermelho - 20
  ];

  final List<int> segmentValues = [10, 80, -10, 60, 30, 100, 50, 20];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.addListener(() {
      setState(() {
        _currentRotation = _animation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _calculateResult();
        setState(() {
          _isSpinning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _resultIndex = null;
    });

    // Sortear resultado
    final random = Random();
    final selectedIndex = random.nextInt(segmentColors.length);

    // Calcular rotação (mínimo 5 giros + posição do segmento)
    final segmentAngle = 2 * pi / segmentColors.length;
    final targetAngle = 5 * 2 * pi + (selectedIndex * segmentAngle);

    _animation = Tween<double>(
      begin: _currentRotation,
      end: _currentRotation + targetAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.reset();
    _controller.forward();
  }

  void _calculateResult() {
    // Calcular qual segmento está no topo (posição do indicador)
    final normalizedRotation = _currentRotation % (2 * pi);
    final segmentAngle = 2 * pi / segmentColors.length;
    
    // O indicador está no topo (ângulo -pi/2 ou 3*pi/2)
    final indicatorAngle = 3 * pi / 2;
    final adjustedAngle = (indicatorAngle - normalizedRotation) % (2 * pi);
    
    final index = (adjustedAngle / segmentAngle).floor() % segmentColors.length;
    
    setState(() {
      _resultIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a0533),
              Color(0xFF0d0d2b),
              Color(0xFF000011),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título
              const Text(
                '🚀 ROLETA ESPACIAL 🛸',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),

              // Roleta com indicador
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Roleta girando
                      Transform.rotate(
                        angle: _currentRotation,
                        child: SizedBox(
                          width: 320,
                          height: 320,
                          child: CustomPaint(
                            painter: RoulettePainter(
                              segmentColors: segmentColors,
                              segmentValues: segmentValues,
                            ),
                          ),
                        ),
                      ),
                      // Indicador (triângulo no topo)
                      Positioned(
                        top: 10,
                        child: CustomPaint(
                          size: const Size(30, 40),
                          painter: IndicatorPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Resultado
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: _resultIndex != null
                      ? segmentColors[_resultIndex!].withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _resultIndex != null
                        ? segmentColors[_resultIndex!]
                        : Colors.white30,
                    width: 2,
                  ),
                ),
                child: Text(
                  _resultIndex != null
                      ? '🎉 ${segmentValues[_resultIndex!]} pontos!'
                      : 'Gire para jogar!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _resultIndex != null
                        ? segmentColors[_resultIndex!]
                        : Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Botão de girar
              ElevatedButton(
                onPressed: _isSpinning ? null : _spin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isSpinning ? '⏳ GIRANDO...' : 'GIRAR 🎰',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  final List<Color> segmentColors;
  final List<int> segmentValues;

  RoulettePainter({
    required this.segmentColors,
    required this.segmentValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final segmentAngle = 2 * pi / segmentColors.length;

    for (int i = 0; i < segmentColors.length; i++) {
      final startAngle = i * segmentAngle;
      final paint = Paint()
        ..color = segmentColors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Desenhar valor
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.65;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: segmentValues[i].toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 3,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          textX - textPainter.width / 2,
          textY - textPainter.height / 2,
        ),
      );
    }

    // Círculo central
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.15, centerPaint);

    // Borda externa
    final borderPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Borda do indicador
    final borderPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
