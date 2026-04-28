import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComptabiliteScreen extends ConsumerWidget {
  const ComptabiliteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comptabilité')),
      body: const Center(
        child: Text(
          'Module comptabilité — à développer en Phase 3',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
