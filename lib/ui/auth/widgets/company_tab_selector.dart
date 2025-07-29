import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';

class CompanyTabSelector extends StatefulWidget {
  final Function(int) onTabChanged;
  const CompanyTabSelector({super.key, required this.onTabChanged});

  @override
  State<CompanyTabSelector> createState() => _CompanyTabSelectorState();
}

class _CompanyTabSelectorState extends State<CompanyTabSelector> {
  int _selectedIndex = 0; // 0 for Join Company, 1 for Create Company

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,   
        borderRadius: BorderRadius.circular(10.0),  
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Join Company', LucideIcons.building),   
          _buildTabButton(1, 'Create Company', LucideIcons.plusCircle),   
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    bool isSelected = _selectedIndex == index;
    return Expanded(  
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index; 
          });
          widget.onTabChanged(index);   
        },
        child: AnimatedContainer(   
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          alignment: Alignment.center, 
          decoration: BoxDecoration(
            color: isSelected ? AppColors.buttonDark : Colors.transparent, 
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Icon(
                icon,
                size: 16.0,
                color: isSelected ? AppColors.textWhite : AppColors.textDark, 
              ),
              const SizedBox(width: 4.0), 
              Text(
                label,
                style: isSelected ? AppTextStyles.tabSelected.copyWith(color: AppColors.textWhite) : AppTextStyles.tabUnselected, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

