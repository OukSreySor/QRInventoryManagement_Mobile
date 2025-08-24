enum ProductStatus { available, outOfStock, discontinued }

ProductStatus productStatusFromString(String status) =>
    ProductStatus.values.firstWhere((e) => e.name.toLowerCase() == status.toLowerCase());

ProductStatus getProductStatus(String status) {
  switch (status.toLowerCase()) {
    case 'discontinued':
      return ProductStatus.discontinued;
    default:
      return ProductStatus.available;
  }
}