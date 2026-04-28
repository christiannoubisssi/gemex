import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RhDashboardScreen extends ConsumerWidget {
  const RhDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ressources Humaines')),
      body: const Center(
        child: Text(
          'Module RH — à développer en Phase 3',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
