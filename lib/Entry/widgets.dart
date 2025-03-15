// ignore: file_names
import 'package:flutter/material.dart';

// TextField Builder Function
Widget buildTextField(IconData icon, String hint, bool isPassword) {
  return TextField(
    obscureText: isPassword,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.orange),
      hintText: hint,
      border: UnderlineInputBorder(),
    ),
  );
}

// Password Visibility
Widget buildPasswordField(bool isPasswordVisible, VoidCallback togglePasswordVisibility) {
  return TextField(
    obscureText: !isPasswordVisible,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.lock, color: Colors.orange),
      hintText: 'Password',
      border: UnderlineInputBorder(),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: togglePasswordVisibility,
      ),
    ),
  );
}

// Login Button
Widget buildLoginButton() {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(
        'LOGIN',
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// Box Decoration for Containers
BoxDecoration boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(5, 5),
      ),
    ],
  );
}

// Header Text Style
TextStyle headerTextStyle() {
  return TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
}