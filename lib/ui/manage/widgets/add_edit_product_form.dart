import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/models/category_dropdown.dart';
import '../../../DTO/create_product_dto.dart';
import '../../../models/product.dart';
import '../../../services/dio_client.dart';
import '../../../services/product_service.dart';
import '../../../theme/theme.dart';
import '../../../utils/snackbar_helper.dart';
import '../../../widgets/custom_text_feild.dart';
import '../../../widgets/primary_button.dart';

class AddEditProductForm extends StatefulWidget {
  final VoidCallback onCancel;
  final bool isEdit;
  final Product? initialProduct;
  final VoidCallback onSubmit;

  const AddEditProductForm({super.key, required this.onCancel, required this.isEdit, this.initialProduct, required this.onSubmit});

  @override
  State<AddEditProductForm> createState() => _AddEditProductFormState();
}

class _AddEditProductFormState extends State<AddEditProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<CategoryDropdown> _categories = [];

  CategoryDropdown? _selectedCategory;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _fetchCategoryNames();

    if (widget.isEdit && widget.initialProduct != null) {
      final p = widget.initialProduct!;
      _productNameController.text = p.name;
      _unitPriceController.text = p.unitPrice.toString();
      _sellingPriceController.text = p.sellingPrice.toString();
      _descriptionController.text = p.description;
      
    }
  }

  Future<void> _fetchCategoryNames() async {
    try {
      final response = await DioClient.dio.get('/Category/names');

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final categories =
            data.map((item) => CategoryDropdown.fromJson(item)).toList();

        setState(() {
          _categories = categories;

          if (widget.isEdit && widget.initialProduct != null) {
            _selectedCategoryId = widget.initialProduct!.categoryId;
            _selectedCategory = _categories.firstWhere(
              (cat) => cat.id == _selectedCategoryId,
            );
          }
        });
        
      } else {
        print('Error: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      print('Failed to load category names: $e');
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _unitPriceController.dispose();
    _sellingPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
    print('Validation failed or category not selected');
    return;
  }
  

  final dto = CreateProductDTO(
    name: _productNameController.text,
    description: _descriptionController.text,
    unitPrice: double.parse(_unitPriceController.text),
    sellingPrice: double.parse(_sellingPriceController.text),
    categoryId: _selectedCategoryId!,
  );

  try {
    if (widget.isEdit && widget.initialProduct != null) {
        await _productService.updateProduct(widget.initialProduct!.id, dto, context);
        SnackbarHelper.success('Product updated successfully');

      } else {
        await _productService.createProduct(dto, context);
        SnackbarHelper.success('Product created successfully');
      }

      widget.onSubmit(); 
    } catch (e) {
      print('Updating product ID: ${widget.initialProduct?.id}');
      SnackbarHelper.error(widget.isEdit
          ? 'Failed to update product'
          : 'Failed to add product');
    } 
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.textFieldBorder),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Product Name',
              hintText: 'iPhone 15, T-Shirt Blue L, etc.',
              controller: _productNameController,
            ),
            const SizedBox(height: 16.0),
            Text('Category', style: AppTextStyles.textFieldLabel),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                border: Border.all(color: AppColors.textFieldBorder),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CategoryDropdown>(
                  isExpanded: true,
                  value: _selectedCategory,
                  icon: Icon(LucideIcons.chevronDown, color: AppColors.textBlack),
                  hint: Text(
                    "Select category",
                    style: TextStyle(fontSize: 16.0, color: AppColors.textLight),
                  ),
                  style: TextStyle(color: AppColors.textBlack),
                  onChanged: (CategoryDropdown? value) {
                    setState(() {
                      _selectedCategory = value;
                      _selectedCategoryId = value?.id;
                    });
                  },
                  items:
                      _categories
                          .map(
                            (c) => DropdownMenuItem<CategoryDropdown>(
                              value: c,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
        
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Unit Price',
                    hintText: '0.00',
                    controller: _unitPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextField(
                    label: 'Selling Price',
                    hintText: '0.00',
                    controller: _sellingPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              label: 'Description (Optional)',
              hintText: 'Product specs, materials, etc.',
              controller: _descriptionController,
              maxLines: 3,
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: widget.isEdit ? 'Update Product' : 'Create Product',
                    onPressed: () => _submitForm(),
                    
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppColors.textFieldBorder),
                    ),
                    child: PrimaryButton(
                      text: 'Cancel',
                      onPressed: widget.onCancel,
                      backgroundColor: Colors.white,
                      textColor: AppColors.textBlack,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
