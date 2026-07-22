class PriceBreakdownItem {
  const PriceBreakdownItem({required this.description, required this.amount});

  final String description;
  final double amount;

  factory PriceBreakdownItem.fromJson(Map<String, dynamic> json) =>
      PriceBreakdownItem(
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
      );
}

class PricePreviewResult {
  const PricePreviewResult({
    required this.baseAmount,
    required this.addOnsAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.breakdown,
  });

  final double baseAmount;
  final double addOnsAmount;
  final double taxAmount;
  final double totalAmount;
  final List<PriceBreakdownItem> breakdown;

  factory PricePreviewResult.fromJson(Map<String, dynamic> json) =>
      PricePreviewResult(
        baseAmount: (json['baseAmount'] as num).toDouble(),
        addOnsAmount: (json['addOnsAmount'] as num).toDouble(),
        taxAmount: (json['taxAmount'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        breakdown: (json['breakdown'] as List<dynamic>? ?? [])
            .map((e) => PriceBreakdownItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
