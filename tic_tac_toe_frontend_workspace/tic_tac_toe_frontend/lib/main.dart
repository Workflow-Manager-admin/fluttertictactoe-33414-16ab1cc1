import 'package:flutter/material.dart';

// PUBLIC_INTERFACE
void main() {
  /** Entry point for the Tic Tac Toe Flutter mobile app. */
  runApp(const TicTacToeApp());
}

/// The main app entry widget with global theme.
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    /** Builds the root of the app with theme and home page. */
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1976D2),
          secondary: const Color(0xFF424242),
          surface: Colors.white,
          // background: Colors.white, // removed (deprecated)
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          // onBackground: Colors.black, // removed (deprecated)
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 20,
          ),
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
        ),
      ),
      home: const TicTacToeHome(),
    );
  }
}

/// Main screen with status bar, board, and bottom action(s).
class TicTacToeHome extends StatefulWidget {
  const TicTacToeHome({super.key});

  @override
  State<TicTacToeHome> createState() => _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  // 3x3 board: null = empty, 'X' or 'O'
  List<String?> _board = List.filled(9, null);
  String _currentPlayer = 'X';
  String? _winner;
  bool _isDraw = false;
  bool _gameOver = false;

  // PUBLIC_INTERFACE
  void _resetGame() {
    /** Resets the game state for a new game. */
    setState(() {
      _board = List.filled(9, null);
      _currentPlayer = 'X';
      _winner = null;
      _isDraw = false;
      _gameOver = false;
    });
  }

  // PUBLIC_INTERFACE
  void _handleTap(int index) {
    /** Handles board tile tap and updates state. Game logic placeholders included. */
    if (_gameOver || _board[index] != null) return;
    setState(() {
      _board[index] = _currentPlayer;
      _checkGameResult();
      if (!_gameOver) {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  // PUBLIC_INTERFACE
  void _checkGameResult() {
    /** Checks the current board for a win or draw, updates the game state. */
    final List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];
      if (_board[a] != null &&
          _board[a] == _board[b] &&
          _board[a] == _board[c]) {
        _winner = _board[a];
        _gameOver = true;
        return;
      }
    }
    if (!_board.contains(null)) {
      _isDraw = true;
      _gameOver = true;
    }
  }

  String _getStatusText() {
    /** Returns the announcement/status message. */
    if (_gameOver && _winner != null) {
      return 'Player $_winner wins!';
    } else if (_gameOver && _isDraw) {
      return "It's a draw!";
    } else {
      return "Player $_currentPlayer's turn";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color accent = const Color(0xFFFFC107);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status bar/message
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: StatusBar(
                    text: _getStatusText(),
                    color: accent,
                  ),
                ),
                // Game board
                Expanded(
                  child: LayoutBuilder(
                      builder: (context, constraints) {
                    // Responsive square game board sizing
                    double boardSide = constraints.maxWidth < constraints.maxHeight
                        ? constraints.maxWidth
                        : constraints.maxHeight * 0.7;
                    return Center(
                      child: Board(
                        board: _board,
                        onTap: (idx) => _handleTap(idx),
                        boardSize: boardSide,
                        gameOver: _gameOver,
                        winner: _winner,
                      ),
                    );
                  }),
                ),
                // Restart button (shown only if game is over)
                if (_gameOver)
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: ElevatedButton.icon(
                      onPressed: _resetGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('New Game'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                    ),
                  ),
                const SizedBox(height: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying a status bar/message at top of board.
class StatusBar extends StatelessWidget {
  final String text;
  final Color color;
  const StatusBar({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      decoration: BoxDecoration(
        color: color.withAlpha((0.20 * 255).round()),
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: color.withAlpha((0.45 * 255).round()),
          width: 1.0,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Widget for the 3x3 Tic Tac Toe game board.
class Board extends StatelessWidget {
  final List<String?> board;
  final void Function(int) onTap;
  final double boardSize;
  final bool gameOver;
  final String? winner;

  const Board({
    super.key,
    required this.board,
    required this.onTap,
    required this.boardSize,
    required this.gameOver,
    required this.winner,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color accent = const Color(0xFFFFC107);
    final Color bg = Colors.white;

    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: primary.withAlpha((0.08 * 255).round()),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(3, 6)
          ),
        ]
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            final value = board[idx];
            bool highlight = false;
            // Highlight winning tiles if exists
            if (winner != null && value == winner) highlight = true;
            return GestureDetector(
              onTap: () => gameOver || value != null ? null : onTap(idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: highlight
                      ? accent.withAlpha((0.50 * 255).round())
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: value == null
                        ? primary.withAlpha(90)
                        : highlight
                          ? accent
                          : primary,
                    width: 2.5,
                  ),
                  boxShadow: [
                    if (highlight)
                      BoxShadow(
                          color: accent.withAlpha((0.18 * 255).round()),
                          blurRadius: 10)
                  ]
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: child,
                  ),
                  child: value == null
                      ? const SizedBox.shrink()
                      : Text(
                          value,
                          key: ValueKey(value + idx.toString()),
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: value == "X"
                                ? primary
                                : accent,
                            shadows: [
                              if (highlight)
                                Shadow(
                                    color: accent.withAlpha((0.4 * 255).round()),
                                    blurRadius: 6,
                                    offset: const Offset(2, 3)),
                            ],
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
