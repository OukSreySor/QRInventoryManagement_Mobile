import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/theme/theme.dart';
import 'package:qr_inventory_management/utils/validator.dart';
import '../../DTO/login_request_dto.dart';
import '../../DTO/register_request_dto.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/snackbar_helper.dart';
import 'widgets/auth_tab_selector.dart';
import 'widgets/company_tab_selector.dart';
import '../../widgets/custom_text_feild.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/primary_button.dart';

class AuthScreen extends StatefulWidget {
  final int initialTabIndex;
  const AuthScreen({super.key, this.initialTabIndex = 0});  // Sign In 

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController authController = Get.put(AuthController());

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  int _authTabIndex = 0;
  int _signUpCompanyTabIndex = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authTabIndex = widget.initialTabIndex;
  }


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

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Missing Fields', 'Email and password cannot be empty');
      return;
    }

    final loginRequest = LoginRequestDTO(email: email, password: password);

    try {
      final success = await authController.login(loginRequest);
      if (success) {
        SnackbarHelper.success('Welcome aboard! Redirecting to dashboard...');

        await Future.delayed(const Duration(seconds: 3));
        Get.offAllNamed('/dashboard');
      } else {
        SnackbarHelper.error('Incorrect email or password!');
      }
    } catch (e) {
      SnackbarHelper.error('Login Failed');
    }
  }

  Future<void> _handleSignUp() async {
    if (_signUpCompanyTabIndex == 0) {
      final username = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final inviteCode = _inviteCodeController.text.trim();

      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          inviteCode.isEmpty) {

        SnackbarHelper.error('All fields are required for joining company.');

        return;
      }

      final registerRequest = RegisterRequestDTO(
        username: username,
        email: email,
        password: password,
        inviteCode: inviteCode,
      );

      try {
        final success = await authController.register(registerRequest);
        if (success) {
          SnackbarHelper.success('Your account has been created.\nPlease log in from the login screen.');

          _emailController.clear();
          _passwordController.clear();
          _fullNameController.clear();
          _inviteCodeController.clear();

          setState(() {
            _authTabIndex = 0;
          });
        }
      } catch (e) {
        SnackbarHelper.error('Register Failed');
        
      }
    } else {
      SnackbarHelper.warning('Create Company feature is coming soon!');
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
            AuthTabSelector(
              initialIndex: _authTabIndex, 
              onTabChanged: _handleAuthTabChange
            ),
            const SizedBox(height: 28.0),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppColors.borderContainer, width: 1),
              ),
              child:
                  _authTabIndex == 0 ? _buildSignInForm() : _buildSignUpForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.logIn, 
                size: 24.0, 
                color: AppColors.textBlack
              ),
              const SizedBox(width: 10.0),
              Text(
                'Sign In',
                 style: AppTextStyles.authSectionTitle
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
            validator: Validator.email,
          ),
          const SizedBox(height: 20.0),
          CustomTextField(
            label: 'Password',
            hintText: 'password',
            obscureText: true,
            controller: _passwordController,
            validator: Validator.password, 
          ),
          const SizedBox(height: 28.0),
          PrimaryButton(
            text: 'Sign In',
            onPressed: () {
              if (_signInFormKey.currentState!.validate()) {
                _handleSignIn();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
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
              Text('Sign Up', style: AppTextStyles.authSectionTitle),
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
                  validator: (value) => Validator.required(value, fieldName: 'Full Name'),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  label: 'Email',
                  hintText: 'john@company.com',
                  controller: _emailController,
                  validator: Validator.email,
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  label: 'Password',
                  hintText: '••••••••',
                  obscureText: true,
                  controller: _passwordController,
                  validator: Validator.password,
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  label: 'Invite Code',
                  hintText: '54cd9aed',
                  obscureText: true,
                  controller: _inviteCodeController,
                  validator: (value) => Validator.required(value, fieldName: 'Invite Code'),
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
            text:
                _signUpCompanyTabIndex == 0 ? 'Join Company' : 'New Company',
            onPressed: () {
              if (_signUpFormKey.currentState!.validate()) {
                _handleSignUp();
              }
            }
          ),
        ],
      ),
    );
  }
}
