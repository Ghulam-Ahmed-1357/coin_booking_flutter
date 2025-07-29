import 'package:coin_api_and_admin_panel/views/admin_panel.dart';
import 'package:coin_api_and_admin_panel/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;

  bool isEmailValid(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z][a-zA-Z0-9]*([._%+-]?[a-zA-Z0-9])*@[a-zA-Z0-9.-]+\.[a-zA-Z]{3,}$",
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.2),
                  Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                  ),
                  SizedBox(height: 40),
                  // TextFormField(
                  //   keyboardType: TextInputType.text,
                  //   textInputAction: TextInputAction.next,
                  //   controller: nameController,
                  //   validator: (value) {
                  //     if (nameController.text.isEmpty) {
                  //       return 'Please provide your name';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter your name',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide(color: Colors.deepPurple),
                  //     ),
                  //     fillColor: Colors.grey.shade100,
                  //     filled: true,
                  //     errorBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.deepPurple),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  TextFormField(
               
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    validator: (value) {
                      if (emailController.text.isEmpty) {
                        return 'Please provide email';
                      } else if (!isEmailValid(emailController.text)) {
                        return 'Please provide valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    obscureText: isObscure,
                    validator: (value) {
                      if (passwordController.text.isEmpty) {
                        return 'Please provide password';
                      } else if (passwordController.text.length < 6) {
                        return "Password must be 6 characters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      bool isValid = formKey.currentState!.validate();
                      if (isValid) {
                        if (emailController.text == 'admin@gmail.com' &&
                            passwordController.text == 'admin12') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPanel(),
                            ),
                            (route) => false,
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    },
                    child: Container(
                      height: size.height * 0.075,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
