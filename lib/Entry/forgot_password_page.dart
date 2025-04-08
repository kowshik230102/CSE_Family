import 'dart:math';
import 'package:csefamily/Entry/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'verify_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Replace this with your actual API key and caller ID
  final String apiKey = '1c1f165d2bc34b602f8cd57f1397658c659a4040';
  final String callerID = '1234';

  // Function to generate a 4-digit random OTP
  String generateOtp() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> sendOtp(String number) async {
    final otp = generateOtp();
    final cleanMessage = 'Your PayIt OTP is $otp';
    final message = Uri.encodeComponent(cleanMessage.trim()); // Trim + encode

    final url =
        'https://bulksmsdhaka.com/api/otpsend?apikey=$apiKey&callerID=$callerID&number=$number&message=$message';

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              phoneNumber: number,
              sentOtp: otp,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter your mobile number to reset password',
                    textAlign: TextAlign.center),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.orange),
                    hintText: 'Mobile Number',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length != 11) {
                      return 'Enter a valid 11-digit number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendOtp(_phoneController.text.trim());
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child:
                      Text('Send OTP', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
