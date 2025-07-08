enum ProductStatus { available, outOfStock, discontinued }

ProductStatus productStatusFromString(String status) =>
    ProductStatus.values.firstWhere((e) => e.name.toLowerCase() == status.toLowerCase());
