import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/parametres/data/parametres_service.dart';
import '../../../../shared/services/document_securite_service.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  MobileScannerController? _controller;
  _ScanResult? _result;
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = MobileScannerController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() => _scanned = true);
    await _controller?.stop();

    final payload = barcode!.rawValue!;
    final parsed = DocumentSecuriteService.parseQrPayload(payload);

    if (parsed == null) {
      setState(() => _result = _ScanResult.invalid(payload));
      return;
    }

    final data = await ParametresService.getSecurite();
    final secret = data['hmac_secret'] as String;
    final valid = DocumentSecuriteService.verifyQrPayload(payload, secret);

    setState(() {
      _result = valid
          ? _ScanResult.valid(parsed)
          : _ScanResult.tampered(parsed);
    });
  }

  void _reset() {
    setState(() {
      _scanned = false;
      _result = null;
    });
    _controller?.start();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scanner QR')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_android_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Le scanner QR est disponible\nuniquement sur Android.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scanner QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (_scanned)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Scanner à nouveau',
            ),
        ],
      ),
      body: _result != null
          ? _buildResult(_result!)
          : _buildScanner(),
    );
  }

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller!,
          onDetect: _onDetect,
        ),
        // Scan overlay
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.teal, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Pointez le QR code d\'un document AvarieApp',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(_ScanResult result) {
    final isValid = result.status == _Status.valid;
    final isTampered = result.status == _Status.tampered;
    final color = isValid ? AppColors.success : AppColors.danger;
    final icon = isValid ? Icons.verified_outlined : Icons.gpp_bad_outlined;
    final title = isValid
        ? 'Document authentique'
        : isTampered
            ? 'Document altéré ou invalide'
            : 'QR code non reconnu';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            if (result.data != null) ...[
              const SizedBox(height: 24),
              _InfoCard(data: result.data!),
            ],
            if (result.status == _Status.invalid) ...[
              const SizedBox(height: 12),
              Text(
                'Ce QR code n\'a pas été généré par AvarieApp.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scanner à nouveau'),
              onPressed: _reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Status { valid, tampered, invalid }

class _ScanResult {
  final _Status status;
  final Map<String, String>? data;

  const _ScanResult({required this.status, this.data});

  factory _ScanResult.valid(Map<String, String> data) =>
      _ScanResult(status: _Status.valid, data: data);

  factory _ScanResult.tampered(Map<String, String> data) =>
      _ScanResult(status: _Status.tampered, data: data);

  factory _ScanResult.invalid(String _) =>
      const _ScanResult(status: _Status.invalid);
}

class _InfoCard extends StatelessWidget {
  final Map<String, String> data;
  const _InfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (data['type']) {
      'DEV' => 'Devis',
      'FAC' => 'Facture',
      'RPT' => 'Rapport',
      _ => data['type'] ?? '',
    };

    final rawDate = data['date'] ?? '';
    final dateFormatted = rawDate.length == 8
        ? '${rawDate.substring(6, 8)}/${rawDate.substring(4, 6)}/${rawDate.substring(0, 4)}'
        : rawDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _Row('Type', typeLabel),
          const Divider(height: 16),
          _Row('Numéro', data['numero'] ?? ''),
          const Divider(height: 16),
          _Row('Date', dateFormatted),
          const Divider(height: 16),
          _Row('Signature', data['hmac'] ?? ''),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
