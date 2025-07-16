import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/theme.dart';

class ProductList extends StatelessWidget {
  final String productName;
  final String category;
  final int stock;
  final VoidCallback? onViewDetails;

  const ProductList({
    super.key,
    required this.productName,
    required this.category,
    required this.stock, 
    this.onViewDetails,
  });

  Color _getStockColor(int stock) {
    if (stock <= 1) {
      return Colors.red.shade700;
    } else if (stock <= 5) {
      return Colors.orange.shade700;
    }
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(LucideIcons.boxes, size: 24, color: Colors.black),
                SizedBox(width: 10),
                Text(
                  'Inventory (2 products, 6 units)',
                  style: AppTextStyles.cardHeader
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStockColor(stock),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$stock in stock',
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        if (onViewDetails != null) {
                          onViewDetails!();
                        }
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        minimumSize: WidgetStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return AppColors.primaryBlue;
                            }
                            return AppColors.textDark;
                          }
                        ),
                        textStyle: WidgetStateProperty.all(
                        const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline, 
                        ),
                    ),
                  ),
                      child: const Text(
                        'View Details',
                      ),
                    )
                  ]
                )
              ]
            )
          )
        )
      ]
        
        
        );
        
                    
                
              
    
            
          
        
      
    
  }
}
