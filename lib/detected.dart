import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';

class Detected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tight(screenSize),
          decoration: BoxDecoration(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(32, 70, 32, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      mimeai,
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
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
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
                    ],
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.19,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(
                      top: 24, bottom: screenSize.height * 0.19 * 0.5),
                  child: LongButton(
                    onPressed: () {},
                    label: 'Back to home',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
