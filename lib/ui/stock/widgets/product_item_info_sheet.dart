import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/product_item_info.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_formatter.dart';

class ProductInfoSheet extends StatelessWidget {
  final ProductInfo productInfo;
  final String qrCode;
  final bool isConfirming;
  final Future<bool> Function(String qrCode) onConfirm;

  const ProductInfoSheet({
    super.key,
    required this.productInfo,
    required this.qrCode,
    required this.isConfirming,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: AppColors.textLight),
                onPressed: () => Navigator.pop(context, false),
              ),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    productInfo.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTicketDetailColumn(
                      icon: LucideIcons.scan,
                      label: 'Serial',
                      value: productInfo.serialNumber,
                    ),
                    _buildTicketDetailColumn(
                      icon: productInfo.status == 'InStock'
                          ? LucideIcons.checkCircle
                          : LucideIcons.xCircle,
                      label: 'Status',
                      value: productInfo.status,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildInfoRow(
                  label: 'Manufactured',
                  value: productInfo.manufacturingDate != null
                      ? DateFormatter.formatDateNumeric(productInfo.manufacturingDate!)
                      : 'N/A',
                ),
                const SizedBox(height: 15),
                _buildInfoRow(
                  label: 'Expires',
                  value: productInfo.expiryDate != null
                      ? DateFormatter.formatDateNumeric(productInfo.expiryDate!)
                      : 'N/A',
                ),
                const SizedBox(height: 15),
                _buildInfoRow(label: 'QR Code', value: qrCode),
                const SizedBox(height: 15),
                _buildInfoRow(label: 'Product ID', value: productInfo.productId.toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isConfirming
                  ? null
                  : () async {
                      final success = await onConfirm(qrCode);
                      if (success && context.mounted) Navigator.pop(context, true);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isConfirming
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Confirm Stock Out',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: AppColors.textLight)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
