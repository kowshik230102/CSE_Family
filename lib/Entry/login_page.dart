import 'package:csefamily/Entry/widgets.dart';
import 'package:csefamily/Home_Screen/HomePage.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          decoration: boxDecoration(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 40),
                SizedBox(height: 20),
                Text('Login', style: headerTextStyle()),
                SizedBox(height: 20),
                buildTextField(Icons.email, 'Email', false),
                SizedBox(height: 20),
                buildPasswordField(_isPasswordVisible, () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text('Remember me')
                      ],
                    ),
                    GestureDetector(
                      onTap: () => navigateToForgotPassword(context),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildLoginButton(context), // Pass context
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => navigateToSignUp(context),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to Homepage on login button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      child: Center(
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  void navigateToForgotPassword(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
