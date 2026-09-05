import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marcador de Dardos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ==========================================
// MODEL
// ==========================================
class Player {
  final String name;
  int score;
  final List<int> history;

  Player({required this.name, this.score = 0, List<int>? history})
      : history = history ?? [];
}

class DartHit {
  final String playerName;
  final int points;
  final DateTime timestamp;
  final String segmentName;

  DartHit({
    required this.playerName,
    required this.points,
    required this.timestamp,
    required this.segmentName,
  });
}

// ==========================================
// DARTBOARD DATA
// ==========================================
class DartboardSegment {
  final Color color;
  final int points;
  final String name;
  final double startAngle; // em graus
  final double endAngle;

  const DartboardSegment({
    required this.color,
    required this.points,
    required this.name,
    required this.startAngle,
    required this.endAngle,
  });
}

// Dados baseados na imagem original
final List<DartboardSegment> segments = [
  // Sentido horário, começando do topo (12h)
  const DartboardSegment(
    color: Color(0xFF2196F3), // Azul
    points: 10,
    name: 'Planeta Azul',
    startAngle: 0,
    endAngle: 45,
  ),
  const DartboardSegment(
    color: Color(0xFFE91E63), // Rosa
    points: -10,
    name: 'Planeta Rosa',
    startAngle: 45,
    endAngle: 90,
  ),
  const DartboardSegment(
    color: Color(0xFF4CAF50), // Verde
    points: 80,
    name: 'UFO Verde',
    startAngle: 90,
    endAngle: 135,
  ),
  const DartboardSegment(
    color: Color(0xFFFF9800), // Laranja
    points: 20,
    name: 'Lua Laranja',
    startAngle: 135,
    endAngle: 180,
  ),
  const DartboardSegment(
    color: Color(0xFF9C27B0), // Roxo
    points: 100,
    name: 'Sol Roxo',
    startAngle: 180,
    endAngle: 225,
  ),
  const DartboardSegment(
    color: Color(0xFFFFEB3B), // Amarelo
    points: 40,
    name: 'Planeta Amarelo',
    startAngle: 225,
    endAngle: 270,
  ),
  const DartboardSegment(
    color: Color(0xFF00BCD4), // Ciano
    points: -30,
    name: 'Nuvem',
    startAngle: 270,
    endAngle: 315,
  ),
  const DartboardSegment(
    color: Color(0xFFFF5722), // Vermelho
    points: 50,
    name: 'Estrela',
    startAngle: 315,
    endAngle: 360,
  ),
];

// ==========================================
// TELA INICIAL
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> players = [];
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && !players.contains(name)) {
      setState(() {
        players.add(name);
        _nameController.clear();
      });
    }
  }

  void _removePlayer(int index) {
    setState(() {
      players.removeAt(index);
    });
  }

  void _startGame() {
    if (players.length >= 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            players: players.map((name) => Player(name: name)).toList(),
          ),
        ),
      );
    }
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  '🎯 JOGO DE DARDOS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Adicione os jogadores para começar',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // Campo de entrada
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Nome do jogador',
                          hintStyle: const TextStyle(color: Colors.white38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.amber, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                        ),
                        onSubmitted: (_) => _addPlayer(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _addPlayer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(56, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.add, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Lista de jogadores
                Expanded(
                  child: players.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 80, color: Colors.white.withValues(alpha: 0.2)),
                              const SizedBox(height: 16),
                              const Text(
                                'Nenhum jogador ainda',
                                style: TextStyle(color: Colors.white38, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white.withValues(alpha: 0.08),
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  players[index],
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _removePlayer(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Botão iniciar
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: players.length >= 2 ? _startGame : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                      disabledForegroundColor: Colors.white38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      players.length >= 2
                          ? 'INICIAR JOGO  🎯  (${players.length} jogadores)'
                          : 'Adicione pelo menos 2 jogadores',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TELA DO JOGO
// ==========================================
class GameScreen extends StatefulWidget {
  final List<Player> players;

  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Player> players;
  int currentPlayerIndex = 0;
  final List<DartHit> hitHistory = [];
  DartboardSegment? lastHitSegment;

  Player get currentPlayer => players[currentPlayerIndex];

  @override
  void initState() {
    super.initState();
    players = widget.players;
  }

  void _handleBoardTap(TapDownDetails details, Size boardSize) {
    final localPosition = details.localPosition;

    // Calcular centro do tabuleiro
    final centerX = boardSize.width / 2;
    final centerY = boardSize.height / 2;

    // Vetor do centro até o toque
    final dx = localPosition.dx - centerX;
    final dy = localPosition.dy - centerY;

    // Calcular distância do centro
    final distance = sqrt(dx * dx + dy * dy);
    final maxRadius = boardSize.width / 2;

    // Verificar se está dentro do tabuleiro
    if (distance > maxRadius) return;

    // Calcular ângulo em graus (0-360)
    // atan2: 0 = direita, + = anti-horário
    // Queremos: 0 = cima, + = horário
    var angle = atan2(dx, -dy) * 180 / pi;
    if (angle < 0) angle += 360;

    // Debug: print para verificar
    // print('TOQUE: dx=$dx, dy=$dy, angle=$angle, distance=$distance');

    // Encontrar qual segmento foi tocado
    DartboardSegment? hitSegment;
    for (final segment in segments) {
      if (angle >= segment.startAngle && angle < segment.endAngle) {
        hitSegment = segment;
        break;
      }
    }

    if (hitSegment == null) {
      // print('NENHUM SEGMENTO ENCONTRADO para angle=$angle');
      return;
    }

    // Pontuação simples: retorna o valor exato do segmento
    final points = hitSegment.points;

    // print('ACERTOU: ${hitSegment.name} = $points pontos');

    setState(() {
      lastHitSegment = hitSegment;
      currentPlayer.score += points;
      currentPlayer.history.add(points);

      hitHistory.insert(
        0,
        DartHit(
          playerName: currentPlayer.name,
          points: points,
          timestamp: DateTime.now(),
          segmentName: hitSegment!.name,
        ),
      );
    });

    // Feedback
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: hitSegment.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${currentPlayer.name}: ${points > 0 ? '+' : ''}$points',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: points > 0
            ? Colors.green.withValues(alpha: 0.9)
            : Colors.red.withValues(alpha: 0.9),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _nextPlayer() {
    setState(() {
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      lastHitSegment = null;
    });
  }

  void _showRanking() {
    final sorted = List<Player>.from(players)
      ..sort((a, b) => b.score.compareTo(a.score));

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a0533),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🏆 RANKING',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(sorted.length, (index) {
                final player = sorted[index];
                final medal = index == 0 ? '🥇' : index == 1 ? '🥈' : index == 2 ? '🥉' : '  ';
                return ListTile(
                  leading: Text(medal, style: const TextStyle(fontSize: 24)),
                  title: Text(
                    player.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: Text(
                    '${player.score} pts',
                    style: TextStyle(
                      color: player.score >= 0 ? Colors.green : Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a0533),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '📜 HISTÓRICO',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: hitHistory.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma jogada ainda',
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: hitHistory.length,
                            itemBuilder: (context, index) {
                              final hit = hitHistory[index];
                              return ListTile(
                                leading: Icon(
                                  hit.points > 0 ? Icons.add_circle : Icons.remove_circle,
                                  color: hit.points > 0 ? Colors.green : Colors.red,
                                ),
                                title: Text(
                                  hit.playerName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  hit.segmentName,
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                                trailing: Text(
                                  '${hit.points > 0 ? '+' : ''}${hit.points}',
                                  style: TextStyle(
                                    color: hit.points > 0 ? Colors.green : Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _resetGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a0533),
        title: const Text('🔄 Zerar Placar?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Isso irá apagar todas as pontuações.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var player in players) {
                  player.score = 0;
                  player.history.clear();
                }
                hitHistory.clear();
                lastHitSegment = null;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Zerar'),
          ),
        ],
      ),
    );
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
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _resetGame,
                      icon: const Icon(Icons.refresh, color: Colors.white70),
                    ),
                    const Text(
                      '🎯 DARDOS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _showHistory,
                          icon: const Icon(Icons.history, color: Colors.white70),
                        ),
                        IconButton(
                          onPressed: _showRanking,
                          icon: const Icon(Icons.emoji_events, color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Placar
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isSelected = index == currentPlayerIndex;
                    return GestureDetector(
                      onTap: () => setState(() => currentPlayerIndex = index),
                      child: Container(
                        width: 110,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.amber.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.amber : Colors.white24,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              player.name,
                              style: TextStyle(
                                color: isSelected ? Colors.amber : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${player.score}',
                              style: TextStyle(
                                color: player.score >= 0 ? Colors.green : Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Último acerto
              if (lastHitSegment != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: lastHitSegment!.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lastHitSegment!.color),
                  ),
                  child: Text(
                    'Último: ${lastHitSegment!.name} (${lastHitSegment!.points > 0 ? '+' : ''}${lastHitSegment!.points})',
                    style: TextStyle(color: lastHitSegment!.color, fontWeight: FontWeight.bold),
                  ),
                ),

              const SizedBox(height: 8),

              // Tabuleiro customizado
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTapDown: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      _handleBoardTap(details, box.size);
                    },
                    child: CustomPaint(
                      size: const Size(320, 320),
                      painter: DartboardPainter(),
                    ),
                  ),
                ),
              ),

              // Botão próximo
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _nextPlayer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'PRÓXIMO: ${players[(currentPlayerIndex + 1) % players.length].name}  ➡️',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CUSTOM PAINTER - TABULEIRO
// ==========================================
class DartboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Desenhar cada segmento
    for (final segment in segments) {
      // Converter ângulos do nosso sistema (0=cima, horário) para o Flutter
      // Flutter: 0=direita, anti-horário positivo
      // Nós: 0=cima, horário positivo
      final startAngle = -(segment.startAngle) * pi / 180;
      final sweepAngle = -(segment.endAngle - segment.startAngle) * pi / 180;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Desenhar valor no segmento
      final midAngle = -(segment.startAngle + segment.endAngle) / 2 * pi / 180;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * cos(midAngle);
      final textY = center.dy + textRadius * sin(midAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${segment.points}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 4),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );
    }

    // Círculo central (bullseye)
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.15, centerPaint);

    final centerTextPainter = TextPainter(
      text: const TextSpan(
        text: '100',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    centerTextPainter.layout();
    centerTextPainter.paint(
      canvas,
      Offset(
        center.dx - centerTextPainter.width / 2,
        center.dy - centerTextPainter.height / 2,
      ),
    );

    // Borda externa
    final borderPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, borderPaint);

    // Anéis guia (opcionais, para referência visual)
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius * 0.25, guidePaint);
    canvas.drawCircle(center, radius * 0.5, guidePaint);
    canvas.drawCircle(center, radius * 0.75, guidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
