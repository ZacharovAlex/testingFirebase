import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final List<TextInputFormatter>? formatter;
  final TextEditingController controller;
  final String? title;
  const CustomTextField({Key? key, required this.formatter, required this.controller, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //initialValue: title,
      inputFormatters: formatter,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: TextStyle(fontSize: 17),
         // labelText: title
      ),
      controller: controller,
    );
  }
}

