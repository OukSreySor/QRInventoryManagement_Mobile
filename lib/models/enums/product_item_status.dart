enum ProductItemStatus { pendingStockIn, inStock, sold, damaged, reserved, lost }

ProductItemStatus productItemStatusFromString(String status) =>
    ProductItemStatus.values.firstWhere((e) => e.name.toLowerCase() == status.toLowerCase());
