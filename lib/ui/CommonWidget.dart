import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonWidget {

  static ButtonStyle commonbuttonStyle =
  ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Background color
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(8), // Button corner radius
    ),
  );
  static const TextStyle gogo = TextStyle(
     fontSize: 18,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    color: Colors.white,
    );

  static Widget cardTextFormField1({required Widget child}) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Container(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
    ),
    ),);
  }

  static const TextStyle commontextstyle = TextStyle(
    color: Colors.black87,
    fontSize: 13,
    fontFamily: 'RobotoMono',

  );
  static const TextStyle commonboldTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: 'RobotoMono',
fontWeight: FontWeight.w500
  );
  static const TextStyle commontextstylwhite = TextStyle(
    color: Colors.black87,
    fontSize: 15,
    fontFamily: 'RobotoMono',

  );


  static InputDecoration commonTextfieldStyle(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontWeight: FontWeight.bold),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
            color: Colors.blue, width: 2.0), // Border color when focused
      ),
    );
  }

}