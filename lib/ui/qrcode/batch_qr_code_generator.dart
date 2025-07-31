import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';
import 'package:qr_inventory_management/models/batch_qr_items.dart';
import 'package:qr_inventory_management/services/api_service.dart';
import 'package:qr_inventory_management/theme/theme.dart';
import 'package:qr_inventory_management/widgets/primary_button.dart';

import 'generate_pdf.dart';


class BatchQrCodeGenerator extends StatefulWidget {
  const BatchQrCodeGenerator({super.key});

  @override
  State<BatchQrCodeGenerator> createState() => _BatchQrCodeGeneratorState();
}

class _BatchQrCodeGeneratorState extends State<BatchQrCodeGenerator> {
  final ApiService _apiService = ApiService();

  String? _selectedPdfLayout = '2x8 (16 per page)';
  bool _selectAll = false;

  List<BatchQrItems> _items = [];
  Set<int> _selectedIds = {};

  bool _isLoading = false;
  String? _error;

  final Map<String, List<int>> layoutMap = {
    '2x8 (16 per page)': [2, 8],
    '2x4 (8 per page)': [2, 4],
    '3x7 (21 per page)': [3, 7],
    '4x5 (20 per page)': [4, 5],
  };

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _apiService.get<Map<String, dynamic>>(
      '/ProductItem/in-stock', 
      fromJson: (data) => data as Map<String, dynamic>,
      context: context,
    );

    if (result == null) {
      setState(() {
        _error = "Failed to load data.";
        _isLoading = false;
      });
      return;
    }

    try {
      final List<dynamic> dataList = result["data"];
      final items = dataList
          .map((itemJson) => BatchQrItems.fromJson(itemJson))
          .toList(growable: false);

      setState(() {
        _items = items;
        _selectedIds.clear();
        _selectAll = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Data parsing error: $e";
        _isLoading = false;
      });
    }
  }

  void _toggleSelectAll(bool? value) {
    if (value == null) return;
    setState(() {
      _selectAll = value;
      _selectedIds =
          value ? _items.map((e) => e.id).toSet() : <int>{};
    });
  }

  void _toggleItemSelection(bool? value, int itemId) {
    if (value == null) return;
    setState(() {
      if (value) {
        _selectedIds.add(itemId);
      } else {
        _selectedIds.remove(itemId);
      }
      _selectAll = _selectedIds.length == _items.length;
    });
  }

  
  Future<void> _handleGeneratePdf() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    final layout = layoutMap[_selectedPdfLayout!]!;
    final selectedItems = _items
        .where((item) => _selectedIds.contains(item.id))
        .map((item) => {
              'qr': item.qrImageUrl,
              'name': item.productName,
              'sn': item.serialNumber,
            })
        .toList();

    final pdfData = await generateQrGridPdf(
      items: selectedItems,
      columns: layout[0],
      rows: layout[1],
    );

    await Printing.layoutPdf(onLayout: (_) => pdfData);

    setState(() {
      _selectedIds.clear();
      _selectAll = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(LucideIcons.qrCode, size: 28.0, color: AppColors.textBlack),
                const SizedBox(width: 10.0),
                Text('Batch QR Code Generator', style: AppTextStyles.cardHeader),
              ],
            ),
            const SizedBox(height: 16.0),
      
            // Layout dropdown
            Text('PDF Layout', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedPdfLayout,
                  icon: const Icon(LucideIcons.chevronDown, color: AppColors.textBlack,),
                  onChanged: (val) => setState(() => _selectedPdfLayout = val),
                  items: layoutMap.keys.map((layout) {
                    return DropdownMenuItem<String>(
                      value: layout,
                      child: Row(
                        children: [
                          Icon(LucideIcons.layoutGrid, size: 18.0, color: AppColors.textBlack),
                          const SizedBox(width: 8.0),
                          Text(layout),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
      
            // Select All checkbox
            AnimatedContainer( 
              duration: const Duration(milliseconds: 200), 
              height: 50,
              decoration: BoxDecoration(
                color: _selectAll ? AppColors.textFieldBorder: AppColors.textWhite, // Change background color
                border: Border.all(
                  color: AppColors.textFieldBorder, 
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _selectAll,
                    onChanged: _items.isEmpty ? null : _toggleSelectAll,
                    activeColor: AppColors.textBlack,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Select All (${_items.length} items)',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack, 
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
      
            // Item list
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
            else if (_items.isEmpty)
              const Center(child: Text('No items available.'))
            else
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final selected = _selectedIds.contains(item.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
                      ),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.textBlack)),
                            Text('SN: ${item.serialNumber}', style: TextStyle(fontSize: 12.0, color: AppColors.textDark)),
                          ],
                        ),
                        value: selected,
                        onChanged: (val) => _toggleItemSelection(val, item.id),
                        activeColor: AppColors.textBlack,
                        checkColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8.0),
      
            // Generate PDF button
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Generate PDF',
                onPressed: _handleGeneratePdf,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
