import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:si_lapor/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // cek apakah aplikasi berhasil tampil
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
