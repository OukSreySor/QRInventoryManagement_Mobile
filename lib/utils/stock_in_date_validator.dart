class StockInDateValidator {
  final DateTime manufacturingDate;
  final DateTime expiryDate;
  final DateTime addedDate;

  StockInDateValidator({
    required this.manufacturingDate,
    required this.expiryDate,
    required this.addedDate,
  });

  String? validate() {
    final now = DateTime.now();

    if (manufacturingDate.isAfter(now)) {
      return 'Manufacturing date cannot be in the future.';
    }

    if (!expiryDate.isAfter(manufacturingDate)) {
      return 'Expiry date must be after manufacturing date.';
    }

    if (!expiryDate.isAfter(now)) {
      return 'Expiry date must be a future date.';
    }

    if (addedDate.isBefore(manufacturingDate)) {
      return 'Added date cannot be before manufacturing date.';
    }

    if (addedDate.isAfter(expiryDate)) {
      return 'Added date cannot be after expiry date.';
    }

    if (addedDate.isAfter(now)) {
      return 'Added date cannot be in the future.';
    }

    return null;
  }
}
