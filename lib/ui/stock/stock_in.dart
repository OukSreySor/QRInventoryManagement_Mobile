import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/theme.dart';
import '../../widgets/custom_text_feild.dart';
import '../../widgets/primary_button.dart';

class StockInSection extends StatefulWidget {
  const StockInSection({super.key});

  @override
  State<StockInSection> createState() => _StockInSectionState();
}

class _StockInSectionState extends State<StockInSection> {
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _mfgDateController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  String? _selectedProduct;

  final List<String> _products = [
    'Select product',
    'Product A',
    'Product B',
    'Product C',
  ];

  @override
  void dispose() {
    _serialNumberController.dispose();
    _mfgDateController.dispose();
    _expDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  void _handleGenerateQrAndAdd() {
    print('Selected Product: $_selectedProduct');
    print('Serial: ${_serialNumberController.text}');
    print('MFG: ${_mfgDateController.text}');
    print('EXP: ${_expDateController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.qrCode,
                color: AppColors.greenIcon
              ),
              const SizedBox(width: 8),
              Text(
                'Stock In', 
                style: AppTextStyles.authSectionTitle
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Add new items and generate QR codes',
            style: AppTextStyles.authSectionDescription,
          ),
          const SizedBox(height: 24),
          Text('Product *', style: AppTextStyles.textFieldLabel),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border.all(color: AppColors.textFieldBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedProduct,
                icon: Icon(
                  LucideIcons.chevronDown,
                  color: AppColors.textMedium,
                ),
                style: TextStyle(color: AppColors.textDark),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                  });
                },
                items:
                    _products
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Serial Number
          CustomTextField(
            label: 'Serial Number',
            hintText: 'Auto-generated if empty',
            controller: _serialNumberController,
          ),

          const SizedBox(height: 20),

          // Dates
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Manufacturing Date',
                  hintText: 'MM/DD/YYYY',
                  controller: _mfgDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _mfgDateController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Expiry Date',
                  hintText: 'MM/DD/YYYY',
                  controller: _expDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _expDateController),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          PrimaryButton(
            text: 'Generate QR & Add to Inventory',
            onPressed: _handleGenerateQrAndAdd,
          ),
        ],
      ),
    );
  }
}
