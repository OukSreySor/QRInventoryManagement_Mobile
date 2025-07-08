import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class AuthTabSelector extends StatefulWidget {
  final Function(int) onTabChanged; // Callback to notify parent (AuthScreen) of tab change
  const AuthTabSelector({super.key, required this.onTabChanged});

  @override
  State<AuthTabSelector> createState() => _AuthTabSelectorState();
}

class _AuthTabSelectorState extends State<AuthTabSelector> {
  int _selectedIndex = 0; // 0 for Sign In, 1 for Sign Up

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
    bool isSelected = _selectedIndex == index;
    return Expanded( 
      child: Material( 
        color: Colors.transparent, 
        child: InkWell( 
          onTap: () {
            setState(() {
              _selectedIndex = index; 
            });
            widget.onTabChanged(index); 
          },
          splashColor: Colors.transparent, 
          highlightColor: Colors.transparent, 
          borderRadius: BorderRadius.circular(10.0), 
          child: AnimatedContainer( // Provides smooth transition for color/shape
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            alignment: Alignment.center, 
            decoration: BoxDecoration(
              color: isSelected ? AppColors.tabSelectedBackground : AppColors.tabUnselectedBackground, 
              borderRadius: BorderRadius.circular(10.0), 
            ),
            child: Text(
              label,
              style: AppTextStyles.tabSelected.copyWith( 
                color: isSelected ? AppColors.primaryBlue : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
