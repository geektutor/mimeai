import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mimeai_app/analyzing.dart';
import 'package:mimeai_app/widgets.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      home: TakePictureGeek(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureGeek extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureGeek({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureGeek> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
              height: screenSize.height,
              width: screenSize.width,
              //   padding: EdgeInsets.symmetric(horizontal: 30),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: screenSize.height * 0.25,
              width: screenSize.width,
              color: Color.fromRGBO(129, 108, 97, 0.3),
              // color: Colors.grey.withOpacity(0.3),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    height: screenSize.height * 0.25 - 70,
                    width: screenSize.width - 40,
                    padding: EdgeInsets.fromLTRB(24, 24, 0, 24),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFFFF7F1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        mimeai,
                        Text(
                          'Take a picture of an affected  leaf of the plant',
                          style: GoogleFonts.manrope(
                            textStyle: TextStyle(),
                            fontSize: 16,
                            letterSpacing: 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height * 0.22,
              width: screenSize.width,
              color: Color.fromRGBO(129, 108, 97, 0.3),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 64,
                        height: 64,
                        child: FloatingActionButton(
                          heroTag: "btn1",
                          backgroundColor: Color(0xFF569557),
                          onPressed: null,
                          child: Icon(
                            FeatherIcons.zap,
                            size: 35,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          backgroundColor: Color(0xFF569557),
                          child: Icon(
                            FeatherIcons.camera,
                            size: 35,
                          ),
                          onPressed: () async {
// Take the Picture in a try / catch block. If anything goes wrong,
// catch the error.
                            try {
// Ensure that the camera is initialized.
                              await _initializeControllerFuture;

// Construct the path where the image should be saved using the
// pattern package.
                              final path = join(
// Store the picture in the temp directory.
// Find the temp directory using the `path_provider` plugin.
                                (await getTemporaryDirectory()).path,
                                '${DateTime.now()}.png',
                              );

// Attempt to take a picture and log where it's been saved.
                              await _controller.takePicture(path);

// If the picture was taken, display it on a new screen.
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Analyzing(
                                    imagePath: path,
                                  ),
                                ),
                              );
                            } catch (e) {
// If an error occurs, log the error to the console.
                              print(e);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 64,
                        height: 64,
                        child: FloatingActionButton(
                          heroTag: "btn3",
                          backgroundColor: Color(0xFF569557),
                          onPressed: null,
                          child: Icon(
                            FeatherIcons.refreshCw,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
      ),
    ));
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureGeek extends StatelessWidget {
  final String imagePath;

  const DisplayPictureGeek({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
