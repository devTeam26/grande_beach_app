class ChaletImage {
  const ChaletImage({
    required this.id,
    required this.chaletId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });

  final String id;
  final String chaletId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;

  factory ChaletImage.fromJson(Map<String, dynamic> json) => ChaletImage(
        id: json['id'] as String,
        chaletId: json['chaletId'] as String,
        imageUrl: json['imageUrl'] as String,
        isPrimary: json['isPrimary'] as bool,
        sortOrder: json['sortOrder'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chaletId': chaletId,
        'imageUrl': imageUrl,
        'isPrimary': isPrimary,
        'sortOrder': sortOrder,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ChaletImage && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
