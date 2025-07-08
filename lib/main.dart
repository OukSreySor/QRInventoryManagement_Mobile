import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_inventory_management/ui/auth/auth_screen.dart';
import 'package:qr_inventory_management/ui/dashboard/dashboard.dart';
import 'theme/theme.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      // initialRoute: '/auth',
      // getPages: [
      //   GetPage(name: '/auth', page: () => AuthScreen()),
      //   GetPage(name: '/dashboard', page: () => DashboardScreen(userRole: '',))
      // ],
      home: DashboardScreen(userRole: '',),
      
    );
  }
}
