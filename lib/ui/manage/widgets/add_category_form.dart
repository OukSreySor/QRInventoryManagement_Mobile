import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/custom_text_feild.dart';
import '../../../widgets/primary_button.dart';

class AddCategoryForm extends StatelessWidget {
  final VoidCallback onCancel;

  const AddCategoryForm({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryNameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

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
            label: 'Category Name',
            hintText: 'Electronics, Clothing, etc.',
            controller: categoryNameController,
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            label: 'Description (Optional)',
            hintText: 'Brief description of this category...',
            controller: descriptionController,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Create Category',
                  onPressed: () {
                    // Handle create logic
                    onCancel();
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
                    onPressed: onCancel,
                    backgroundColor: AppColors.textWhite,
                    textColor: AppColors.textBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}