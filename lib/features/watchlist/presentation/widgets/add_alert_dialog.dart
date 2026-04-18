import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../providers/price_alert_providers.dart';

class AddAlertDialog extends StatefulWidget {
  final String symbol;
  final double currentPrice;

  const AddAlertDialog({
    super.key,
    required this.symbol,
    required this.currentPrice,
  });

  @override
  State<AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<AddAlertDialog> {
  final _priceController = TextEditingController();
  bool _isAbove = true;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cảnh báo giá ${widget.symbol}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Giá hiện tại: ${widget.currentPrice.toStringAsFixed(0)}',
            style: AppTextStyle.b14R.copyWith(color: AppColors.base40),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Vượt lên'),
                icon: Icon(Icons.arrow_upward, size: 16),
              ),
              ButtonSegment(
                value: false,
                label: Text('Giảm xuống'),
                icon: Icon(Icons.arrow_downward, size: 16),
              ),
            ],
            selected: {_isAbove},
            onSelectionChanged: (v) => setState(() => _isAbove = v.first),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
            decoration: const InputDecoration(
              labelText: 'Giá mục tiêu',
              border: OutlineInputBorder(),
              suffixText: 'VNĐ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            final price = double.tryParse(_priceController.text);
            if (price == null || price <= 0) return;
            Navigator.pop(
              context,
              PriceAlert(
                symbol: widget.symbol,
                targetPrice: price,
                isAbove: _isAbove,
              ),
            );
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
