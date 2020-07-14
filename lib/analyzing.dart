import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimeai_app/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Analyzing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final value = 0.5;
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 70, 32, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mimeai,
              SizedBox(
                height: 48,
              ),
              Container(
                height: 300,
                width: screenSize.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage('assets/leafphoto.png'),
                  ),
                ),
              ),
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
