import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/utils/snackbar_helper.dart';
import '../../DTO/product_item_detail_dto.dart';
import '../../controllers/auth_controller.dart';
import '../../models/item_status_change_log.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../theme/theme.dart';
import '../../utils/confirm_dialog.dart';
import '../../utils/date_formatter.dart';
import '../../utils/no_data_place_holder.dart';

class ProductItemDetails extends StatefulWidget {
  final int productId;
   final VoidCallback? onBack;
   final User? user;

  const ProductItemDetails({
    super.key,
    required this.productId, this.onBack,
    this.user
  });

  @override
  State<ProductItemDetails> createState() => _ProductItemDetailsState();
}

class _ProductItemDetailsState extends State<ProductItemDetails> {
  bool _isLoading = true;
  List<ProductItemDetailDTO> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchProductItems();
  }

   @override
  void didUpdateWidget(covariant ProductItemDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.productId != oldWidget.productId) {
      _isLoading = true; // Reset loading state
      _items = []; // Clear old data
      _fetchProductItems(); // Fetch new data
    }
  }


  Future<void> _fetchProductItems() async {
    try {
      final response = await ApiService().get<List<ProductItemDetailDTO>>(
        '/ProductItem/by-product/${widget.productId}',
        context: context,
        fromJson: (data) {
          final List items = data['data'];
          return items.map((e) => ProductItemDetailDTO.fromJson(e)).toList();
        },
      );

      if (response != null) {
        response.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        setState(() {
          _items = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      SnackbarHelper.error('Failed to load product items.');
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    if (_items.isEmpty) {
      return Column(
        children: [
          _buildHeaderRow(context, '', showBackButton: true),
          SizedBox(
            height: 300.0,
            child: const NoDataPlaceholder(
              title: 'No items found for this product',
              message: 'Start by adding some items using the “Stock In” tab',
              icon: LucideIcons.package, 
            ),
          ),
        ],
      );
    }
     final firstItem = _items.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                _buildHeaderRow(context, firstItem.productName),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8.0),

        ..._items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _ProductItemCard(item: item, user: widget.user),
        )),
      ],
    ),
  
    );  
  }

   Widget _buildHeaderRow(BuildContext context, String title, {bool showBackButton = true}) {
    return Row(
      children: [
        if (showBackButton && widget.onBack != null) 
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16.0, color: Colors.black),
            onPressed: widget.onBack, 
            tooltip: 'Back to Product Summary',
          ),
          Text(
            title,
            style: AppTextStyles.cardHeader.copyWith(fontSize: 14.0),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _ProductItemCard extends StatefulWidget {
  final ProductItemDetailDTO item;
  final User? user;
  const _ProductItemCard({required this.item, this.user});

  @override
  State<_ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<_ProductItemCard> {
  late final AuthController authController;
  bool _isUpdating = false;
  bool _showLogs = false;
  late Future<List<ItemStatusChangeLog>>? _logsFuture;

  //final AuthController? authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;


  @override
  void initState() {
    super.initState();
   // Ensure AuthController exists
    try {
      authController = Get.find<AuthController>();
    } catch (e) {
      authController = Get.put(AuthController(), permanent: false);
    }

    // Only fetch logs if user is admin
    if (isAdmin) {
      _logsFuture = fetchStatusLogs(widget.item.id);
    }
  }

  bool get isAdmin {
    final role = authController.user.value?.role ?? '';
    return role.toLowerCase() == 'admin';
  }

  static const Map<String, List<String>> allowedTransitions = {
    'InStock': ['Repairing', 'Damaged', 'Lost'],
    'Repairing': ['Repaired', 'Damaged', 'Lost'],
    'Damaged': ['Lost'],
    'Repaired': ['InStock'],
  };

  Future<void> _updateStatus(String newStatus) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Confirm Update',
      content: 'Are you sure you want to update status of this item?',
      confirmText: 'Yes',
      cancelText: 'No',
      confirmColor: AppColors.pinkRedIcon,
    );

    if (confirmed != true) return;

    // Ask for optional note
    final note = await _promptForNote();

    setState(() {
      _isUpdating = true;
    });

    try {
      final path = '/ProductItem/${widget.item.id}/status';
      final data = {
        'newStatus': newStatus,
        if (note != null && note.isNotEmpty) 'note': note,
      };

      final updatedStatus = await ApiService().put<String>(
        path,
        data,
        fromJson: (json) => json['data']['status'] as String,
        context: context,
      );

      if (updatedStatus != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $updatedStatus')),
        );

        setState(() {
          widget.item.status = updatedStatus;
        });

        _logsFuture = fetchStatusLogs(widget.item.id);
        setState(() {}); 

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  void _showStatusPicker(BuildContext context) async {
    final currentStatus = widget.item.status;
    final options = allowedTransitions[currentStatus] ?? [];

    final selectedStatus = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: options.map((status) {
          return ListTile(
            title: Text(status),
            onTap: () => Navigator.pop(context, status),
          );
        }).toList(),
      ),
    );

    if (selectedStatus != null) {
      await _updateStatus(selectedStatus);
    }
  }

   String _formatDate(DateTime? date) {
    if (date == null) {
      return 'N/A';
    }
    return DateFormatter.formatDateNumeric(date);
  }

  Future<List<ItemStatusChangeLog>> fetchStatusLogs(int itemId) async {
  final response = await ApiService().get<List<ItemStatusChangeLog>>(
    '/ProductItem/$itemId/status-logs',
    context: context,
    fromJson: (data) {
      final List items = data['data'];
      return items.map((e) => ItemStatusChangeLog.fromJson(e)).toList();
    },
  );

  return response ?? [];
}


  @override
  Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.productName,
                              style: AppTextStyles.titleStyle,
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                border: Border.all(color: AppColors.textFieldBorder),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.item.status, 
                                    style: AppTextStyles.valueStyle.copyWith(color: AppColors.darkBlue),
                                  ),
                                  const SizedBox(width: 8),
                                
                                  if (isAdmin && allowedTransitions.containsKey(widget.item.status))
                                    InkWell(
                                      onTap: () => _showStatusPicker(context),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.edit, size: 16.0, color: Colors.blue),
                                      ),
                                    ),

                                    // History button
                                  // if (isAdmin)
                                  //   TextButton.icon(
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         _showLogs = !_showLogs;
                                  //         if (_showLogs && _logsFuture == null) {
                                  //           _logsFuture = fetchStatusLogs(widget.item.id);
                                  //         }
                                  //       });
                                  //     },
                                  //     icon: Icon(_showLogs ? Icons.history_toggle_off : Icons.history, size: 18),
                                  //     label: Text(_showLogs ? 'Hide History' : 'View Status History'),
                                  //   ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${widget.item.sellingPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Cost: \$${widget.item.unitPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.valueStyle.copyWith(color: AppColors.pinkRedIcon),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(LucideIcons.hash, size: 16.0, color: AppColors.darkBlue),
                      const SizedBox(width: 4.0),
                      Text(
                        'Serial-Number: ${widget.item.serialNumber}',
                        style: AppTextStyles.valueStyle
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16.0, color: AppColors.purpleIcon),
                      const SizedBox(width: 4.0),
                      Text(
                        'Added: ${_formatDate(widget.item.addedDate)}',
                        style: AppTextStyles.valueStyle
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(LucideIcons.user2, size: 16.0, color: AppColors.textBlack),
                      const SizedBox(width: 4.0),
                      Text(
                        'By: ${widget.item.userName}',
                        style: AppTextStyles.valueStyle
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mfg: ${_formatDate(widget.item.manufacturingDate)}',
                        style: AppTextStyles.valueStyle
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Exp: ${_formatDate(widget.item.expiryDate)}',
                        style: AppTextStyles.valueStyle.copyWith(color: AppColors.orangeIcon)
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color:AppColors.textFieldBorder, width: 2.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.item.qrImageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (isAdmin) 
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showLogs = !_showLogs;
                          if (_showLogs && _logsFuture == null) {
                            _logsFuture = fetchStatusLogs(widget.item.id);
                          }
                        });
                      },
                      icon: Icon(_showLogs ? Icons.history_toggle_off : Icons.history, size: 18),
                      label: Text(_showLogs ? 'Hide History' : 'View Status History'),
                    ),

                  if (_showLogs && isAdmin)
                    FutureBuilder<List<ItemStatusChangeLog>>(
                      future: _logsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return const Text('Failed to load status logs');
                        }

                        final logs = snapshot.data ?? [];
                        if (logs.isEmpty) {
                          return const Text('No status changes recorded.');
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: logs.map((log) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBackground,
                                  border: Border.all(color: AppColors.textFieldBorder),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${log.oldStatus} → ${log.newStatus}'),
                                    Text('${DateFormatter.formatDateTimeShort(log.changedAt)}'),
                                    Text('By: ${log.changedByUser}'),
                                    if (log.note != null && log.note!.isNotEmpty)
                                      Text('Note: ${log.note}'),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                ],
              ),
            ),
      );
  
  }

  Future<String?> _promptForNote() async {
  String? note;
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.lightBlue.shade50,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.note_alt, color: AppColors.primaryBlue, size: 24.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Add Note (Optional)',
              style: AppTextStyles.titleStyle.copyWith(
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Enter note here...',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: AppColors.textFieldBorder),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: AppColors.textFieldBorder),
            ),
            backgroundColor: Colors.white 
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.close, color: AppColors.textBlack, size: 18.0),
              SizedBox(width: 8.0),
              Text(
                'Skip',
                style: TextStyle(color: AppColors.textBlack),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: () {
            note = controller.text.trim();
            Navigator.pop(context, note);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check, color: Colors.white, size: 18.0),
              SizedBox(width: 8.0),
              Text('Submit', style: TextStyle(color: AppColors.textWhite)),
            ],
          ),
        ),
      ],
    ),
  );

  return note;
}

}
