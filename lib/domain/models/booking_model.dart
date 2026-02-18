import 'package:hive/hive.dart';

part 'booking_model.g.dart';

enum BookingStatus {
  confirmed,
  cancelled,
}

@HiveType(typeId: 2)
class BookingModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String roomId;

  @HiveField(3)
  late DateTime checkIn;

  @HiveField(4)
  late DateTime checkOut;

  @HiveField(5)
  late int nights;

  @HiveField(6)
  late double totalPrice;

  @HiveField(7)
  late String status; // 'confirmed' or 'cancelled'

  BookingModel({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.totalPrice,
    required this.status,
  });

  // Factory constructor for creating from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      roomId: json['roomId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      nights: json['nights'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'roomId': roomId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'nights': nights,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  // Copy with method
  BookingModel copyWith({
    String? id,
    String? userId,
    String? roomId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? nights,
    double? totalPrice,
    String? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roomId: roomId ?? this.roomId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      nights: nights ?? this.nights,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }

  // Check if booking is confirmed
  bool get isConfirmed => status == 'confirmed';

  // Check if booking is cancelled
  bool get isCancelled => status == 'cancelled';

  // Check if date range overlaps with another booking
  bool overlaps(DateTime start, DateTime end) {
    return checkIn.isBefore(end) && checkOut.isAfter(start);
  }
}
