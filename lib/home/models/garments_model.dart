class Garment {
  final String? id;
  final String? imageUrl;
  final String? category;

  Garment({
     this.id,
     this.imageUrl,
     this.category,
  });

  factory Garment.fromJson(Map<String, dynamic> json) {
    return Garment(
      id: json['id'] ?? '',
      imageUrl: json['displayUrl'] ?? '',
      category: json['name'] ?? '',
    );
  }
}