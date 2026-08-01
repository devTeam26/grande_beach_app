class ChaletImage {
  const ChaletImage({
    required this.id,
    required this.imageUrl,
    this.altText,
    required this.isPrimary,
    required this.sortOrder,
  });

  final String id;
  final String imageUrl;
  final String? altText;
  final bool isPrimary;
  final int sortOrder;

  factory ChaletImage.fromJson(Map<String, dynamic> json) => ChaletImage(
        id: json['id'] as String,
        imageUrl: (json['url'] ?? json['imageUrl']) as String,
        altText: json['altText'] as String?,
        isPrimary: json['isPrimary'] as bool? ?? false,
        sortOrder: json['sortOrder'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': imageUrl,
        'altText': altText,
        'isPrimary': isPrimary,
        'sortOrder': sortOrder,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ChaletImage && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
