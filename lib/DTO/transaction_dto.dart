import 'package:qr_inventory_management/DTO/product_item_dto.dart';
import 'package:qr_inventory_management/DTO/user_dto.dart';
import 'package:qr_inventory_management/models/enums/transaction_type.dart';
import 'package:qr_inventory_management/models/transaction.dart';

class TransactionDTO {
  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      productItemId: json['productItemId'],
      productItem: ProductItemDTO.fromJson(json['productItem']),
      userId: json['userId'],
      user: UserDTO.fromJson(json['user']),
      transactionType: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['transactionType'],
      ),
      transactionDate: DateTime.parse(json['transactionDate']),
    );
  }

  static Map<String, dynamic> toJson(Transaction transaction) {
    return {
      'id': transaction.id,
      'productItemId': transaction.productItemId,
      'productItem': ProductItemDTO.toJson(transaction.productItem),
      'userId': transaction.userId,
      'user': UserDTO.toJson(transaction.user),
      'transactionType': transaction.transactionType.toString().split('.').last,
      'transactionDate': transaction.transactionDate,
    };
  }
}
