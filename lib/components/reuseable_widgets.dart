import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
  );
}

Widget resuedTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 10.0),
      Container(
        padding: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter $text";
              }
            },
            obscureText: isPasswordType,
            enableSuggestions: !isPasswordType,
            autocorrect: !isPasswordType,
            style: TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                icon,
                color: Color(0xFF7f30fe),
              ),
            ),
            keyboardType: isPasswordType
                ? TextInputType.visiblePassword
                : TextInputType.emailAddress),
      ),
    ],
  );
}
