import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';
import '../../widgets/icon_button.dart';

class StockOutSection extends StatefulWidget {
  const StockOutSection({super.key});

  @override
  State<StockOutSection> createState() => _StockOutSectionState();
}

class _StockOutSectionState extends State<StockOutSection> {
  final TextEditingController _qrCodeController = TextEditingController();

  bool _itemFound = false;

  void _handleScanQrCode() {
    setState(() {
      _itemFound = true; 
    });
  }

  @override
  void dispose() {
    _qrCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  Icon(LucideIcons.scanLine, color: AppColors.orangeIcon),
                  const SizedBox(width: 8.0),
                  Text('Stock Out', style: AppTextStyles.authSectionTitle),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                'Scan QR codes to remove items from inventory',
                style: AppTextStyles.authSectionDescription,
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.orangeIcon, width: 1.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        LucideIcons.scanLine, 
                        size: 48,
                        color: AppColors.orangeIcon
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Scan or Enter QR Code',
                      style: AppTextStyles.textFieldLabel.copyWith(color: AppColors.textBlack, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _qrCodeController,
                      decoration: InputDecoration(
                        hintText: 'e.g. SF - 1723847304 - 2mnvh',
                        hintStyle: TextStyle(color: AppColors.textLight), 
                        filled: true,
                        fillColor: AppColors.cardBackground, 
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(  
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(  
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: AppColors.orangeIcon, width: 2.0), 
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ActionIconButton(
                      label: 'Scan QR Code',
                      icon: LucideIcons.scanLine,
                      backgroundColor: AppColors.orangeIcon,
                      onPressed: _handleScanQrCode,
                      height: 48.0, 
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28.0),
              if (_itemFound)
                //ItemFoundCard(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EC),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: const Color(0xFFB1E3C1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.packageCheck,
                              color: AppColors.greenIcon, size: 20.0),
                          const SizedBox(width: 8.0),
                          Text('Item Found',
                              style: AppTextStyles.authSectionTitle),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // 🧾 Item Detail Box
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: const Color(0xFFB1E3C1), width: 2.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ItemName',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8.0),

                            // 1st Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Category: \nelectronics'),
                                Text('Available Stock: \n1 Unit'),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // 2nd Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Unit Cost: \n\$150.00'),
                                Text('Selling Price: \n\$160.00'),
                              ],
                            ),
                            const SizedBox(height: 4),

                            const Text('Serial Number: \nSF1723847304'),
                            const Text('QR Code: \nSF - 1723847304 - 2mnvh'),
                          ],
                        ),     
                      ),
                      const SizedBox(height: 12.0),
                      ActionIconButton(
                        label: 'Remove 1 Unit',
                        icon: LucideIcons.checkCircle,
                        backgroundColor: AppColors.pinkRedIcon,
                        onPressed: _handleScanQrCode,
                        height: 48.0, 
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 28.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD2DEF9),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.borderContainer, width: 1.0)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryBlue),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'How to use Stock Out',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '1. Scan or manually enter the QR code\n'
                            '2. Verify the item details and available stock\n'
                            '3. Enter quantity to remove and optional notes\n'
                            '4. Click “Remove” to confirm the transaction',
                            style: TextStyle(fontSize: 14.0, color: Color(0xFF133782)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class ItemFoundCard extends StatelessWidget {
  const ItemFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F5EC), 
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFB1E3C1)), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ItemName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Info Rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text.rich(
                TextSpan(
                  text: 'Category: ',
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'electronics',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Available Stock: ',
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: '1 Units',
                      style: TextStyle(
                        color: AppColors.darkBlue, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text.rich(
                TextSpan(
                  text: 'Unit Cost: ',
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: '\$150.00',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Selling Price: ',
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: '\$160.00',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text.rich(
            TextSpan(
              text: 'Serial Number: ',
              style: TextStyle(fontSize: 16),
              children: [
                TextSpan(
                  text: 'SF1723847304',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text.rich(
            TextSpan(
              text: 'QR Code: ',
              style: TextStyle(fontSize: 16),
              children: [
                TextSpan(
                  text: 'SF - 1723847304 - 2mnvh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
