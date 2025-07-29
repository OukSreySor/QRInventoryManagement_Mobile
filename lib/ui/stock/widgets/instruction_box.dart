import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class InstructionBox extends StatelessWidget {
  const InstructionBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD2DEF9),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderContainer, width: 1.0)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryBlue),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'How to use Stock Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '1. Tap the “Scan QR Code” button or enter a code manually\n'
                  '2. Product info will be shown in a preview sheet\n'
                  '3. Tap “Confirm Stock Out” to complete the process',
                  style: TextStyle(fontSize: 14.0, color: Color(0xFF133782)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
