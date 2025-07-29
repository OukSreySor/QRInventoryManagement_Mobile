import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../theme/theme.dart';
import '../../utils/confirm_dialog.dart';
import '../../utils/no_data_place_holder.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/icon_button.dart';
import 'widgets/add_edit_category_form.dart';


class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryService _categoryService = CategoryService();

  List<Category> _categories = [];
  bool _isLoading = true;
  bool _showAddForm = false;
  bool _isEditMode = false;
  Category? _editingCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      _categories = await _categoryService.fetchCategories();
    } catch (_) {
      SnackbarHelper.error('Failed to fetch categories');
    } finally {
      setState(() => _isLoading = false);
    }
    
  }

  void _deleteCategory(int id) async {
    final confirm = await showConfirmDialog(
      context: context,
      title: 'Confirm Delete', 
      content: 'Are you sure you want to delete this category?',
      confirmText: 'Yes',
      cancelText: 'No',
      confirmColor: AppColors.pinkRedIcon,
    );
    if (confirm != true) return;

    try {
      await _categoryService.deleteCategory(id);
      SnackbarHelper.success('Category deleted');
      await _fetchCategories();
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Delete failed';

      if (message.contains('Cannot delete a category that has products')) {
        SnackbarHelper.error('Cannot delete: This category contains products.');
      } else {
        SnackbarHelper.error(message);
      }
    } catch (e, stack) {
      print('Delete error: $e');
      print(stack);
      SnackbarHelper.error('Delete failed');
    }
  }

  void _startEdit(Category cat) {
    print('Editing category: ${cat.name}');
    setState(() {
      _isEditMode = true;
      _editingCategory = cat;
      _showAddForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_categories.isEmpty) {
      return const NoDataPlaceholder(
        title: 'No category in Inventory',
        message: 'Start by adding some category using the “Manage” tab',
        icon: LucideIcons.box, 
      );
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.folder, size: 24, color: AppColors.buttonDark),
                  const SizedBox(width: 8.0),
                  Text('Categories', style: AppTextStyles.titleStyle),
                ],
              ),
              if (!_showAddForm)
                ActionIconButton(
                  label: 'Add Category',
                  icon: LucideIcons.plus,
                  backgroundColor: AppColors.buttonDark,
                  onPressed: () => setState(() => _showAddForm = true),
                  height: 45.0,
                  width: 140.0,
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_showAddForm)
            AddCategoryForm(
              isEdit: _isEditMode,
              initialName: _editingCategory?.name,
              initialDescription: _editingCategory?.description,
              onSubmit: (name, desc) async {
                try {
                  if (_isEditMode && _editingCategory != null) {
                    await _categoryService.updateCategory(_editingCategory!.id, name, desc);
                    SnackbarHelper.success('Category updated !');
                  } else {
                    await _categoryService.createCategory(name, desc);
                    SnackbarHelper.success('Category created !');
                  }
                  setState(() {
                    _showAddForm = false;
                    _isEditMode = false;
                    _editingCategory = null;
                  });
                  await _fetchCategories();
                } catch (e, stack) {
                  print('Edit error: $e');
                  print(stack);
                  SnackbarHelper.error('Operation failed');
                }
              },
              onCancel: () => setState(() {
                _showAddForm = false;
                _editingCategory = null;
                _isEditMode = false;
              }),
            ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_categories.isEmpty)
            const Text('No categories found.')
          else
            ..._categories.map((cat) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _CategoryCard(
                    categoryName: cat.name,
                    description: cat.description ,
                    creationDate: cat.createdAt,
                    createdBy: 'Admin',
                    onEdit: () => _startEdit(cat),
                    onDelete: () => _deleteCategory(cat.id),
                  ),
                )),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final String description;
  final DateTime? creationDate;
  final String createdBy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.categoryName,
    required this.description,
    this.creationDate,
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
        side: BorderSide(width: 2.0, color: AppColors.textFieldBorder),
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
                    const SizedBox(width: 8.0),
                    Container(
                      height: 35.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppColors.textFieldBorder),
                      ),
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(LucideIcons.trash2, color: AppColors.buttonDark, size: 20),
                        tooltip: 'Delete',
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(description, style: AppTextStyles.labelStyle),
            const SizedBox(height: 4.0),
            Text('Created by $createdBy', style: AppTextStyles.textFieldLabel.copyWith(color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}
