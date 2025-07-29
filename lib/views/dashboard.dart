import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'package:coin_api_and_admin_panel/models/booking_model.dart';
import 'package:coin_api_and_admin_panel/models/coin_data_model.dart';
import 'package:coin_api_and_admin_panel/views/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Timer? debounce;

  List<Data> coinList = [];
  List<Data> filteredList = [];
  bool isLoading = false;
  bool isEmailValid(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z][a-zA-Z0-9]*([._%+-]?[a-zA-Z0-9])*@[a-zA-Z0-9.-]+\.[a-zA-Z]{3,}$",
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> getCoins() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(
        'https://rest.coincap.io/v3/assets?apiKey=538f683c82b7c1a9e72974fae64c405505335b69787881b5c40f410bb6e77a45',
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final coinData = jsonResponse['data'] as List;
        setState(() {
          coinList = coinData.map((coin) => Data.fromJson(coin)).toList();
          filteredList = coinList;
          isLoading = false;
        });
      } else {
        print('Request failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCoins();
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market Cap',
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
      ),
      body: coinList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    onChanged: (q) {
                      if (debounce?.isActive ?? false) debounce!.cancel();
                      debounce = Timer(Duration(milliseconds: 300), () {
                        if (q.length > 2) {
                          setState(() {
                            filteredList = coinList.where((coin) {
                              final name = coin.name!.toLowerCase() ?? '';
                              final symbol = coin.symbol!.toLowerCase() ?? '';
                              return name.contains(q.toLowerCase()) ||
                                  symbol.contains(q.toLowerCase());
                            }).toList();
                          });
                        } else {
                          setState(() {
                            filteredList = coinList;
                          });
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',

                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: filteredList.isEmpty
                        ? Center(child: Text('No coin found'))
                        : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final coin = filteredList[index];
                              final price = double.parse(
                                coin.priceUsd!,
                              ).toStringAsFixed(5);
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        child: Form(
                                          key: formKey,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 16,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Booking Details',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                        child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  TextFormField(
                                                    //  inputFormatters: [
                                                    //   FilteringTextInputFormatter.allow(
                                                    //     r'^[a-zA-Z][0-9]',
                                                    //   ),
                                                    // ],
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    keyboardAppearance:
                                                        Brightness.dark,
                                                    controller: nameController,
                                                    validator: (value) {
                                                      if (nameController
                                                          .text
                                                          .isEmpty) {
                                                        return 'Please provide your name';
                                                      }
                                                      if (!RegExp(
                                                        r'^[a-zA-Z][0-9]',
                                                      ).hasMatch(
                                                        nameController.text,
                                                      )) {
                                                        return 'Name must start with a letter';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter your name',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),
                                                      fillColor:
                                                          Colors.grey.shade100,
                                                      filled: true,
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  TextFormField(
                                                   
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    controller: emailController,
                                                    validator: (value) {
                                                      if (emailController
                                                          .text
                                                          .isEmpty) {
                                                        return 'Please provide email';
                                                      } else if (!isEmailValid(
                                                        emailController.text,
                                                      )) {
                                                        return 'Please provide valid email';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter email',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),
                                                      fillColor:
                                                          Colors.grey.shade100,
                                                      filled: true,
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),

                                                  TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    controller: phoneController,
                                                    validator: (value) {
                                                      if (phoneController
                                                          .text
                                                          .isEmpty) {
                                                        return 'Please provide phone number';
                                                      }
                                                      if (!RegExp(
                                                        r'^\+?[0-9]+$',
                                                      ).hasMatch(
                                                        phoneController.text,
                                                      )) {
                                                        return 'Phone number must contain only numbers';
                                                      }
                                                      if (phoneController
                                                              .text
                                                              .length <
                                                          10) {
                                                        return 'Invalid phone number';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter your phone number',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),
                                                      fillColor:
                                                          Colors.grey.shade100,
                                                      filled: true,
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  TextFormField(
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    readOnly: true,
                                                    controller: dateController,
                                                    onTap: () async {
                                                      final pickedDate =
                                                          await showDatePicker(
                                                            context: context,
                                                            firstDate: DateTime(
                                                              2020,
                                                            ),
                                                            lastDate:
                                                                DateTime.now(),
                                                          );
                                                      if (pickedDate != null) {
                                                        dateController.text =
                                                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                                        setState(() {});
                                                      }
                                                    },
                                                    validator: (value) {
                                                      if (dateController
                                                          .text
                                                          .isEmpty) {
                                                        return 'Please select date';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Select date',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),
                                                      fillColor:
                                                          Colors.grey.shade100,
                                                      filled: true,
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                          ),
                                                    ),
                                                  ),

                                                  SizedBox(height: 30),
                                                  InkWell(
                                                    onTap: () async {
                                                      bool isValid = formKey
                                                          .currentState!
                                                          .validate();
                                                      if (isValid) {
                                                        final bookingBox =
                                                            Hive.box<
                                                              BookingModel
                                                            >('bookings');

                                                        final booking =
                                                            BookingModel(
                                                              name:
                                                                  nameController
                                                                      .text,
                                                              email:
                                                                  emailController
                                                                      .text,
                                                              phone:
                                                                  phoneController
                                                                      .text,
                                                              date:
                                                                  dateController
                                                                      .text,
                                                              coinSymbol:
                                                                  coin.symbol ??
                                                                  '',
                                                            );

                                                        await bookingBox.add(
                                                          booking,
                                                        );

                                                        nameController.clear();
                                                        emailController.clear();
                                                        phoneController.clear();
                                                        dateController.clear();

                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Container(
                                                      height:
                                                          size.height * 0.07,
                                                      width: size.width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Book',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(coin.symbol!),
                                    leading: Text(
                                      coin.rank!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    trailing: Text(
                                      '$price \$',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
  }
}
