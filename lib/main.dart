import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_inventory_management/bindings/initial_binding.dart';
import 'package:qr_inventory_management/storage/token_storage.dart';
import 'package:qr_inventory_management/ui/auth/auth_screen.dart';
import 'package:qr_inventory_management/ui/dashboard/dashboard.dart';
import 'package:qr_inventory_management/ui/welcome_screen.dart';
import 'theme/theme.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final String? token = TokenStorage.getToken();

  String initialRoute = '/welcome'; 
  if (token != null && token.isNotEmpty) {
    initialRoute = '/dashboard'; 
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute, 
      getPages: [
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(
          name: '/auth', 
          page: () {
            final int tabIndex = Get.arguments ?? 0;
            return AuthScreen(initialTabIndex: tabIndex);
          },
        ),
        GetPage(name: '/dashboard', page: () => DashboardScreen())
      ],   
    );
  }
}
