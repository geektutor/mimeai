import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'camera.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(theme: ThemeData.light(), home: MainScreen()),
  );
}

class MainScreen extends StatelessWidget {
  final firstCamera;
  MainScreen({Key key, @required this.firstCamera});

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePictureGeek(
                      camera: firstCamera,
                    ),
                  ),
                );
              },
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
