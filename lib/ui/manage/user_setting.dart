import 'package:flutter/material.dart';
import 'package:qr_inventory_management/widgets/primary_button.dart';

import '../../theme/theme.dart';

class InviteCodesContainer extends StatelessWidget {
  const InviteCodesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.textFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: AppColors.textBlack),
              const SizedBox(width: 8.0),
              Text('Invite Codes', style: AppTextStyles.authSectionTitle),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            'Generated new registration codes or manage existing ones.',
            style: AppTextStyles.authSectionDescription,
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.textFieldBorder, thickness: 1.0),
          const SizedBox(height: 16),
          Text('New Invite Code', style: AppTextStyles.titleStyle),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textFieldBorder),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'DEMO123',
                    style: AppTextStyles.authSectionDescription),
                ),
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                width: 200.0,
                child: PrimaryButton(
                  text: 'Generate New Code', 
                  onPressed: () {}
                ),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(color: AppColors.textFieldBorder, thickness: 1.0),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Codes', style: AppTextStyles.titleStyle),
              Text('Created', style: AppTextStyles.titleStyle),
              Text('Status', style: AppTextStyles.titleStyle),
            ],
          ),
          const SizedBox(height: 8.0),
          const InviteCodeItem(code: 'DEMO123', created: '04/04/2025', status: 'Used'),
          const InviteCodeItem(code: 'DEMO123', created: '04/04/2025', status: 'Used'),
          const InviteCodeItem(code: 'DEMO123', created: '04/04/2025', status: 'Used'),
          const SizedBox(height: 16.0),
          const Divider(color: AppColors.textFieldBorder, thickness: 1.0),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Users', style: AppTextStyles.titleStyle),
              Text('Status', style: AppTextStyles.titleStyle),
              Text('Action', style: AppTextStyles.titleStyle),
            ],
          ),
          const SizedBox(height: 8.0),
          const UserItem(name: 'Ouk Sreysor', email: 'sreysor.ouk@gmail.com', status: 'Active'),
          const UserItem(name: 'Ouk Sreysor', email: 'sreysor.ouk@gmail.com', status: 'Active'),
          const UserItem(name: 'Ouk Sreysor', email: 'sreysor.ouk@gmail.com', status: 'Active'),
        ],
      ),
    );
  }
}

class InviteCodeItem extends StatelessWidget {
  final String code;
  final String created;
  final String status;

  const InviteCodeItem({
    super.key,
    required this.code,
    required this.created,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(code, style: AppTextStyles.valueStyle),
          Text(created, style: AppTextStyles.valueStyle),
          Text(status, style: AppTextStyles.valueStyle),
        ],
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final String name;
  final String email;
  final String status;

  const UserItem({
    super.key,
    required this.name,
    required this.email,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.valueStyle),
              Text(email, style: AppTextStyles.valueStyle),
            ],
          ),
          Text(status, style: AppTextStyles.valueStyle),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primaryBlue, size: 18.0),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete,  color: AppColors.pinkRedIcon, size: 18.0),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
