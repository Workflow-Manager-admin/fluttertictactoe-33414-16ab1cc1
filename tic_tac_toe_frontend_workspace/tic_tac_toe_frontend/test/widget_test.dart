import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('App bar has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Tic Tac Toe'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Game board renders with 9 tiles', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());
    // Allow widget trees to build
    await tester.pumpAndSettle();

    // Each board tile is a GestureDetector containing a Container
    expect(find.byType(GestureDetector), findsNWidgets(9));
  });

  testWidgets('Status bar/top message is visible', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());
    await tester.pumpAndSettle();

    // Should show "Player X's turn" on new game
    expect(find.textContaining("Player X's turn"), findsOneWidget);
  });
}
