import 'package:qr_inventory_management/DTO/product_item_dto.dart';
import 'package:qr_inventory_management/DTO/user_dto.dart';

import '../models/stock_out.dart';


class StockOutDTO {
  static StockOut fromJson(Map<String, dynamic> json) {
    return StockOut(
      id: json['id'],
      productItemId: json['productItemId'],
      productItem: ProductItemDTO.fromJson(json['productItem']),
      userId: json['userId'],
      user: UserDTO.fromJson(json['user']),
      soldDate: DateTime.parse(json['soldDate']),
    );
  }

  static Map<String, dynamic> toJson(StockOut stockOut) {
    return {
      'id': stockOut.id,
      'productItemId': stockOut.productItemId,
      'productItem': ProductItemDTO.toJson(stockOut.productItem),
      'userId': stockOut.userId,
      'user': UserDTO.toJson(stockOut.user),
      'soldDate': stockOut.soldDate.toIso8601String(),
    };
  }
}
