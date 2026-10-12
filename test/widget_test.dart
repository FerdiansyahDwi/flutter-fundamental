import 'package:flutter_test/flutter_test.dart';
import 'package:pml/main.dart';

void main() {
  testWidgets('Academic Overview smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AcademicOverviewApp());

    // Verify title and headers
    expect(find.text('Academic Overview'), findsOneWidget);
    expect(find.text('Ferdiansyah Dwi Nugroho'), findsOneWidget);
    expect(find.text('IPK Kumulatif'), findsOneWidget);
    expect(find.text('SKS Diselesaikan'), findsOneWidget);
    expect(find.text('Presensi & Kehadiran'), findsOneWidget);
    expect(find.text('Mata Kuliah Aktif'), findsOneWidget);
  });
}
