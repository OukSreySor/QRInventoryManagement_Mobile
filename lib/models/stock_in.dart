import 'product_item.dart';
import 'user.dart';

class StockIn {
  int id;
  int productItemId;
  ProductItem productItem;
  String userId;
  User user;
  DateTime receivedDate;

  StockIn({
    required this.id,
    required this.productItemId,
    required this.productItem,
    required this.userId,
    required this.user,
    required this.receivedDate,
  });
}
