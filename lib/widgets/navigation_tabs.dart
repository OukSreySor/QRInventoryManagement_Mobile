import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NavigationTabs extends StatefulWidget {
  final List<TabItem> tabs;
  final void Function(int)? onTabSelected;
  final int initialIndex;

  const NavigationTabs({
    super.key,
    required this.tabs,
    this.onTabSelected,
    this.initialIndex = 0,
  });

  @override
  State<NavigationTabs> createState() => _NavigationTabsState();
}

class _NavigationTabsState extends State<NavigationTabs> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.tabs.length, (index) {
          final tab = widget.tabs[index];
          return Expanded(child: _buildTabItem(index, tab.icon, tab.label));
        }),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTabSelected?.call(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tabSelectedBackground : AppColors.tabBackground,
          borderRadius: BorderRadius.circular(4.0),
          border: isSelected ? Border.all(color: AppColors.borderContainer, width: 1.0) : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.0,
                color: isSelected ? AppColors.textBlack : AppColors.textDark,
              ),
              const SizedBox(width: 4.0),
              Text(
                label,
                style: isSelected ? AppTextStyles.tabSelected : AppTextStyles.tabUnselected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabItem {
  final IconData icon;
  final String label;

  TabItem({required this.icon, required this.label});
}
