import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class AuthTabSelector extends StatefulWidget {
  final Function(int) onTabChanged; // Callback to notify parent (AuthScreen) of tab change
  final int initialIndex;

  const AuthTabSelector({
    super.key,
    required this.onTabChanged,
    required this.initialIndex,
  });

  @override
  State<AuthTabSelector> createState() => _AuthTabSelectorState();
}

class _AuthTabSelectorState extends State<AuthTabSelector> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Sign In'),
          _buildTabButton(1, 'Sign Up'),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
          widget.onTabChanged(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.tabSelectedBackground
                    : AppColors.tabBackground,
            borderRadius: BorderRadius.circular(6.0),
            border:
                isSelected
                    ? Border.all(color: AppColors.borderContainer, width: 1.0)
                    : null,
          ),
          child: Text(
            label,
            style:
                isSelected
                    ? AppTextStyles.tabSelected.copyWith(
                      color: AppColors.textBlack,
                    )
                    : AppTextStyles.tabUnselected,
          ),
        ),
      ),
    );
  }
}
