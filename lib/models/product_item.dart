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

}
