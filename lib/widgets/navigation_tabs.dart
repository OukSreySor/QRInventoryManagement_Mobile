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
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceAround, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.tabs.length, (index) {
          final tab = widget.tabs[index];
          return Flexible(child: _buildTabItem(index, tab));
        }),
      ),
    );
  }

  Widget _buildTabItem(int index, TabItem tab) {
    final isSelected = _selectedIndex == index;

     final TextStyle baseStyle = isSelected ? AppTextStyles.tabSelected : AppTextStyles.tabUnselected;
     final TextStyle finalLabelStyle = baseStyle.merge(tab.labelStyle);


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
                tab.icon,
                size: 14.0,
                color: isSelected ? AppColors.textBlack : AppColors.textDark,
              ),
              const SizedBox(width: 4.0),
              Text(
                tab.label,
                style: finalLabelStyle,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabItem {
  final IconData? icon;
  final String label;
  final TextStyle? labelStyle;

  TabItem({this.icon, required this.label, this.labelStyle, });
}
