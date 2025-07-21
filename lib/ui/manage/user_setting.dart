import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/utils/confirm_dialog.dart';
import 'package:qr_inventory_management/widgets/primary_button.dart';

import '../../models/invite_code.dart';
import '../../models/user.dart';
import '../../services/admin_service.dart';
import '../../theme/theme.dart';
import 'widgets/user_stats_card.dart';

class InviteCodesContainer extends StatefulWidget {
  const InviteCodesContainer({super.key});

  @override
  State<InviteCodesContainer> createState() => _InviteCodesContainerState();
}

class _InviteCodesContainerState extends State<InviteCodesContainer> {
  List<User> users = [];
  List<InviteCode> inviteCodes = [];
  String? newInviteCode;
  bool isLoading = true;

  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedUsers = await _adminService.getAllUsers();
      final fetchedCodes = await _adminService.getAllInviteCodes();
      setState(() {
        users = fetchedUsers;
        inviteCodes = fetchedCodes;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleGenerateCode() async {
    try {
      final code = await _adminService.generateInviteCode();
      setState(() {
        newInviteCode = code;
      });
    } catch (e) {
      print("Failed to generate code: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final List<InfoCardData> statsCards = [
      InfoCardData(
        icon: Icons.group,
        title: 'Total Users',
        value: users.length.toString(),
        iconColor: AppColors.primaryBlue,
      ),
      InfoCardData(
        icon: Icons.admin_panel_settings,
        title: 'Admins',
        value: users.where((u) => u.role == 'Admin').length.toString(),
        iconColor: AppColors.orangeIcon,
      ),
      InfoCardData(
        icon: Icons.check_circle,
        title: 'Active User',
        value:
            users
                .where((u) => !u.isDeleted && u.role != 'Admin')
                .length
                .toString(),
        iconColor: AppColors.greenIcon,
      ),
    ];
    return Column(
      children: [
        UserStatsCard(cards: statsCards),
        const SizedBox(height: 16.0),
        Container(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textFieldBorder),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            newInviteCode ?? 'Click to generate',
                            style: AppTextStyles.authSectionDescription,
                          ),
                          IconButton(
                            icon: Icon(
                              LucideIcons.copy,
                              size: 16.0,
                              color: AppColors.primaryBlue,
                            ),
                            onPressed: () {
                              if (newInviteCode != null &&
                                  newInviteCode!.isNotEmpty) {
                                Clipboard.setData(
                                  ClipboardData(text: newInviteCode!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Invite code copied to clipboard!',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No invite code to copy.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: 200.0,
                    child: PrimaryButton(
                      text: 'Generate New Code',
                      onPressed: handleGenerateCode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: const Divider(
                        color: AppColors.textFieldBorder,
                        thickness: 2.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Invite Codes History',
                        style: AppTextStyles.titleStyle,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.textFieldBorder,
                        thickness: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Codes', style: AppTextStyles.titleStyle),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Created', style: AppTextStyles.titleStyle),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Status', style: AppTextStyles.titleStyle),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 200.0, 
                child: ListView.builder(
                  shrinkWrap: true, 
                  physics: const ClampingScrollPhysics(), 
                  itemCount: inviteCodes.length,
                  itemBuilder: (context, index) {
                    final code = inviteCodes[index];
                    return InviteCodeItem(
                      code: code.code,
                      created: code.createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A',
                      status: code.isUsed ? 'Used' : 'Unused',
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: const Divider(
                        color: AppColors.textFieldBorder,
                        thickness: 2.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Users List',
                        style: AppTextStyles.titleStyle,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.textFieldBorder,
                        thickness: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Users', style: AppTextStyles.titleStyle),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Status', style: AppTextStyles.titleStyle),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Action', style: AppTextStyles.titleStyle),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 200.0, 
                child: ListView.builder(
                  shrinkWrap: true, 
                  physics: const ClampingScrollPhysics(), // Only scrolls when content exceeds height
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserItem(
                      name: user.username,
                      email: user.email,
                      status: user.isDeleted ? 'Deleted' : 'Active',
                      role: user.role,
                      userId: user.id,
                      onRoleChanged: (newRole) async {
                        await _adminService.updateUserRole(user.id, newRole);
                        _loadData();
                      },
                      onDelete: () async {
                        await _adminService.deleteUser(user.id);
                        _loadData();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
    Color statusColor = AppColors.textBlack; 
    if (status == 'Used') {
      statusColor = AppColors.pinkRedIcon; 
    } else if (status == 'Unused') {
      statusColor = AppColors.greenIcon; 
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2, 
            child: Text(code, style: AppTextStyles.valueStyle)
          ),
          Expanded(
            flex: 2,
            child: Text(created, style: AppTextStyles.valueStyle),
          ),
          Expanded(
            flex: 1,
            child: Text(status, style: AppTextStyles.valueStyle.copyWith(color: statusColor)),
          ),
        ],
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  final String name;
  final String email;
  final String status;
  final String role;
  final String userId;
  final void Function(String newRole)? onRoleChanged;
  final VoidCallback? onDelete;

  const UserItem({
    super.key,
    required this.name,
    required this.email,
    required this.status,
    required this.role,
    required this.userId,
    this.onRoleChanged,
    this.onDelete,
  });

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  
  void _showUpdateRoleDialog(BuildContext context) {
  String selectedRole = widget.role;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Update User Role'),
      content: DropdownButton<String>(
        value: selectedRole,
        isExpanded: true,
        onChanged: (value) {
          if (value != null) {
            selectedRole = value;
          }
        },
        items: ['Admin', 'User'].map((role) {
          return DropdownMenuItem(
            value: role,
            child: Text(role),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Update'),
          onPressed: () async {
            Navigator.pop(context);
            if (selectedRole != widget.role && widget.onRoleChanged != null) {
              widget.onRoleChanged!(selectedRole);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User role updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.textBlack; 
    if (widget.status == 'Deleted') {
      statusColor = AppColors.pinkRedIcon; 
    } else if (widget.status == 'Active') {
      statusColor = AppColors.greenIcon; 
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: AppTextStyles.valueStyle),
                Text(widget.email, style: AppTextStyles.valueStyle),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(widget.status, style: AppTextStyles.valueStyle.copyWith(color: statusColor)),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primaryBlue,
                    size: 18.0,                        
                  ),
                  onPressed: () {
                    _showUpdateRoleDialog(context);
                  }
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.pinkRedIcon,
                    size: 18.0,
                  ),
                  onPressed: () async{
                    final confirmed = await showConfirmDialog(
                      context: context, 
                      title: 'Confirm Delete', 
                      content: 'Are you sure you want to delete this user?',
                      confirmText: 'Yes',
                      cancelText: 'No',
                      confirmColor: AppColors.pinkRedIcon,
                    );
                    if (confirmed) {
                      widget.onDelete?.call();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User deleted successfully'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } 
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
        
  }
}
