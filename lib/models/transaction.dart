import 'product_item.dart';
import 'user.dart';
import 'enums/transaction_type.dart';

class Transaction {
  int id;
  int productItemId;
  ProductItem productItem;
  String userId;
  User user;
  TransactionType transactionType;
  DateTime transactionDate;

  Transaction({
    required this.id,
    required this.productItemId,
    required this.productItem,
    required this.userId,
    required this.user,
    required this.transactionType,
    required this.transactionDate,
  });

  // factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
  //       id: json['id'],
  //       productItemId: json['productItemId'],
  //       productItem: ProductItem.fromJson(json['productItem']),
  //       userId: json['userId'],
  //       user: User.fromJson(json['user']),
  //       transactionType: transactionTypeFromString(json['transactionType']),
  //       transactionDate: DateTime.parse(json['transactionDate']),
  //     );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'productItemId': productItemId,
  //       'productItem': productItem.toJson(),
  //       'userId': userId,
  //       'user': user.toJson(),
  //       'transactionType': transactionType.name,
  //       'transactionDate': transactionDate.toIso8601String(),
  //     };
}
