import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../theme/theme.dart';
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
  final ProductService _productService = ProductService();
  
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
       _products = await _productService.getAllProducts();
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _productService.deleteProduct(productId, context);
      SnackbarHelper.success('Product deleted');
      await _loadProducts();
    } catch (_) {}
  }

  Future<void> _handleFormSubmit() async {
    _cancelForm();
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_products.isEmpty) {
      return const NoDataPlaceholder(
        title: 'No product in Inventory',
        message: 'Start by adding some product using the “Manage” tab',
        icon: LucideIcons.box, 
      );
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.textFieldBorder, width: 1.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.packageCheck, size: 28, color: AppColors.buttonDark),
                  const SizedBox(width: 8.0),
                  Text('Products', style: AppTextStyles.titleStyle),
                ],
              ),
              /// Show Add button only if form hidden
              if (!_showForm)
                ActionIconButton(
                  label: 'Add Product',
                  icon: LucideIcons.plus,
                  backgroundColor: AppColors.buttonDark,
                  onPressed: _startAddProduct,
                  height: 45.0,
                  width: 150.0,
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (_showForm) ...[
                AddEditProductForm(
                  isEdit: _isEditMode,
                  initialProduct: _editingProduct,
                  onSubmit: _handleFormSubmit,
                  onCancel: _cancelForm,
                ),
                const SizedBox(height: 20.0),
          ],
          SizedBox(
            height: 400.0,
            width: double.infinity,
              child: ListView.separated(
                itemCount: _products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _ProductCard(
                    productName: product.name,
                    category: product.category.name,
                    description: product.description,
                    cost: product.unitPrice,
                    price: product.sellingPrice,
                    createdBy: 'Admin User', 
                    onEdit: () => _startEditProduct(product),
                    onDelete: () => _deleteProduct(product.id),
                  );
                },
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

  const _ProductCard({
    required this.productName,
    required this.category,
    required this.description,
    required this.cost,
    required this.price,
    required this.createdBy,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(width: 1.0, color: AppColors.textFieldBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(productName, style: AppTextStyles.titleStyle),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
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
                    const SizedBox(width: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
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
            Text(category, style: AppTextStyles.labelStyle.copyWith(color: AppColors.primaryBlue)),
            const SizedBox(height: 4.0),
            Text(description, style: AppTextStyles.labelStyle),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text('Buy: \$${cost.toStringAsFixed(2)}', style: AppTextStyles.subtitle.copyWith(color: AppColors.pinkRedIcon)),
                const SizedBox(width: 16.0),
                Text('Sold: \$${price.toStringAsFixed(2)}', style: AppTextStyles.subtitle.copyWith(color: AppColors.greenIcon)),
              ],
            ),
            const SizedBox(height: 12.0),
            Text('Created by $createdBy', style: AppTextStyles.textFieldLabel),
            const SizedBox(height: 12.0),
            
          ],
        ),
      ),
    );
  }
}
