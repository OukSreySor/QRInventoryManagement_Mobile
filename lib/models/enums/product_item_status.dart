enum ProductItemStatus { inStock, sold, repairing, repaired, damaged, lost }

ProductItemStatus productItemStatusFromString(String status) =>
    ProductItemStatus.values.firstWhere((e) => e.name.toLowerCase() == status.toLowerCase());
