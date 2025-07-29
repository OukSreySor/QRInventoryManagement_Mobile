
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_inventory_management/widgets/primary_button.dart'; 
import '../theme/theme.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height to make illustration height somewhat responsive
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.lightBackground, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 2), 
              Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/stockflow_logo.png', 
                        width: 70.0, 
                        height: 70.0,
                      ),
                      const SizedBox(width: 16.0), 
                      Text(
                        'StockFlow',
                        style: AppTextStyles.authSectionTitle.copyWith(fontSize: 36),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), 
                  Text(
                    'Your Inventory, Simplified.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authSectionDescription.copyWith(fontSize: 14.0, color: AppColors.textBlack),
                  ),
                ],
                
              ),
              
              const Spacer(flex: 2), 
              Image.asset(
                'assets/images/stock_shelves.png', 
                height: screenHeight * 0.28, 
                fit: BoxFit.contain,
              ),
              const Spacer(flex: 2), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: SizedBox(
                      width: 150.0,
                      height: 40.0,
                      child: PrimaryButton(
                        text: 'Get Started',
                        onPressed: () {
                          Get.toNamed('/auth', arguments: 1);
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
                    ),
                    child: SizedBox(
                      width: 150.0,
                      height: 40.0,
                      child: PrimaryButton(
                        text: 'Log In',
                        onPressed: () {
                          Get.toNamed('/auth', arguments: 0);
                        },
                        backgroundColor: AppColors.textWhite,
                        textColor: AppColors.textBlack,
                      ),
                    ),
                  ),
                  
                ],
              ),

              const Spacer(flex: 2), 
            ],
          ),
        ),
      ),
    );
  }
}