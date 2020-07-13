import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';

class Detected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double fillPercent = 19; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    final List<Color> colorList = [
      Color(0xFFFFF7F1),
      Color(0xFFFFF7F1),
      Color(0xFFE6E2DF),
      Color(0xFFE6E2DF),
    ];
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tight(screenSize),
          padding: EdgeInsets.fromLTRB(32, 70, 32, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorList,
              stops: stops,
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: 'mime',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF569557),
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                          style: GoogleFonts.poppins(
                            color: Color(0xFF437344),
                            fontWeight: FontWeight.bold,
                          ),
                          text: 'ai')
                    ]),
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/leafphoto.png',
                      ),
                      fit: BoxFit.fill,
                    )),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Early Blight',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Divider(
                color: Color(0xFF27201d).withOpacity(0.5),
                height: 48,
              ),
              RichText(
                text: TextSpan(
                    text: 'mimeai',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: ' believes your plant may have',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.normal,
                          )),
                      TextSpan(
                        text: '\nEarly Blight',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'DESCRIPTION',
                style: GoogleFonts.manrope(
                  color: Color(0xFF27201d).withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Early Blight of Tomato. Early blight is a fungal disease, Alternaria sp., that occurs on tomatoes throughout North America.',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              ButtonRow(
                onPressed: () {},
              ),
              SizedBox(
                height: 48,
              ),
              LongButton(
                label: 'Back to home',
                onPressed: () {},
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
