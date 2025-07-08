
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/theme/theme.dart';
import '../../DTO/login_request_dto.dart';
import '../../DTO/register_request_dto.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/auth_tab_selector.dart';
import 'widgets/company_tab_selector.dart';
import '../../widgets/custom_text_feild.dart';
import '../dashboard/widgets/dashboard_header.dart';
import '../../widgets/primary_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController authController = Get.put(AuthController());

  int _authTabIndex = 0; 
  int _signUpCompanyTabIndex = 0; 

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();


  void _handleAuthTabChange(int index) {
    setState(() {
      _authTabIndex = index;
      _emailController.clear();
      _passwordController.clear();
      _fullNameController.clear();
      _inviteCodeController.clear();
      _companyNameController.clear();
      _signUpCompanyTabIndex = 0; 
    });
  }
  void _handleSignUpCompanyTabChange(int index) {
    setState(() {
      _signUpCompanyTabIndex = index;
    });
  
  }

  void _handleSignIn() {
    final loginRequest = LoginRequestDTO(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  Get.find<AuthController>().login(loginRequest);
  }

  void _handleSignUp() {
    if (_signUpCompanyTabIndex == 0) {
      final registerRequest = RegisterRequestDTO(
        username: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        inviteCode: _inviteCodeController.text.trim(),
      );

      Get.find<AuthController>().register(registerRequest);
    } 
    else {
      Get.snackbar(
        'Coming Soon',
        'Create Company feature is coming soon!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _inviteCodeController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground, 
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const DashboardHeader(subtitle: 'Smart Inventory Management'),
            const SizedBox(height: 36.0),
            AuthTabSelector(onTabChanged: _handleAuthTabChange),
            const SizedBox(height: 28.0), 
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground, 
                borderRadius: BorderRadius.circular(16.0), 
                border: Border.all(color: AppColors.borderContainer, width: 1)
              ),
              child: _authTabIndex == 0 ? _buildSignInForm() : _buildSignUpForm(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSignInForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.logIn, 
              size: 24.0,
              color: AppColors.textBlack,
            ),
            const SizedBox(width: 10.0),
            Text(
              'Sign In',
              style: AppTextStyles.authSectionTitle, 
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          'Enter your credentials to access your inventory',
          style: AppTextStyles.authSectionDescription, 
        ),
        const SizedBox(height: 24.0),
        CustomTextField(
          label: 'Email',
          hintText: 'admin@demo.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20.0),
        CustomTextField(
          label: 'Password',
          hintText: 'password',
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 28.0),
        PrimaryButton(
          text: 'Sign In',
          onPressed: _handleSignIn, 
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.userPlus, 
              size: 24.0,
              color: AppColors.textBlack,
            ),
            const SizedBox(width: 10.0),
            Text(
              'Sign Up',
              style: AppTextStyles.authSectionTitle,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          'Create your account or join an existing company',
          style: AppTextStyles.authSectionDescription,
        ),
        const SizedBox(height: 24.0),
        CompanyTabSelector(onTabChanged: _handleSignUpCompanyTabChange),
        const SizedBox(height: 20.0),
        if (_signUpCompanyTabIndex == 0) 
          Column(
            children: [
              CustomTextField(
                label: 'Full Name',
                hintText: 'John Doe',
                controller: _fullNameController,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Email',
                hintText: 'john@company.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Password',
                hintText: '••••••••',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Invite Code',
                hintText: 'DEMO123',
                controller: _inviteCodeController,
              ),
            ],
          )
        else 
          Column(
            children: [
              CustomTextField(
                label: 'Full Name',
                hintText: 'John Doe',
                controller: _fullNameController,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Email',
                hintText: 'john@company.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Password',
                hintText: '••••••••',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Company Name',
                hintText: 'My Awesome Company',
                controller: _companyNameController,
              ),
            ],
          ),
        const SizedBox(height: 28.0),
        PrimaryButton(
          text: _signUpCompanyTabIndex == 0 ? 'Join Company' : 'Create Company',
          onPressed: _handleSignUp, 
        ),
      ],
    );
  }
}