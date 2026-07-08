class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.imageUrl,
    required this.badge,
    required this.badgeAr,
    required this.headline,
    required this.headlineAr,
    required this.description,
    required this.descriptionAr,
  });

  final int id;
  final String imageUrl;
  final String badge;
  final String badgeAr;
  final String headline;
  final String headlineAr;
  final String description;
  final String descriptionAr;

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
        id: json['id'] as int,
        imageUrl: json['imageUrl'] as String,
        badge: json['badge'] as String,
        badgeAr: json['badgeAr'] as String,
        headline: json['headline'] as String,
        headlineAr: json['headlineAr'] as String,
        description: json['description'] as String,
        descriptionAr: json['descriptionAr'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'badge': badge,
        'badgeAr': badgeAr,
        'headline': headline,
        'headlineAr': headlineAr,
        'description': description,
        'descriptionAr': descriptionAr,
      };
}
