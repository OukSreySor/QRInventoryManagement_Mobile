import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class ProductItemCard extends StatelessWidget {
  final String itemName;
  final String qrCode;
  final String addedDate;
  final String byUser;
  final String mfgDate;
  final String expDate;
  final double price;
  final double cost;

  const ProductItemCard({
    super.key,
    required this.itemName,
    required this.qrCode,
    required this.addedDate,
    required this.byUser,
    required this.mfgDate,
    required this.expDate,
    required this.price,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.inventory_sharp, size: 24, color: Colors.black87),
                  const SizedBox(width: 10),
                  Text(
                    'Product Items Details - $itemName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              )   
          ),
          const SizedBox(height: 6.0,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Cost: \$${cost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 16, color: Colors.black54),
                      const SizedBox(width: 5),
                      Text(
                        qrCode,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                      const SizedBox(width: 5),
                      Text(
                        'Added: $addedDate',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.person_outline, size: 16, color: Colors.black54),
                      const SizedBox(width: 5),
                      Text(
                        'By: $byUser',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Mfg: $mfgDate',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Exp: $expDate',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5), 
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_2, size: 30, color: Colors.black54),
                          SizedBox(height: 5),
                          Text(
                            'QR Code',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
        ]
    );
  }
}