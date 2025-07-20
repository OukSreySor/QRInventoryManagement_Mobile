import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/custom_text_feild.dart';
import '../../../widgets/primary_button.dart';

class AddCategoryForm extends StatefulWidget {
  final VoidCallback onCancel;
  final bool isEdit;
  final String? initialName;
  final String? initialDescription;
  final void Function(String name, String description) onSubmit;

  const AddCategoryForm({
    super.key,
    required this.onCancel,
    required this.isEdit,
    this.initialName,
    this.initialDescription,
    required this.onSubmit,
  });

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {

  late TextEditingController categoryNameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    categoryNameController = TextEditingController(text: widget.initialName ?? '');
    descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }
  @override
  void dispose() {
    categoryNameController.dispose();
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
            label: 'Category Name',
            hintText: 'Electronics, Clothing, etc.',
            controller: categoryNameController,
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            label: 'Description',
            hintText: 'Brief description of this category...',
            controller: descriptionController,
            maxLines: 3
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: widget.isEdit ? 'Update Category' : 'Create Category',
                  onPressed: () {
                    print('Submitted values: name=${categoryNameController.text}, description=${descriptionController.text}');
                     widget.onSubmit(
                      categoryNameController.text.trim(),
                      descriptionController.text.trim(),
                    );
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
