class Amenity {
  const Amenity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
  });

  final String id;
  final String name;
  final String nameAr;
  final String icon;

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json['id'] as String,
        name: json['name'] as String,
        nameAr: json['nameAr'] as String,
        icon: json['icon'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameAr': nameAr,
        'icon': icon,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Amenity && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
