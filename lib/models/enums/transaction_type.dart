enum TransactionType { stockIn, stockOut }

TransactionType transactionTypeFromString(String type) =>
    TransactionType.values.firstWhere((e) => e.name.toLowerCase() == type.toLowerCase());
