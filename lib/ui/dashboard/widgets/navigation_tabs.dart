import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';

class NavigationTabs extends StatefulWidget {
  const NavigationTabs({super.key});

  @override
  State<NavigationTabs> createState() => _NavigationTabsState();
}

class _NavigationTabsState extends State<NavigationTabs> {
  int _selectedIndex = 0;   

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBackground,   
        borderRadius: BorderRadius.circular(10.0),  
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: [
          _buildTabItem(0, LucideIcons.barChart3, 'Home'),
          _buildTabItem(1, LucideIcons.package, 'Stock'),   
          _buildTabItem(2, LucideIcons.qrCode, 'QR Batch'),   
          _buildTabItem(3, LucideIcons.settings, 'Manage'),   
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;  
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; 
        });
      },
      child: AnimatedContainer(   
        duration: const Duration(milliseconds: 200),  
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        alignment: Alignment.center,  
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tabSelectedBackground : Colors.transparent,   
          borderRadius: BorderRadius.circular(10.0),  
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,  
          children: [
            Icon(
              icon,
              size: 20.0,
              color: isSelected ? AppColors.primaryBlue : AppColors.textDark,   
            ),
            const SizedBox(width: 8.0),   
            Text(
              label,
              style: isSelected ? AppTextStyles.tabSelected : AppTextStyles.tabUnselected,  
            ),
          ],
        ),
      ),
    );
  }
}

