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

  // factory StockIn.fromJson(Map<String, dynamic> json) => StockIn(
  //       id: json['id'],
  //       productItemId: json['productItemId'],
  //       productItem: ProductItem.fromJson(json['productItem']),
  //       userId: json['userId'],
  //       user: User.fromJson(json['user']),
  //       receivedDate: DateTime.parse(json['receivedDate']),
  //     );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'productItemId': productItemId,
  //       'productItem': productItem.toJson(),
  //       'userId': userId,
  //       'user': user.toJson(),
  //       'receivedDate': receivedDate.toIso8601String(),
  //     };
}
