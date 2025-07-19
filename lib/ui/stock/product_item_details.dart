import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../DTO/product_item_detail_dto.dart';
import '../../services/product_service.dart';
import '../../theme/theme.dart';

class ProductItemDetails extends StatefulWidget {
  final int productId;

  const ProductItemDetails({
    super.key,
    required this.productId
  });

  @override
  State<ProductItemDetails> createState() => _ProductItemDetailsState();
}

class _ProductItemDetailsState extends State<ProductItemDetails> {
  bool _isLoading = true;
  List<ProductItemDetailDTO> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchProductItems();
  }
  Future<void> _fetchProductItems() async {
    try {
      final items = await ProductService().getItemsByProduct(widget.productId);
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      SnackbarHelper.error('Failed to load product items.');
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    if (_items.isEmpty) {
      return const Center(child: Text('No items found for this product.'));
    }
     final firstItem = _items.first;

    return SizedBox(
      height: 400.0,
      width: double.infinity,
      child: ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(LucideIcons.package, size: 24.0, color: Colors.black),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Product Items Details - ${firstItem.productName}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12.0),

        ..._items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _ProductItemCard(item: item),
        )),
      ],
    ),
  
    );  
  }
}

class _ProductItemCard extends StatelessWidget {
  final ProductItemDetailDTO item;
  const _ProductItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${item.sellingPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Cost: \$${item.unitPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 16.0, color: AppColors.textDark),
                      const SizedBox(width: 4.0),
                      Text(
                        item.qrCode,
                        style: const TextStyle(fontSize: 14.0, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16.0, color: AppColors.textDark),
                      const SizedBox(width: 4.0),
                      Text(
                        'Added: ${item.addedDate}',
                        style: const TextStyle(fontSize: 14.0, color: AppColors.textDark),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.person_outline, size: 16.0, color: AppColors.textDark),
                      const SizedBox(width: 4.0),
                      Text(
                        'By: ${item.userName}',
                        style: const TextStyle(fontSize: 14.0, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'Mfg: ${item.manufacturingDate}',
                        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Exp: ${item.expiryDate}',
                        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5), 
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      image: DecorationImage(
                        image: NetworkImage(item.qrImageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );
  
  }
}
