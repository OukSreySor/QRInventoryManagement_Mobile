import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/DTO/qr_stock_out_dto.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../../theme/theme.dart';
import '../../services/dio_client.dart';
import '../../widgets/icon_button.dart';

class StockOutSection extends StatefulWidget {
  const StockOutSection({super.key});

  @override
  State<StockOutSection> createState() => _StockOutSectionState();
}

class _StockOutSectionState extends State<StockOutSection> {
  final TextEditingController _qrCodeController = TextEditingController();

  bool _itemFound = false;
  bool _isLoading = false;

  // Call backend to scan and stock out product
  Future<void> _handleScanQrCode() async {
    final qrCode = _qrCodeController.text.trim();
    if (qrCode.isEmpty) {
      SnackbarHelper.error('Please enter or scan a QR code.');
      return;
    }
    final validFormat = RegExp(r'^PIID\|\d+\|SN\|.+\|PID\|\d+$').hasMatch(qrCode);
    if (!validFormat) {
      SnackbarHelper.error('Invalid QR code format.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = QrStockOutDto(
        qrCode: qrCode,
        soldDate: DateTime.now().toUtc()
      );

      final response = await DioClient.dio.post(
        '/StockOut/scan-out',
        data: dto.toJson(),
      );
    
      final data = response.data;
      if (data['success'] == true) {
        setState(() {
          _itemFound = true;  
          _qrCodeController.clear(); 
        });
        SnackbarHelper.success(data['message'] ?? 'Item stocked out successfully!');
      } else {
        setState(() {
          _itemFound = false;
        });
        SnackbarHelper.error(data['message'] ?? 'Failed to stock out the item.');
      }
    } catch (e) {

      String errorMsg = 'Failed to stock out item.';
      if (e is DioException) {
        if (e.response != null && e.response?.data != null) {
          errorMsg = e.response?.data['message'] ?? errorMsg;
        } else {
          errorMsg = e.message ?? errorMsg;
        }
      } else {
        errorMsg = e.toString();
      }
      SnackbarHelper.error(errorMsg);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: 'e.g. PIID|30|SN|W-CHOCO-2|PID|15',
                        hintStyle: TextStyle(color: AppColors.textLight, fontSize: 15.0), 
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
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _handleScanQrCode(),
                    ),
                    const SizedBox(height: 16.0),
                    ActionIconButton(
                      label:  _isLoading ? 'Processing...' : 'Scan QR Code',
                      icon: _isLoading ? LucideIcons.loader : LucideIcons.scanLine,
                      backgroundColor: AppColors.orangeIcon,
                      onPressed: _isLoading ? null : () => _handleScanQrCode(),
                      height: 48.0, 
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28.0),
              if (_itemFound)
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
                          Expanded(
                            child: Text(
                              'Item stocked out successfully!',
                              style: AppTextStyles.authSectionDescription
                            ),
                          ),
                           IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _itemFound = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              const SizedBox(height: 16.0),
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
                            '1. Scan the QR code\n'
                            '2. Manually enter the QR code\n'
                            '3. Click “Scan QR Code” to confirm the transaction',
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
