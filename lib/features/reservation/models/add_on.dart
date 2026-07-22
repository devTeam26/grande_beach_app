class AddOn {
  const AddOn({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.isPerNight,
    required this.icon,
  });

  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final bool isPerNight;
  final String icon;

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
        id: json['id'] as String,
        name: json['name'] as String,
        nameAr: json['nameAr'] as String,
        description: json['description'] as String,
        descriptionAr: json['descriptionAr'] as String,
        price: (json['price'] as num).toDouble(),
        isPerNight: json['isPerNight'] as bool? ?? false,
        icon: json['icon'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameAr': nameAr,
        'description': description,
        'descriptionAr': descriptionAr,
        'price': price,
        'isPerNight': isPerNight,
        'icon': icon,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AddOn && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
