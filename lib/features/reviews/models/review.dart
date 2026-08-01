class Review {
  const Review({
    required this.id,
    required this.chaletId,
    required this.chaletName,
    required this.bookingId,
    required this.guestName,
    required this.rating,
    required this.comment,
    required this.isApproved,
    required this.createdAt,
  });

  final String id;
  final String chaletId;
  final String chaletName;
  final String bookingId;
  final String guestName;
  final int rating;
  final String comment;
  final bool isApproved;
  final DateTime createdAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        chaletId: json['chaletId'] as String,
        chaletName: json['chaletName'] as String? ?? '',
        bookingId: json['bookingId'] as String? ?? '',
        guestName: json['guestName'] as String? ?? '',
        rating: (json['rating'] as num).toInt(),
        comment: json['comment'] as String? ?? '',
        isApproved: json['isApproved'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Review && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
