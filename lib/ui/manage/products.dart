import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/theme.dart';
import '../../widgets/icon_button.dart';
import '../manage/widgets/add_product_form.dart';

class ProductsManagementScreen extends StatelessWidget {
  final VoidCallback? onAddPressed;
  final bool showAddForm;
  final VoidCallback? onCancelAddForm;

  const ProductsManagementScreen({
    super.key,
    this.onAddPressed,
    this.showAddForm = false,
    this.onCancelAddForm,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text('Products (2)', style: AppTextStyles.titleStyle),
                ],
              ),
              /// Show Add button only if form hidden
              if (!showAddForm)
                ActionIconButton(
                  label: 'Add Product',
                  icon: LucideIcons.plus,
                  backgroundColor: AppColors.buttonDark,
                  onPressed: onAddPressed ?? (){},
                  height: 45.0,
                  width: 150.0,
                ),
            ],
          ),
          const SizedBox(height: 20),

          if (showAddForm) ...[
            AddProductForm(onCancel: onCancelAddForm??(){}),
            const SizedBox(height: 20.0),
          ],
          _ProductCard(
            productName: 'iPhone 15',
            category: 'Electronics',
            description: 'Latest Apple smartphone',
            cost: 800.00,
            price: 999.00,
            creationDate: '7/15/2025',
            createdBy: 'Admin User',
            onEdit: () {},
            onDelete: () {},
          ),
          const SizedBox(height: 16.0),
          _ProductCard(
            productName: 'T-Shirt Blue L',
            category: 'Clothing',
            description: 'Cotton blue t-shirt, size large',
            cost: 15.00,
            price: 25.00,
            creationDate: '7/15/2025',
            createdBy: 'Admin User',
            onEdit: () {},
            onDelete: () {},
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
  final String creationDate;
  final String createdBy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.productName,
    required this.category,
    required this.description,
    required this.cost,
    required this.price,
    required this.creationDate,
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
                Text('\$ Cost: \$${cost.toStringAsFixed(2)}', style: AppTextStyles.subtitle),
                const SizedBox(width: 16.0),
                Text('\$ Price: \$${price.toStringAsFixed(2)}', style: AppTextStyles.subtitle),
              ],
            ),
            const SizedBox(height: 12.0),
            Text('Created by $createdBy on $creationDate', style: AppTextStyles.textFieldLabel),
            const SizedBox(height: 12.0),
            
          ],
        ),
      ),
    );
  }
}
