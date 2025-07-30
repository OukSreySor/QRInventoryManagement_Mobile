import 'package:qr_inventory_management/DTO/product_dto.dart';
import 'package:qr_inventory_management/DTO/stock_in_dto.dart';
import 'package:qr_inventory_management/DTO/stock_out_dto.dart';
import 'package:qr_inventory_management/DTO/user_dto.dart';

import '../models/product_item.dart';
import '../models/enums/product_item_status.dart';

class ProductItemDTO {
  static ProductItem fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      qrCode: json['qrCode'],
      serialNumber: json['serialNumber'],
      status: ProductItemStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      manufacturingDate: DateTime.parse(json['manufacturingDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      productId: json['productId'],
      product: ProductDTO.fromJson(json['product']),
      userId: json['userId'],
      user: UserDTO.fromJson(json['user']),
      stockIns: json['stockIns'] != null
          ? (json['stockIns'] as List)
              .map((e) => StockInDTO.fromJson(e))
              .toList()
          : null,
      stockOuts: json['stockOuts'] != null
          ? (json['stockOuts'] as List)
              .map((e) => StockOutDTO.fromJson(e))
              .toList()
          : null,
    );
  }

  static Map<String, dynamic> toJson(ProductItem item) {
    return {
      'id': item.id,
      'qrCode': item.qrCode,
      'serialNumber': item.serialNumber,
      'status': item.status.toString().split('.').last,
      'manufacturingDate': item.manufacturingDate.toIso8601String(),
      'expiryDate': item.expiryDate.toIso8601String(),
      'productId': item.productId,
      'userId': item.userId,
      'user': UserDTO.toJson(item.user),
      'stockIns': item.stockIns?.map((e) => StockInDTO.toJson(e)).toList(),
      'stockOuts': item.stockOuts?.map((e) => StockOutDTO.toJson(e)).toList(),
    };
  }
}
