import 'package:qr_inventory_management/DTO/product_item_dto.dart';
import 'package:qr_inventory_management/DTO/user_dto.dart';

import '../models/stock_in.dart';

class StockInDTO {
  static StockIn fromJson(Map<String, dynamic> json) {
    return StockIn(
      id: json['id'],
      productItemId: json['productItemId'],
      productItem: ProductItemDTO.fromJson(json['productItem']),
      userId: json['userId'],
      user: UserDTO.fromJson(json['user']),
      receivedDate: DateTime.parse(json['receivedDate']),
    );
  }

  static Map<String, dynamic> toJson(StockIn stockIn) {
    return {
      'id': stockIn.id,
      'productItemId': stockIn.productItemId,
      'productItem': ProductItemDTO.toJson(stockIn.productItem),
      'userId': stockIn.userId,
      'user': UserDTO.toJson(stockIn.user),
      'receivedDate': stockIn.receivedDate,
    };
  }
}
