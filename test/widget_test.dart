import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pml/main.dart';

void main() {
  testWidgets('Academic Overview smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AcademicOverviewApp());

    expect(find.text('Academic Overview'), findsOneWidget);
    expect(find.text('Ferdiansyah Dwi Nugroho'), findsOneWidget);
    expect(find.text('IPK Kumulatif'), findsOneWidget);
    expect(find.text('SKS Diselesaikan'), findsOneWidget);
  });

  testWidgets('Dashboard satu kolom di layar sempit', (tester) async {
    tester.view.physicalSize = const Size(650, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AcademicOverviewApp());

    final width = tester.getSize(find.byType(AcademicInfoCard).first).width;
    expect(width, lessThan(700));
  });

  testWidgets('Dashboard dua kolom di layar lebar', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AcademicOverviewApp());

    final width = tester.getSize(find.byType(AcademicInfoCard).first).width;
    expect(width, greaterThan(500));
  });
}
