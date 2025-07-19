import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../DTO/product_stock_summary_dto.dart';
import '../../services/product_service.dart';
import '../../theme/theme.dart';

class ProductStockSummary extends StatefulWidget {
  
  final void Function(int productId)? onViewDetails;

  const ProductStockSummary({
    super.key,
    this.onViewDetails,
  });

  @override
  State<ProductStockSummary> createState() => _ProductStockSummaryState();
}

class _ProductStockSummaryState extends State<ProductStockSummary> {

  List<ProductStockSummaryDTO> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductSummary();
  }

  Future<void> _fetchProductSummary() async {
    try {
      final products = await ProductService().fetchProductStockSummary();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading product summary: $e");
      setState(() => _isLoading = false);
    }
  }
  
  Color _getStockColor(int stock) {
    if (stock <= 1) {
      return Colors.red.shade700;
    } else if (stock <= 5) {
      return Colors.orange.shade700;
    }
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final totalProducts = _products.length;
    final totalStock = _products.fold(0, (sum, p) => sum + p.quantityInStock);

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(LucideIcons.boxes, size: 24.0, color: Colors.black),
                SizedBox(width: 10.0),
                _isLoading
                    ? Text("Loading...", style: AppTextStyles.cardHeader)
                    : Text(
                      'Inventory ($totalProducts products, $totalStock units)',
                      style: AppTextStyles.cardHeader
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        if (!_isLoading)
          ..._products.map((product) => Container(
            margin: const EdgeInsets.only(bottom: 8.0),
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
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            product.categoryName,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: _getStockColor(product.quantityInStock),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Text(
                              '${product.quantityInStock} in stock',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          if (widget.onViewDetails != null) {
                            widget.onViewDetails!(product.id);
                          }
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          minimumSize: WidgetStateProperty.all(Size.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return AppColors.primaryBlue;
                              }
                              return AppColors.textDark;
                            }
                          ),
                          textStyle: WidgetStateProperty.all(
                          const TextStyle(
                            fontSize: 14.0,
                            decoration: TextDecoration.underline, 
                          ),
                      ),
                    ),
                        child: const Text(
                          'View Details',
                        ),
                      )
                    ]
                  )
                ]
              )
            )
          )
        )
      ] 
    );
  }
}
