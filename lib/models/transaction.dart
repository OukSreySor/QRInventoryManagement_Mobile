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

}
