import 'user.dart';
import 'product.dart';
import 'stock_in.dart';
import 'stock_out.dart';
import 'enums/product_item_status.dart';

class ProductItem {
  int id;
  String? qrCode;
  String serialNumber;
  ProductItemStatus status;
  DateTime manufacturingDate;
  DateTime expiryDate;
  int productId;
  Product product;
  String userId;
  User user;
  List<StockIn>? stockIns;
  List<StockOut>? stockOuts;

  ProductItem({
    required this.id,
    this.qrCode,
    required this.serialNumber,
    required this.status,
    required this.manufacturingDate,
    required this.expiryDate,
    required this.productId,
    required this.product,
    required this.userId,
    required this.user,
    this.stockIns,
    this.stockOuts,
  });

  // factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
  //       id: json['id'],
  //       qrCode: json['qr_Code'],
  //       serialNumber: json['serial_Number'],
  //       status: productItemStatusFromString(json['status']),
  //       manufacturingDate: DateTime.parse(json['manufacturing_Date']),
  //       expiryDate: DateTime.parse(json['expiry_Date']),
  //       productId: json['productId'],
  //       product: Product.fromJson(json['product']),
  //       userId: json['userId'],
  //       user: User.fromJson(json['user']),
  //       stockIns: json['stockIns'] != null
  //           ? List<StockIn>.from(json['stockIns'].map((x) => StockIn.fromJson(x)))
  //           : null,
  //       stockOuts: json['stockOuts'] != null
  //           ? List<StockOut>.from(json['stockOuts'].map((x) => StockOut.fromJson(x)))
  //           : null,
  //     );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'qr_Code': qrCode,
  //       'serial_Number': serialNumber,
  //       'status': status.name,
  //       'manufacturing_Date': manufacturingDate.toIso8601String(),
  //       'expiry_Date': expiryDate.toIso8601String(),
  //       'productId': productId,
  //       'product': product.toJson(),
  //       'userId': userId,
  //       'user': user.toJson(),
  //       'stockIns': stockIns?.map((x) => x.toJson()).toList(),
  //       'stockOuts': stockOuts?.map((x) => x.toJson()).toList(),
  //     };
}
