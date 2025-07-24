import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/report.dart';
import '../../../theme/theme.dart';

class LowStockAlert extends StatelessWidget {
  final List<LowStockProduct> lowStockProducts;
  const LowStockAlert({super.key, required this.lowStockProducts});

  @override
  Widget build(BuildContext context) {
    if (lowStockProducts.isEmpty) {
      return const Text('No low stock alerts !');
    }
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,  
        borderRadius: BorderRadius.circular(12.0),  
        border: Border.all(color: AppColors.borderContainer, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,   
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.alertTriangle,  
                size: 24.0,
                color: AppColors.orangeIcon,
              ),
              const SizedBox(width: 8.0),  
              Text(
                'Low Stock Alerts',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 16, color: AppColors.textBlack),  
              ),
            ],
          ),
          const SizedBox(height: 12.0), 
          Column(
            children: List.generate(lowStockProducts.length, (index) {
                  final product = lowStockProducts.elementAt(index);
                  final int displayIndex = index + 1;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        const SizedBox(width: 24.0), 
                        Text(
                          '$displayIndex',
                          style: AppTextStyles.valueStyle.copyWith(
                            color:  AppColors.textBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 4.0), 
                        Text(
                          '-',
                          style: AppTextStyles.valueStyle.copyWith(
                            color: Colors.grey.shade700, 
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 8.0), 
                        Expanded( 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Text(
                                product.productName,
                                style: AppTextStyles.titleStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Units left: ',
                                  style: AppTextStyles.valueStyle.copyWith(color: AppColors.textDark, fontSize: 11.0),
                                  children: [
                                    TextSpan(
                                      text: '${product.quantityLeft}',
                                      style: AppTextStyles.valueStyle.copyWith(
                                        color: AppColors.pinkRedIcon, 
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          )
            ],
          ),
        
      );
    
  }
}