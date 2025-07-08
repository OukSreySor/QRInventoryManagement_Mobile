import 'product_item.dart';
import 'user.dart';

class StockOut {
  int id;
  int productItemId;
  ProductItem productItem;
  String userId;
  User user;
  DateTime soldDate;

  StockOut({
    required this.id,
    required this.productItemId,
    required this.productItem,
    required this.userId,
    required this.user,
    required this.soldDate,
  });

  // factory StockOut.fromJson(Map<String, dynamic> json) => StockOut(
  //       id: json['id'],
  //       productItemId: json['productItemId'],
  //       productItem: ProductItem.fromJson(json['productItem']),
  //       userId: json['userId'],
  //       user: User.fromJson(json['user']),
  //       soldDate: DateTime.parse(json['soldDate']),
  //     );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'productItemId': productItemId,
  //       'productItem': productItem.toJson(),
  //       'userId': userId,
  //       'user': user.toJson(),
  //       'soldDate': soldDate.toIso8601String(),
  //     };
}
