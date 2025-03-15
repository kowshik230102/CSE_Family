import 'package:csefamily/Entry/widgets.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Container(
          width: 350,
          height: 650,
          decoration: boxDecoration(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sign Up', style: headerTextStyle()),
                SizedBox(height: 20),
                buildTextField(Icons.person, 'ID', false),
                SizedBox(height: 20),
                buildTextField(Icons.badge, 'Registration', false),
                SizedBox(height: 20),
                buildTextField(Icons.email, 'Email', false),
                SizedBox(height: 20),
                buildPasswordField(false, () {}),
                SizedBox(height: 20),
                buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}