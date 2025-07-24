import 'category_breakdown.dart';

class Report {
  final int totalInStock;
  final int totalSold;
  final int totalStockIns;
  final int totalStockOuts;
  final int recentStockInsLast7Days;
  final int recentStockOutsLast7Days;
  final int netStock;
  final double inventoryValue;
  final double totalSalesValue;
  final double potentialProfit;
  final List<CategoryBreakdown> categoryBreakdown;
  final int lowStockCount;
  final List<LowStockProduct> lowStockProducts;
  final List<TopProduct> hotProducts30Days;


  Report({
    required this.totalInStock,
    required this.totalSold,
    required this.totalStockIns,
    required this.totalStockOuts,
    required this.recentStockInsLast7Days,
    required this.recentStockOutsLast7Days,
    required this.netStock,
    required this.inventoryValue,
    required this.totalSalesValue,
    required this.potentialProfit,
    required this.categoryBreakdown,
    required this.lowStockCount,
    required this.hotProducts30Days,
    required this.lowStockProducts,

  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      totalInStock: json['totalInStock'],
      totalSold: json['totalSold'],
      totalStockIns: json['totalStockIns'],
      totalStockOuts: json['totalStockOuts'],
      recentStockInsLast7Days: json['recentStockInsLast7Days'],
      recentStockOutsLast7Days: json['recentStockOutsLast7Days'],
      netStock: json['netStock'],
      inventoryValue: (json['inventoryValue'] as num).toDouble(),
      totalSalesValue: (json['totalSalesValue'] as num).toDouble(),
      potentialProfit: (json['potentialProfit'] as num).toDouble(),
      categoryBreakdown: (json['categoryBreakdown'] as List)
          .map((e) => CategoryBreakdown.fromJson(e))
          .toList(),
      lowStockCount: json['lowStockCount'],
      lowStockProducts: (json['lowStockProducts'] ?? [])
          .map<LowStockProduct>((p) => LowStockProduct.fromJson(p))
          .toList(),
      hotProducts30Days: (json['hotProducts30Days'] ?? [])
          .map<TopProduct>((p) => TopProduct.fromJson(p))
          .toList(),
    );
  }
}

class LowStockProduct {
  final int productId;
  final String productName;
  final int quantityLeft;

  LowStockProduct({required this.productId, required this.productName, required this.quantityLeft});

  factory LowStockProduct.fromJson(Map<String, dynamic> json) {
    return LowStockProduct(
      productId: json ['productId'],
      productName: json['productName'],
      quantityLeft: json['inStockUnits'],
    );
  }
}

class TopProduct {
  final int productId;
  final String productName;
  final int unitsSold;
  final double totalSales;

  TopProduct({
    required this.productId,
    required this.productName,
    required this.unitsSold,
    required this.totalSales,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productId: json ['productId'],
      productName: json['productName'],
      unitsSold: json['unitsSold'],
      totalSales: (json['totalSales'] as num).toDouble(),
    );
  }
}

class StockCount {
  final int stockInCount;
  final int stockOutCount;

  StockCount({
    required this.stockInCount, 
    required this.stockOutCount,
  });

  factory StockCount.fromJson(Map<String, dynamic> json) {
    return StockCount(
      stockInCount: json['stockInCount'],
      stockOutCount: json['stockOutCount'],
    );
  }
}

class StockTrend {
  final String date;
  final int stockIn;
  final int stockOut;

  StockTrend({required this.date, required this.stockIn, required this.stockOut});

  factory StockTrend.fromJson(Map<String, dynamic> json) {
    return StockTrend(
      date: json['date'],
      stockIn: json['stockIn'],
      stockOut: json['stockOut'],
    );
  }
}
