import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool oTurn = true;
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool isGameOver = false;
  String? winner;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cellSize = size.width * 0.28;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Header with compact score board
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Player X
                    _buildPlayerIndicator(
                      'X',
                      xScore,
                      const Color(0xFF00E5FF),
                      !oTurn && !isGameOver,
                    ),

                    // Game Info
                    Column(
                      children: [
                        Text(

                          'TIC TAC TOE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          oTurn && !isGameOver ? "O's Turn" : !oTurn && !isGameOver ? "X's Turn" : "Game Over",
                          style: TextStyle(
                            fontSize: 14,
                            color: oTurn && !isGameOver
                                ? const Color(0xFFFF4081)
                                : !oTurn && !isGameOver
                                ? const Color(0xFF00E5FF)
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Player O
                    _buildPlayerIndicator(
                      'O',
                      oScore,
                      const Color(0xFFFF4081),
                      oTurn && !isGameOver,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Game Grid - Compact and responsive
              Expanded(
                child: Center(
                  child: Container(
                    width: size.width * 0.9,
                    height: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildGridCell(index, cellSize);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Compact Controls
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reset Game Button
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text(
                          'New Game',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _clearBoard,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Reset Score Button
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.restore, size: 20),
                        label: const Text(
                          'Reset All',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _clearScoreBoard,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerIndicator(String player, int score, Color color, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              player,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGridCell(int index, double cellSize) {
    final isWinningCell = winner != null && _isWinningCell(index);

    return GestureDetector(
      onTap: () => _tapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isWinningCell
              ? displayElement[index] == 'X'
              ? const Color(0xFF00E5FF).withOpacity(0.2)
              : const Color(0xFFFF4081).withOpacity(0.2)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isWinningCell
                ? displayElement[index] == 'X'
                ? const Color(0xFF00E5FF)
                : const Color(0xFFFF4081)
                : const Color(0xFF2A2A2A),
            width: isWinningCell ? 2 : 1,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: displayElement[index].isEmpty
                ? const SizedBox.shrink()
                : Text(
              displayElement[index],
              key: ValueKey(displayElement[index] + index.toString()),
              style: TextStyle(
                fontSize: cellSize * 0.5,
                fontWeight: FontWeight.bold,
                color: displayElement[index] == 'X'
                    ? const Color(0xFF00E5FF)
                    : const Color(0xFFFF4081),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    if (isGameOver || displayElement[index].isNotEmpty) return;

    setState(() {
      displayElement[index] = oTurn ? 'O' : 'X';
      filledBoxes++;
      oTurn = !oTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (displayElement[i].isNotEmpty &&
          displayElement[i] == displayElement[i + 1] &&
          displayElement[i] == displayElement[i + 2]) {
        _declareWinner(displayElement[i]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (displayElement[i].isNotEmpty &&
          displayElement[i] == displayElement[i + 3] &&
          displayElement[i] == displayElement[i + 6]) {
        _declareWinner(displayElement[i]);
        return;
      }
    }

    // Check diagonals
    if (displayElement[0].isNotEmpty &&
        displayElement[0] == displayElement[4] &&
        displayElement[0] == displayElement[8]) {
      _declareWinner(displayElement[0]);
      return;
    }

    if (displayElement[2].isNotEmpty &&
        displayElement[2] == displayElement[4] &&
        displayElement[2] == displayElement[6]) {
      _declareWinner(displayElement[2]);
      return;
    }

    // Check for draw
    if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  void _declareWinner(String player) {
    setState(() {
      isGameOver = true;
      winner = player;
      if (player == 'O') {
        oScore++;
      } else {
        xScore++;
      }
    });

    _showWinDialog(player);
  }

  bool _isWinningCell(int index) {
    if (winner == null) return false;

    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (displayElement[i] == winner &&
          displayElement[i] == displayElement[i + 1] &&
          displayElement[i] == displayElement[i + 2]) {
        return index >= i && index <= i + 2;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (displayElement[i] == winner &&
          displayElement[i] == displayElement[i + 3] &&
          displayElement[i] == displayElement[i + 6]) {
        return index % 3 == i;
      }
    }

    // Check diagonals
    if (displayElement[0] == winner &&
        displayElement[0] == displayElement[4] &&
        displayElement[0] == displayElement[8]) {
      return index == 0 || index == 4 || index == 8;
    }

    if (displayElement[2] == winner &&
        displayElement[2] == displayElement[4] &&
        displayElement[2] == displayElement[6]) {
      return index == 2 || index == 4 || index == 6;
    }

    return false;
  }

  void _showWinDialog(String winner) {
    Future.delayed(const Duration(milliseconds: 300), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.celebration,
                  size: 40,
                  color: winner == 'X'
                      ? const Color(0xFF00E5FF)
                      : const Color(0xFFFF4081),
                ),
                const SizedBox(height: 12),
                Text(
                  'Player $winner Wins!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _clearBoard();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Play Again',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showDrawDialog() {
    setState(() {
      isGameOver = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.handshake,
                  size: 40,
                  color: Colors.amber,
                ),
                const SizedBox(height: 12),
                const Text(
                  'It\'s a Draw!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _clearBoard();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Play Again',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
      filledBoxes = 0;
      isGameOver = false;
      winner = null;
    });
  }

  void _clearScoreBoard() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard();
    });
  }
}