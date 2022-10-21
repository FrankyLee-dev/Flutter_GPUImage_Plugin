/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: take_photo
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/14 11:38
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/14 11:38
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'display_picture.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        cameras: cameras,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.cameras,
  });

  final List<CameraDescription> cameras;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool isFront = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[0],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _imageStream();
  }

  void changeCamera() {
    debugPrint('changeCamera: $isFront');
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      isFront ? widget.cameras[0] : widget.cameras[1],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _imageStream();
    setState(() {
      isFront = !isFront;
    });
  }

  Future<void> _imageStream() async {
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  void _onCreateNewController() {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      isFront ? widget.cameras[1] : widget.cameras[0],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _imageStream();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('didChangeAppLifecycleState: $state');
    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onCreateNewController();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return Column(
                      children: [
                        CameraPreview(_controller),
                      ],
                    );
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            Positioned(
                bottom: 40,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        XFile f = await _controller.takePicture();
                        debugPrint('takePicture: ${f.mimeType}');
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                imagePath: f.path,
                                isFront: isFront,
                              )),
                        );
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text("take pic"),
                      ),
                    ),
                    GestureDetector(
                      onTap: changeCamera,
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: const Text("switch camera"),
                      ),
                    )
                  ],
                ) )
          ],
        ),
      ),
    );
  }
}
