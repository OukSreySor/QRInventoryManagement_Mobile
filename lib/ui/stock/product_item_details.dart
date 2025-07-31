import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../DTO/product_item_detail_dto.dart';
import '../../services/api_service.dart';
import '../../theme/theme.dart';
import '../../utils/date_formatter.dart';
import '../../utils/no_data_place_holder.dart';

class ProductItemDetails extends StatefulWidget {
  final int productId;
   final VoidCallback? onBack;

  const ProductItemDetails({
    super.key,
    required this.productId, this.onBack
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

   @override
  void didUpdateWidget(covariant ProductItemDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.productId != oldWidget.productId) {
      _isLoading = true; // Reset loading state
      _items = []; // Clear old data
      _fetchProductItems(); // Fetch new data
    }
  }

  Future<void> _fetchProductItems() async {
    try {
      final response = await ApiService().get<List<ProductItemDetailDTO>>(
        '/ProductItem/by-product/${widget.productId}',
        context: context,
        fromJson: (data) {
          final List items = data['data'];
          return items.map((e) => ProductItemDetailDTO.fromJson(e)).toList();
        },
      );

      if (response != null) {
        response.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        setState(() {
          _items = response;
          _isLoading = false;
        });
      }
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
      return Column(
        children: [
          _buildHeaderRow(context, '', showBackButton: true),
          SizedBox(
            height: 300.0,
            child: const NoDataPlaceholder(
              title: 'No items found for this product',
              message: 'Start by adding some items using the “Stock In” tab',
              icon: LucideIcons.package, 
            ),
          ),
        ],
      );
    }
     final firstItem = _items.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                _buildHeaderRow(context, firstItem.productName),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8.0),

        ..._items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _ProductItemCard(item: item),
        )),
      ],
    ),
  
    );  
  }

   Widget _buildHeaderRow(BuildContext context, String title, {bool showBackButton = true}) {
    return Row(
      children: [
        if (showBackButton && widget.onBack != null) 
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16.0, color: Colors.black),
            onPressed: widget.onBack, 
            tooltip: 'Back to Product Summary',
          ),
          Text(
            title,
            style: AppTextStyles.cardHeader.copyWith(fontSize: 14.0),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _ProductItemCard extends StatelessWidget {
  final ProductItemDetailDTO item;
  const _ProductItemCard({required this.item});
   String _formatDate(DateTime? date) {
    if (date == null) {
      return 'N/A';
    }
    return DateFormatter.formatDateNumeric(date);
  }

  @override
  Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: AppTextStyles.titleStyle,
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                border: Border.all(color: AppColors.textFieldBorder),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                item.status, 
                                style: AppTextStyles.valueStyle.copyWith(color: AppColors.darkBlue),
                              ),
                            ),
                          ],
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
                            style: AppTextStyles.valueStyle.copyWith(color: AppColors.pinkRedIcon),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(LucideIcons.hash, size: 16.0, color: AppColors.darkBlue),
                      const SizedBox(width: 4.0),
                      Text(
                        'Serial-Number: ${item.serialNumber}',
                        style: AppTextStyles.valueStyle
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16.0, color: AppColors.purpleIcon),
                      const SizedBox(width: 4.0),
                      Text(
                        'Added: ${_formatDate(item.addedDate)}',
                        style: AppTextStyles.valueStyle
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(LucideIcons.user2, size: 16.0, color: AppColors.textBlack),
                      const SizedBox(width: 4.0),
                      Text(
                        'By: ${item.userName}',
                        style: AppTextStyles.valueStyle
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mfg: ${_formatDate(item.manufacturingDate)}',
                        style: AppTextStyles.valueStyle
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Exp: ${_formatDate(item.expiryDate)}',
                        style: AppTextStyles.valueStyle.copyWith(color: AppColors.orangeIcon)
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color:AppColors.textFieldBorder, width: 2.0),
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
