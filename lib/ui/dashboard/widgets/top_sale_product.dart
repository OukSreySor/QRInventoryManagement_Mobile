import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/report.dart';
import '../../../theme/theme.dart';

class TopSaleProduct extends StatelessWidget {
  final List<TopProduct> hotProducts;

  const TopSaleProduct({super.key, required this.hotProducts});

  @override
  Widget build(BuildContext context) {
     if (hotProducts.isEmpty) {
      return const Text("No top selling products in last 30 days.");
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
                LucideIcons.star,  
                size: 24.0,
                color: const Color.fromARGB(255, 238, 191, 37),
              ),
              const SizedBox(width: 8.0),  
              Text(
                'Top 3 Best Selling (last 30 days)',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 16, color: AppColors.textBlack),  
              ),
            ],
          ),
          const SizedBox(height: 8.0), 
          ...hotProducts.map((product) => ListTile(
              title: Text(product.productName, style: AppTextStyles.titleStyle,),
              subtitle: Text(
                'Sold: ${product.unitsSold} | Revenue: \$${product.totalSales.toStringAsFixed(2)}', 
                style: AppTextStyles.valueStyle.copyWith(color: AppColors.textDark, fontSize: 12.0),
              ),
              leading: const Icon(LucideIcons.arrowBigUp, color: Colors.green),
            )),
        ],
      ),
    );
  }
}

