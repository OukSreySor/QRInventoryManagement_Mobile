import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/models/product_dropdown.dart';

import '../../DTO/product_item_stock_in_dto.dart';
import '../../services/dio_client.dart';

import '../../theme/theme.dart';
import '../../utils/date_formatter.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/stock_in_date_validator.dart';
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
  
  List<ProductDropdown> _products = [];

  ProductDropdown? _selectedProduct;

  bool _showSuccessView = false;
  String? _qrImageUrl;
  String? _qrString;

  @override
  void initState() {
    super.initState();
    _fetchProductNames();
  }

  Future<void> _fetchProductNames() async {
  try {
    final response = await DioClient.dio.get('/Product/names');

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      setState(() {
        _products = data.map((item) => ProductDropdown.fromJson(item)).toList();
      });
    } else {
      print('Error: ${response.statusCode} ${response.statusMessage}');
    }
  } catch (e) {
    print('Failed to load product names: $e');
  }
}

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
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  void _handleGenerateQrAndAdd() async{
    if (_selectedProduct == null || _serialNumberController.text.isEmpty ||
      _mfgDateController.text.isEmpty || _expDateController.text.isEmpty) {

      SnackbarHelper.error('Please fill all required fields');
    
      return;
  }
  
  try {
    final manufacturingDate = DateFormatter.parseDate(_mfgDateController.text);
    final expiryDate = DateFormatter.parseDate(_expDateController.text);
    final addedDate = DateTime.now();

    final validator = StockInDateValidator(
      manufacturingDate: manufacturingDate!,
      expiryDate: expiryDate!,
      addedDate: addedDate,
    );

    final validationError = validator.validate();
    if (validationError != null) {
      SnackbarHelper.error(validationError);
      return;
    }

    final dto = ProductItemStockInDto(
      serialNumber: _serialNumberController.text.trim(),
      productId: _selectedProduct!.id,
      manufacturingDate: manufacturingDate,
      expiryDate: expiryDate,
      addedDate: addedDate,
    );

    print("Selected Product: ${_selectedProduct!.name} (ID: ${_selectedProduct!.id})");
    print("Serial: ${dto.serialNumber}");
    print("MFG: ${dto.manufacturingDate}");
    print("EXP: ${dto.expiryDate}");

    final response = await DioClient.dio.post(
      '/ProductItem/create-stockin',
      data: dto.toJson(),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final qrImageUrl = response.data['data']['qrImageUrl'];
      final qrString = response.data['data']['qR_Code'];
      print('QR Image URL: $qrImageUrl');

      setState(() {
        _qrImageUrl = qrImageUrl;
        _qrString = qrString;
        _showSuccessView = true;

        _serialNumberController.clear();
        _mfgDateController.clear();
        _expDateController.clear();
        _selectedProduct = null;
      });
      SnackbarHelper.success('Stock-in successful!');
    }
  } catch (e) {
    SnackbarHelper.error('Failed to stock in. Check input and try again.');
  }

}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.textFieldBorder, width: 1.0)
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showSuccessView ? _buildQrSuccessView() : 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.qrCode, color: AppColors.greenIcon),
                const SizedBox(width: 8.0),
                Text('Stock In', style: AppTextStyles.authSectionTitle),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Add new items and generate QR codes',
              style: AppTextStyles.authSectionDescription,
            ),
            const SizedBox(height: 24.0),
            Text('Product *', style: AppTextStyles.textFieldLabel),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                border: Border.all(color: AppColors.textFieldBorder),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ProductDropdown>(
                  isExpanded: true,
                  value: _selectedProduct,
                  icon: Icon(
                    LucideIcons.chevronDown,
                    color: AppColors.textBlack,
                  ),
                  hint: Text(
                    "Select product", 
                    style: TextStyle(fontSize: 16.0, color: AppColors.textLight)
                  ),
                  style: TextStyle(color: AppColors.textBlack),
                  onChanged: (ProductDropdown? value) {
                    setState(() {
                      _selectedProduct = value;
                    });
                  },
                  items: _products
                        .map((p) => DropdownMenuItem<ProductDropdown>(value: p, child: Text(p.name)))
                        .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
        
            // Serial Number
            CustomTextField(
              label: 'Serial Number',
              hintText: 'Input the Serial Number',
              hintFontSize: 15.0,
              controller: _serialNumberController,
            ),
            const SizedBox(height: 20.0),

            // Dates
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Manufacture Date',
                    hintText: 'd-m-y',
                    controller: _mfgDateController,
                    readOnly: true,
                    onTap: () => _selectDate(context, _mfgDateController),
                    suffixIcon: IconButton(
                      onPressed: () => _selectDate(context, _mfgDateController),
                      icon: Icon(
                        LucideIcons.calendar,
                        color: AppColors.textBlack,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: CustomTextField(
                    label: 'Expiry Date',
                    hintText: 'd-m-y',
                    controller: _expDateController,
                    readOnly: true,
                    onTap: () => _selectDate(context, _expDateController),
                    suffixIcon: IconButton(
                      onPressed: () => _selectDate(context, _expDateController),
                      icon: Icon(
                        LucideIcons.calendar,
                        color: AppColors.textBlack,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        
            const SizedBox(height: 28.0),
        
            PrimaryButton(
              text: 'Generate QR & Add to Inventory',
              onPressed: _handleGenerateQrAndAdd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrSuccessView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.qrCode, color: AppColors.greenIcon),
              const SizedBox(width: 8.0),
              Text('Stock In', style: AppTextStyles.authSectionTitle),
            ],
          ),
          Text(
            'Add new items and generate unique QR codes',
            style: AppTextStyles.authSectionDescription,
          ), 
        ],
      ), 
      const SizedBox(height: 8.0),
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Color(0xFFAED0BA), width: 1.0)
        ),        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16.0),
            const Text("QR Code Generated!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            if (_qrImageUrl != null)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greenIcon),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Image.network(_qrImageUrl!, width: 200.0, height: 200.0),
                    const SizedBox(height: 12),
                    if (_qrString != null)
                      Text(_qrString!, style: const TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            const SizedBox(height: 20.0),
            const Text("Save or print this QR code to attach to your item", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Add another Item',
              onPressed: () {
                setState(() {
                  _showSuccessView = false;
                  _qrImageUrl = null;
                  _qrString = null;
                });
              },
              backgroundColor: AppColors.greenIcon,
            ),
          ],
        )
      )
    ]
  );
}

}

