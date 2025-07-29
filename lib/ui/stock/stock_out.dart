import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/DTO/qr_stock_out_dto.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../../theme/theme.dart';
import '../../models/product_item_info.dart';
import '../../services/dio_client.dart';
import '../../widgets/icon_button.dart';
import 'scan_qr_code.dart';
import 'widgets/instruction_box.dart';
import 'widgets/product_item_info_sheet.dart';

class StockOutSection extends StatefulWidget {
  const StockOutSection({super.key});

  @override
  State<StockOutSection> createState() => _StockOutSectionState();
}

class _StockOutSectionState extends State<StockOutSection> {
  final TextEditingController _qrCodeController = TextEditingController();

  bool _itemFound = false;
  bool _isLoading = false;

  bool _isConfirming = false;
  
  ProductInfo? _productInfo;

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

 Future<bool> _fetchProductInfo(String qrCode) async {
    setState(() {
      _isLoading = true;
      _productInfo = null;
    });

    try {
      final response = await DioClient.dio.get('/ProductItem/scan', queryParameters: {
        'code': qrCode,
      });

      if (response.data['success'] == true) {
        _productInfo = ProductInfo.fromJson(response.data['data']);
        return true;
      } else {
        SnackbarHelper.error(response.data['message'] ?? 'Product not found.');
        return false;
      }
    } catch (e) {
      String errorMsg = 'Error fetching product info.';
      if (e is DioException && e.response?.data != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }
      SnackbarHelper.error(errorMsg);
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _confirmStockOut(String qrCode) async {
    setState(() => _isConfirming = true);

    try {
      final dto = QrStockOutDto(qrCode: qrCode, soldDate: DateTime.now().toUtc());

      final response = await DioClient.dio.post('/StockOut/scan-out', data: dto.toJson());

      if (response.data['success'] == true) {
        SnackbarHelper.success(response.data['message'] ?? 'Stocked out successfully!');
        setState(() {
          _qrCodeController.clear();
          _productInfo = null;
          _itemFound = true;
        });
        return true;
      } else {
        SnackbarHelper.error(response.data['message'] ?? 'Failed to stock out.');
        return false;
      }
    } catch (e) {
      String errorMsg = 'Error during stock out.';
      if (e is DioException && e.response?.data != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }
      SnackbarHelper.error(errorMsg);
      return false;
    } finally {
      setState(() => _isConfirming = false);
    }
  }

  void _showProductInfoSheet(String qrCode) async {
  final success = await _fetchProductInfo(qrCode);
  if (!success || !mounted || _productInfo == null) return;

  final confirmed = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: AppColors.lightBackground,
    builder: (_) => ProductInfoSheet(
      productInfo: _productInfo!,
      qrCode: qrCode,
      isConfirming: _isConfirming,
      onConfirm: _confirmStockOut,
    ),
  );

  if (confirmed != true) {
    setState(() {
      _qrCodeController.clear();
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
                      width: double.infinity,
                      label: (_isLoading || _isConfirming) ? 'Processing...' : 'Scan QR Code',
                      icon: (_isLoading || _isConfirming) ? LucideIcons.loader : LucideIcons.scanLine,
                      backgroundColor: AppColors.orangeIcon,
                      onPressed: (_isLoading || _isConfirming)
                        ? null
                        : () async {
                            String code = _qrCodeController.text.trim();

                            if (code.isEmpty) {
                              final scannedCode = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                              );

                              if (scannedCode != null && scannedCode is String) {
                                code = scannedCode;
                                _qrCodeController.text = code;
                              } else {
                                return;
                              }
                            }
                            final valid = RegExp(r'^PIID\|\d+\|SN\|.+\|PID\|\d+$').hasMatch(code);
                            if (!valid) {
                              SnackbarHelper.error('Invalid QR format.');
                              return;
                            }
                            _showProductInfoSheet(code);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              if (_itemFound)
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EC),
                    borderRadius: BorderRadius.circular(10.0),
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
              InstructionBox(),
            ],
          ),
        ),
      ],
    );
  }
}
