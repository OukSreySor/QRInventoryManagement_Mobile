import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';
import '../../../widgets/custom_text_feild.dart';
import '../../../widgets/primary_button.dart';

class AddProductForm extends StatefulWidget {
  final VoidCallback onCancel;

  const AddProductForm({super.key, required this.onCancel});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController unitCostController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Select categories',
    'Category A',
    'Category B',
    'Category C',
  ];


  @override
  void dispose() {
    productNameController.dispose();
    unitCostController.dispose();
    sellingPriceController.dispose();
    descriptionController.dispose();
    super.dispose();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'Product Name',
            hintText: 'iPhone 15, T-Shirt Blue L, etc.',
            controller: productNameController,
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border.all(color: AppColors.textFieldBorder),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                  icon: Icon(
                    LucideIcons.chevronDown,
                    color: AppColors.textMedium,
                  ),
                  style: TextStyle(color: AppColors.textDark),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                items:
                    _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                ),
            ),
          ), 
            
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Unit Cost',
                  hintText: '0.00',
                  controller: unitCostController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomTextField(
                  label: 'Selling Price',
                  hintText: '0.00',
                  controller: sellingPriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            label: 'Description (Optional)',
            hintText: 'Product specs, materials, etc.',
            controller: descriptionController,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Create Product',
                  onPressed: () {
                    // Handle product creation
                    widget.onCancel();
                  },
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
      
        ]
      )
      );
    
  }
}
