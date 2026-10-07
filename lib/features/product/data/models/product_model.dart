import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
    required super.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final reviews = json['reviews'] as List<dynamic>?;

    return ProductModel(
      id: json['id'] as int,

      title: json['title'] as String,

      price: (json['price'] as num).toDouble(),

      description: json['description'] as String,

      category: json['category'] as String,

      image: json['thumbnail'] as String,

      rating: (json['rating'] as num).toDouble(),

      ratingCount: reviews?.length ?? 0,
    );
  }
}