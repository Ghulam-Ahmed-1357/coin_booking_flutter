import 'package:coin_api_and_admin_panel/models/booking_model.dart';
import 'package:coin_api_and_admin_panel/views/login.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Box<BookingModel> bookingBox;
  late Box bookingMetaBox;
  TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;
  int? previousBookingCount;

  @override
  void initState() {
    super.initState();
    bookingBox = Hive.box<BookingModel>('bookings');
    bookingMetaBox = Hive.box('admin'); // Open your admin/meta box

    WidgetsBinding.instance.addPostFrameCallback((_) {
      int currentCount = bookingBox.length;
      int savedCount = bookingMetaBox.get('booking_count', defaultValue: 0);

      if (currentCount > savedCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New booking received'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      bookingMetaBox.put('booking_count', currentCount);
    });
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                (MaterialPageRoute(builder: (context) => LoginScreen())),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        // actionsPadding: const EdgeInsets.only(right: 8),
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

          List<BookingModel> bookingList = box.values.toList();

          if (selectedDate != null) {
            bookingList = bookingList.where((booking) {
              return booking.date == _dateController.text;
            }).toList();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Filter by Date',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: _pickDate,
                          ),
                          if (_dateController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  selectedDate = null;
                                  _dateController.clear();
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
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
