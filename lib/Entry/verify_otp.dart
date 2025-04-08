import 'package:flutter/material.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
  final String sentOtp;

  const VerifyOtpPage({
    super.key,
    required this.phoneNumber,
    required this.sentOtp,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  void verifyOtp() {
    if (_otpController.text.trim() == widget.sentOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified! Now reset your password.')),
      );
      // Navigate to reset password page or update UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter the OTP sent to ${widget.phoneNumber}'),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.orange),
                  hintText: 'OTP',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyOtp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text('Verify', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}