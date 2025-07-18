import 'package:coin_api_and_admin_panel/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Box<BookingModel> bookingBox;

  @override
  void initState() {
    super.initState();
    // Open the Hive box
    bookingBox = Hive.box<BookingModel>('bookings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: bookingBox.listenable(),
        builder: (context, Box<BookingModel> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text(
                'No bookings are available',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final bookingList = box.values.toList();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bookingList.length,
                      itemBuilder: (context, index) {
                        final booking = bookingList[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coin: ${booking.coinSymbol}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Name: ${booking.name}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Email: ${booking.email}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Phone: ${booking.phone}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Date: ${booking.date}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
