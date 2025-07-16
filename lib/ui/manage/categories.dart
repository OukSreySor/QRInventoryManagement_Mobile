import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/theme.dart';
import '../../widgets/icon_button.dart';
import '../manage/widgets/add_category_form.dart';

class Categories extends StatelessWidget {
  final VoidCallback? onAddPressed;
  final bool showAddForm;
  final VoidCallback? onCancelAddForm;

  const Categories({
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.folder, size: 28, color: AppColors.buttonDark),
                  const SizedBox(width: 8.0),
                  Text('Categories (2)', style: AppTextStyles.titleStyle),
                ],
              ),
              /// Show Add button only if form is hidden
              if (!showAddForm)
                ActionIconButton(
                  label: 'Add Category',
                  icon: LucideIcons.plus,
                  backgroundColor: AppColors.buttonDark,
                  onPressed: onAddPressed ?? (){},
                  height: 45.0,
                  width: 150.0,
                ),
            ],
          ),
          const SizedBox(height: 16.0),

          if (showAddForm) ...[
            AddCategoryForm(onCancel: onCancelAddForm?? (){}),
            const SizedBox(height: 16),
          ],
          _CategoryCard(
            categoryName: 'Electronics',
            description: 'Electronic devices and accessories',
            creationDate: '7/15/2025',
            createdBy: 'Admin User',
            onEdit: () {},
            onDelete: () {},
          ),
          const SizedBox(height: 16),
          _CategoryCard(
            categoryName: 'Clothing',
            description: 'Apparel and fashion items',
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

class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final String description;
  final String creationDate;
  final String createdBy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.categoryName,
    required this.description,
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
                Text(categoryName, style: AppTextStyles.titleStyle),
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
            const SizedBox(height: 12.0),
            Text(description, style: AppTextStyles.labelStyle),
            const SizedBox(height: 4.0),
            Text('Created by $createdBy on $creationDate', style: AppTextStyles.textFieldLabel),
          ],
        ),
      ),
    );
  }
}
