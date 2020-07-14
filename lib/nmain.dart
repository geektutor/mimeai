import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class AppBarTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7F1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30),
          Center(
            child: Container(
              width: 320,
              height: 204,
              child: Text(
                'mimeai can be used to identify diseases in plants  To get started take a picture of the leaf of the affected plant ',
                style: GoogleFonts.nunito(
                  textStyle: GoogleFonts.manrope(fontSize: 24),
                  letterSpacing: 0.03,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/Line1.png',
          ),
          SizedBox(height: 40),
          Container(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF569557),
              onPressed: null,
              child: Icon(
                FeatherIcons.camera,
                size: 35,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('or'),
          SizedBox(height: 10),
          RaisedButton(
            textColor: Color(0xFF437344),
            color: Color.fromRGBO(223, 237, 223, 0.5),
            elevation: 0,
            child: Text(
              'Upload Picture',
              style: GoogleFonts.manrope(fontSize: 18),
            ),
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
