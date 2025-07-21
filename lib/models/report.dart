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
    );
  }
}
