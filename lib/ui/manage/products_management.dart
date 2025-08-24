import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../DTO/product_dto.dart';
import '../../models/enums/product_status.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';
import '../../theme/theme.dart';
import '../../utils/confirm_dialog.dart';
import '../../utils/no_data_place_holder.dart';
import '../../widgets/icon_button.dart';
import 'widgets/add_edit_product_form.dart';

class ProductsManagementScreen extends StatefulWidget {
  const ProductsManagementScreen({
    super.key,
  });

  @override
  State<ProductsManagementScreen> createState() => _ProductsManagementScreenState();
}

class _ProductsManagementScreenState extends State<ProductsManagementScreen> {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  bool _isLoading = true;
  bool _showForm = false;
  bool _isEditMode = false;
  Product? _editingProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _apiService.get<List<Product>>(
        '/Product',
        context: context,
        fromJson: (data) {
          final List items = data['data'];
          return items.map((e) => ProductDTO.fromJson(e)).toList();
        },
      );

      if (products != null) {
        setState(() {
          _products = products;
        });
      }
    } catch (e) {
      SnackbarHelper.error('Failed to fetch products');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startAddProduct() {
    setState(() {
      _showForm = true;
      _isEditMode = false;
      _editingProduct = null;
    });
  }

  void _startEditProduct(Product product) {
    setState(() {
      _showForm = true;
      _isEditMode = true;
      _editingProduct = product;
    });
  }

  void _cancelForm() {
    setState(() {
      _showForm = false;
      _isEditMode = false;
      _editingProduct = null;
    });
  }

  Future<void> _deleteProduct(int productId) async {
  final confirmed = await showConfirmDialog(
    context: context,
    title: 'Confirm Delete',
    content: 'Are you sure you want to delete this product?',
    confirmText: 'Yes',
    cancelText: 'No',
    confirmColor: AppColors.pinkRedIcon,
  );

  if (confirmed != true) return;

  try {
    final result = await _apiService.delete<Map<String, dynamic>>(
      '/Product/$productId',
      context: context,
      fromJson: (data) => data,
    );

    if (result != null && result['success'] == true) {
      final message = result['message']?.toString().toLowerCase() ?? '';

      if (message.contains('permanently deleted')) {
        SnackbarHelper.success('Product has been permanently deleted.');
      } else if (message.contains('discontinued')) {
        SnackbarHelper.warning('Product contains items and was marked as discontinued.');
      } else {
        SnackbarHelper.success(result['message'] ?? 'Product deleted.');
      }

      await _loadProducts();
    } else {
      SnackbarHelper.error(result?['message'] ?? 'Failed to delete product.');
    }
  } catch (_) {
    SnackbarHelper.error('Failed to delete product.');
  }
}


  Future<void> _handleFormSubmit() async {
    _cancelForm();
    await _loadProducts();
  }

  @override
Widget build(BuildContext context) {
  if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: AppColors.textFieldBorder, width: 2.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(LucideIcons.packageCheck, size: 24, color: AppColors.buttonDark),
                const SizedBox(width: 8.0),
                Text('Products', style: AppTextStyles.titleStyle),
              ],
            ),
            if (!_showForm)
              ActionIconButton(
                label: 'Add Product',
                icon: LucideIcons.plus,
                backgroundColor: AppColors.buttonDark,
                onPressed: _startAddProduct,
                height: 45.0,
                width: 140.0,
              ),
          ],
        ),
        const SizedBox(height: 16.0),

        /// Form
        if (_showForm) ...[
          AddEditProductForm(
            isEdit: _isEditMode,
            initialProduct: _editingProduct,
            onSubmit: _handleFormSubmit,
            onCancel: _cancelForm,
          ),
          const SizedBox(height: 16.0),
        ],

        /// No data
        if (_products.isEmpty && !_showForm)
          const NoDataPlaceholder(
            title: 'No product in Inventory',
            message: 'Start by adding some new product.',
            icon: LucideIcons.box,
          ),

        /// Products list
        ..._products.map(
          (pro) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _ProductCard(
              productName: pro.name,
              category: pro.category.name,
              description: pro.description,
              cost: pro.unitPrice,
              price: pro.sellingPrice,
              createdBy: pro.userName ?? 'Unknown',
              onEdit: () => _startEditProduct(pro),
              onDelete: () => _deleteProduct(pro.id),
              status: pro.status!,
            ),
          ),
        ),
      ],
    ),
  );
}
}

class _ProductCard extends StatelessWidget {
  final String productName;
  final String category;
  final String description;
  final double cost;
  final double price;
  final String createdBy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ProductStatus status;

  const _ProductCard({
    required this.productName,
    required this.category,
    required this.description,
    required this.cost,
    required this.price,
    required this.createdBy,
    required this.onEdit,
    required this.onDelete, 
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDiscontinued = status == ProductStatus.discontinued;
   
    return Stack(
      children: [
          Opacity(
          opacity: isDiscontinued ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: isDiscontinued,
            child: Card(
              elevation: 0,
              color: isDiscontinued ? Colors.grey.shade200 : AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(width: 1.0, color: isDiscontinued ? Colors.grey.shade400 : AppColors.textFieldBorder,),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            productName, 
                            style: AppTextStyles.titleStyle,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 35.0,
                              width: 35.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(color: AppColors.textFieldBorder),
                              ),
                              child: IconButton(
                                icon: const Icon(LucideIcons.edit, color: AppColors.buttonDark, size: 20),
                                onPressed: onEdit,
                                tooltip: 'Edit',
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Container(
                              height: 35.0,
                              width: 35.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(color: AppColors.textFieldBorder),
                              ),
                              child: IconButton(
                                icon: const Icon(LucideIcons.trash2, color: AppColors.buttonDark, size: 20),
                                onPressed: onDelete,
                                tooltip: 'Delete',
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category, style: AppTextStyles.labelStyle.copyWith(color: AppColors.primaryBlue)),
                        
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(description, style: AppTextStyles.labelStyle),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Buy: \$${cost.toStringAsFixed(2)}', style: AppTextStyles.subtitle.copyWith(color: AppColors.pinkRedIcon)),
                        Text('Sold: \$${price.toStringAsFixed(2)}', style: AppTextStyles.subtitle.copyWith(color: AppColors.greenIcon)),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text('Created by $createdBy', style: AppTextStyles.textFieldLabel.copyWith(color: AppColors.textLight)),
                  ],
                ),
              ),
            ),
            
          ),
        ),
        if (isDiscontinued)
            Positioned(
              top: 12,
              right: 12,
              child: Chip(
                label: const Text("Discontinued"),
                backgroundColor: Colors.red.shade100,
                labelStyle: const TextStyle(color: Colors.red),
              ),
            ),
      ]
    );
  }
}


