import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:expense_tracker/features/settings/ui/widgets/settings_tile.dart';
import 'package:expense_tracker/features/sms_parser/services/sms_service.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';

class SmsSettingsSection extends ConsumerStatefulWidget {
  const SmsSettingsSection({super.key});

  @override
  ConsumerState<SmsSettingsSection> createState() => _SmsSettingsSectionState();
}

class _SmsSettingsSectionState extends ConsumerState<SmsSettingsSection> {
  double _reScanDays = 30;
  bool _isScanning = false;

  void _showAddSenderDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Add Bank Sender ID', style: GoogleFonts.outfit(color: Theme.of(context).textTheme.bodyLarge?.color)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. SBI-SBIBNK',
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6366F1))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(settingsProvider.notifier).addBankFilter(controller.text.trim().toUpperCase());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _startRescan() async {
    setState(() => _isScanning = true);
    
    final settings = ref.read(settingsProvider);
    final repo = ref.read(expenseRepositoryProvider);
    
    if (repo != null) {
      final smsService = SmsService();
      await smsService.scanInbox(_reScanDays.toInt(), settings, repo);
    }
    
    if (mounted) {
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inbox scan complete!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SMS & Auto-scan',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        SettingsSwitchTile(
          icon: Icons.message_rounded,
          label: 'Enable SMS Reading',
          value: settings.isSmsScanEnabled,
          onChanged: (val) => notifier.updateSmsScanEnabled(val),
        ),

        if (settings.isSmsScanEnabled) ...[
          const SizedBox(height: 8),
          Text(
            'Whitelisted Bank Senders',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...settings.bankFilterList.map((sender) {
                return Chip(
                  label: Text(sender, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => notifier.removeBankFilter(sender),
                  backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  side: const BorderSide(color: Color(0xFF6366F1), width: 1),
                );
              }),
              ActionChip(
                label: const Text('Add', style: TextStyle(fontSize: 12, color: Colors.white)),
                avatar: const Icon(Icons.add, size: 14, color: Colors.white),
                backgroundColor: const Color(0xFF6366F1),
                onPressed: _showAddSenderDialog,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          Text(
            'Rescan Inbox',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Scan last ${_reScanDays.toInt()} days', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                  ],
                ),
                Slider(
                  value: _reScanDays,
                  min: 7,
                  max: 90,
                  divisions: 2, // 7 -> 48.5 -> 90. We'll snap to 7, 30, 90 via logic if we want, or just let it slide
                  activeColor: const Color(0xFF6366F1),
                  onChanged: (val) {
                    setState(() {
                      if (val < 20) _reScanDays = 7;
                      else if (val < 60) _reScanDays = 30;
                      else _reScanDays = 90;
                    });
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isScanning ? null : _startRescan,
                    icon: _isScanning 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.sync_rounded, color: Colors.white),
                    label: Text(
                      _isScanning ? 'Scanning...' : 'Start Scan',
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ],
    );
  }
}
