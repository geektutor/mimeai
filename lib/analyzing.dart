import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimeai_app/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:io';

class Analyzing extends StatelessWidget {
  Analyzing({this.imagePath});

  final imagePath;

  @override
  Widget build(BuildContext context) {
    final value = 0.5;
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tight(screenSize),
          padding: EdgeInsets.fromLTRB(32, 70, 32, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mimeai,
              SizedBox(
                height: 48,
              ),
              Flexible(
                child: Container(
               //   height: screenSize.width - 64,
                  width: screenSize.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
//              Container(
//                height: 300,
//                width: screenSize.width,
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(20),
//                  color: Colors.red,
//                  image: DecorationImage(
//                    image: AssetImage(imagePath??'assets/leafphoto.png'),
//                    fit: BoxFit.fill,
//                  ),
//                ),
//              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Please wait, while we analyze the image',
                style: GoogleFonts.manrope(
                  color: Color(0xFF27201D),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Analysis',
                style: GoogleFonts.manrope(
                  color: Color(0xFF27201D),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              LinearPercentIndicator(
                lineHeight: 10,
                percent: value,
                progressColor: Color(0xFF437344),
              ),
              SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  text: '${value * 100}%',
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: ' complete',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 28,
              ),
              ErrorContainer(),
              SizedBox(
                height: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
