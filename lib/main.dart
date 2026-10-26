import 'package:flutter/material.dart';
import 'package:pml/model/plan.dart';
import 'package:pml/provider/plan_provider.dart';
import 'package:pml/views/plan_creator_screen.dart';

void main() => runApp(MasterPlanApp());

class MasterPlanApp extends StatelessWidget {
  const MasterPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlanProvider(
      notifier: ValueNotifier<List<Plan>>(
        const [],
      ), // Sekarang berisikan List kosong
      child: MaterialApp(
        title: 'State management app',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const PlanCreatorScreen(), // Mengarah ke layar yang baru dibuat
      ),
    );
  }
}
