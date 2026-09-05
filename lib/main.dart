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
  final Offset position;

  DartHit({
    required this.playerName,
    required this.points,
    required this.timestamp,
    required this.position,
  });
}

// ==========================================
// TELA INICIAL - CADASTRO DE JOGADORES
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
  Offset? lastHitPosition;
  int? lastHitPoints;

  // Valores do tabuleiro (baseado na imagem original)
  // A imagem tem um layout de dardos com valores específicos
  // Vamos mapear regiões da imagem para valores
  final Map<String, int> segmentValues = {
    'planeta_rosa': 10,
    'ufo_azul': 80,
    'cometa': 10,
    'estrela': -20,
    'saturno': 60,
    'astronauta': -10,
    'nave': 30,
    'lua': 20,
    'sol': 100,
    ' terra': 50,
    'nuvem': -30,
    'planeta_laranja': 40,
    'anel': 10,
    'meteoro': -10,
  };

  Player get currentPlayer => players[currentPlayerIndex];

  @override
  void initState() {
    super.initState();
    players = widget.players;
  }

  void _handleBoardTap(TapDownDetails details) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = details.localPosition;
    final size = renderBox.size;

    // Calcular qual segmento foi tocado baseado na posição
    final points = _calculatePoints(localPosition, size);

    setState(() {
      lastHitPosition = localPosition;
      lastHitPoints = points;

      // Atualizar pontuação
      currentPlayer.score += points;
      currentPlayer.history.add(points);

      // Adicionar ao histórico
      hitHistory.insert(
        0,
        DartHit(
          playerName: currentPlayer.name,
          points: points,
          timestamp: DateTime.now(),
          position: localPosition,
        ),
      );
    });

    // Feedback visual e sonoro
    HapticFeedback.mediumImpact();

    // MostrarSnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              points > 0 ? Icons.add_circle : Icons.remove_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              '${currentPlayer.name}: ${points > 0 ? '+' : ''}$points pontos',
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

  int _calculatePoints(Offset position, Size boardSize) {
    // Centro do tabuleiro
    final centerX = boardSize.width / 2;
    final centerY = boardSize.height / 2;

    // Calcular distância do centro
    final dx = position.dx - centerX;
    final dy = position.dy - centerY;
    final distance = (dx * dx + dy * dy);

    // Calcular ângulo (0 a 360 graus)
    var angle = (dy < 0 ? 180 : 0) + (dx / (distance > 0 ? distance : 1) * 180 / 3.14159);
    if (angle < 0) angle += 360;

    // Determinar valor baseado na distância e ângulo
    // Tabuleiro divide em 8 segmentos
    final segmentIndex = (angle / 45).floor() % 8;

    // Valores da imagem original (sentido horário a partir do topo)
    final List<int> outerValues = [10, -10, 80, 20, 100, 40, -30, 50];
    final List<int> innerValues = [10, 60, -20, 30, 50, 40, -10, 10];

    // Determinar se é anel interno ou externo
    final maxRadius = boardSize.width / 2;
    final normalizedDistance = distance / (maxRadius * maxRadius);

    if (normalizedDistance < 0.3) {
      // Centro - maior pontuação
      return 100;
    } else if (normalizedDistance < 0.6) {
      // Anel interno
      return innerValues[segmentIndex];
    } else {
      // Anel externo
      return outerValues[segmentIndex];
    }
  }

  void _nextPlayer() {
    setState(() {
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      lastHitPosition = null;
      lastHitPoints = null;
    });
  }

  void _showRanking() {
    // Ordenar jogadores por pontuação
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
                    '📜 HISTÓRICO DE JOGADAS',
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
                              'Nenhuma jogada registrada',
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
                                  '${hit.timestamp.hour.toString().padLeft(2, '0')}:${hit.timestamp.minute.toString().padLeft(2, '0')}:${hit.timestamp.second.toString().padLeft(2, '0')}',
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
          'Isso irá apagar todas as pontuações. Continuar?',
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
                lastHitPosition = null;
                lastHitPoints = null;
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
                      tooltip: 'Zerar',
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
                          tooltip: 'Histórico',
                        ),
                        IconButton(
                          onPressed: _showRanking,
                          icon: const Icon(Icons.emoji_events, color: Colors.amber),
                          tooltip: 'Ranking',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Placar dos jogadores
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isSelected = index == currentPlayerIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentPlayerIndex = index;
                        });
                      },
                      child: Container(
                        width: 120,
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
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${player.score}',
                              style: TextStyle(
                                color: player.score >= 0 ? Colors.green : Colors.red,
                                fontSize: 24,
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

              // Tabuleiro
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTapDown: _handleBoardTap,
                    child: Stack(
                      children: [
                        // Imagem do tabuleiro
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/game.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Indicador do último acerto
                        if (lastHitPosition != null)
                          Positioned(
                            left: lastHitPosition!.dx - 15,
                            top: lastHitPosition!.dy - 15,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (lastHitPoints ?? 0) >= 0
                                    ? Colors.green.withValues(alpha: 0.8)
                                    : Colors.red.withValues(alpha: 0.8),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  '$lastHitPoints',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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

              // Botão próximo jogador
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
