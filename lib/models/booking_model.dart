import 'package:hive/hive.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 0)
class BookingModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String date;

  @HiveField(4)
  String coinSymbol;

  BookingModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.coinSymbol,
  });
}
