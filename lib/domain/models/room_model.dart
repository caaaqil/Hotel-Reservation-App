import 'package:hive/hive.dart';

part 'room_model.g.dart';

@HiveType(typeId: 1)
class RoomModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String type;

  @HiveField(3)
  late double price;

  @HiveField(4)
  late int totalRooms;

  @HiveField(5)
  late List<String> features;

  @HiveField(6)
  late List<String> images;

  @HiveField(7)
  late String description;

  RoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.totalRooms,
    required this.features,
    required this.images,
    required this.description,
  });

  // Factory constructor for creating from JSON
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
      totalRooms: json['totalRooms'] as int,
      features: List<String>.from(json['features'] as List),
      images: List<String>.from(json['images'] as List),
      description: json['description'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'totalRooms': totalRooms,
      'features': features,
      'images': images,
      'description': description,
    };
  }

  // Copy with method
  RoomModel copyWith({
    String? id,
    String? name,
    String? type,
    double? price,
    int? totalRooms,
    List<String>? features,
    List<String>? images,
    String? description,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      totalRooms: totalRooms ?? this.totalRooms,
      features: features ?? this.features,
      images: images ?? this.images,
      description: description ?? this.description,
    );
  }
}
