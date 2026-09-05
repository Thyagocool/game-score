import 'package:flutter/material.dart';

void main() {
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
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Tela inicial - Cadastro de Jogadores
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> players = [];
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        players.add(_nameController.text);
        _nameController.clear();
      });
    }
  }

  void _startGame() {
    if (players.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(players: List.from(players)),
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
                // Título
                const Text(
                  '🎯 JOGO DE DARDOS 🎯',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Adicione os jogadores para começar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),

                // Campo de entrada
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nome do jogador',
                          labelStyle: const TextStyle(color: Colors.white70),
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
                            borderSide: const BorderSide(color: Colors.amber),
                          ),
                        ),
                        onSubmitted: (_) => _addPlayer(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addPlayer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.add, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Lista de jogadores
                Expanded(
                  child: players.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum jogador adicionado',
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white.withValues(alpha: 0.1),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                title: Text(
                                  players[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      players.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Botão iniciar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: players.length >= 2 ? _startGame : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      players.length >= 2
                          ? 'INICIAR JOGO (${players.length} jogadores)'
                          : 'Adicione pelo menos 2 jogadores',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

// Tela do Jogo
class GameScreen extends StatefulWidget {
  final List<String> players;

  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Map<String, int> scores;
  String? selectedPlayer;

  // Valores dos segmentos (baseado na imagem)
  // A imagem tem 8 segmentos com valores: 10, 80, -10, 60, 30, 100, 50, 20
  final List<int> segmentValues = [10, 80, -10, 60, 30, 100, 50, 20];

  @override
  void initState() {
    super.initState();
    scores = {for (var player in widget.players) player: 0};
    selectedPlayer = widget.players.first;
  }

  void _addPoints(int points) {
    if (selectedPlayer != null) {
      setState(() {
        scores[selectedPlayer!] = scores[selectedPlayer!]! + points;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$selectedPlayer ganhou $points pontos!',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: points > 0 ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _resetScores() {
    setState(() {
      scores = {for (var player in widget.players) player: 0};
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
            children: [
              // Header com placar
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text(
                      '🎯 PLACAR',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Placar dos jogadores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.players.map((player) {
                        final isSelected = player == selectedPlayer;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPlayer = player;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                                  color: isSelected
                                  ? Colors.amber.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected ? Colors.amber : Colors.white30,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  player,
                                  style: TextStyle(
                                    color: isSelected ? Colors.amber : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${scores[player]}',
                                  style: TextStyle(
                                    color: isSelected ? Colors.amber : Colors.white70,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Imagem do tabuleiro
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTapDown: (details) {
                      _handleTap(details.localPosition);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/game.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // Instrução
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Toque na imagem onde o dardo acertou!\nJogador atual: $selectedPlayer',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Botões de ação
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Botão resetar
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetScores,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'ZERAR PLACAR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset localPosition) {
    // Aqui você pode implementar a lógica para identificar qual segmento foi tocado
    // Por enquanto, vou adicionar pontos aleatórios baseado na posição
    final random = localPosition.dx % segmentValues.length;
    final points = segmentValues[random.toInt() % segmentValues.length];
    _addPoints(points);
  }
}
