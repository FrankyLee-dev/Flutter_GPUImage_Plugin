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
import 'package:flutter/material.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin.dart';
import 'package:flutter_gpuimage_plugin/widget/gpu_image_widget.dart';
import 'package:flutter_gpuimage_plugin/widget/gpu_camera_widget.dart';

import 'display_picture.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  // late CameraController _controller;
  // late Future<void> _initializeControllerFuture;

  final _flutterGpuimagePlugin = FlutterGpuimagePlugin();

  bool isFront = false;
  int as = 0;

  double contrast = 1.2;
  double brightness = 0.0;
  double saturation = 1.0;

  final List<Map> _filters = [
    // {"name": "对比度", "type": "contrast", "contrast": 10},
    {"name": "反色", "type": "colorInvert"},
    {"name": "像素化", "type": "pixelation", "pixel": 30},
    // {"name": "亮度", "type": "brightness", "brightness": 0.5},
    {"name": "灰度", "type": "grayscale"},
    {"name": "褐色（怀旧）", "type": "sepia", "sepia": 5},
    // {"name": "饱和度", "type": "saturation", "saturation": 25}
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // To display the current output from the Camera,
    // create a CameraController.
    // _controller = CameraController(
    //   // Get a specific camera from the list of available cameras.
    //   widget.cameras.first,
    //   // Define the resolution to use.
    //   ResolutionPreset.max,
    // );

    // Next, initialize the controller. This returns a Future.
    // _imageStream();
  }

  void changeCamera() {
    debugPrint('changeCamera: $isFront');
    // _controller = CameraController(
    //   // Get a specific camera from the list of available cameras.
    //   !isFront ? widget.cameras[1] : widget.cameras[0],
    //   // Define the resolution to use.
    //   ResolutionPreset.max,
    // );
    // _imageStream();
    setState(() {
      isFront = !isFront;
    });
  }

  // Future<void> _imageStream() async {
  //   await _controller.initialize();
  //   _controller.startImageStream((image) {
  //     List<int> bytes = [];
  //     for (int i = 0; i < image.planes.length; i++) {
  //       debugPrint('startImageStream-planes: ${image.planes[i].bytes.length}');
  //       bytes.addAll(image.planes[i].bytes);
  //     }
  //     _flutterGpuimagePlugin.updatePreviewFrame(
  //         Uint8List.fromList(bytes), image.width, image.height);
  //   });
  //   setState(() {});
  // }

  void _onCreateNewController() {
    // _controller = CameraController(
    //   // Get a specific camera from the list of available cameras.
    //   isFront ? widget.cameras[1] : widget.cameras[0],
    //   // Define the resolution to use.
    //   ResolutionPreset.max,
    // );
    // _imageStream();
    // setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint('didChangeAppLifecycleState: ${_controller.value.isInitialized}');
    // if (_controller.value.isInitialized) {
    //   return;
    // }
    debugPrint('didChangeAppLifecycleState: $state');
    // if (state == AppLifecycleState.inactive) {
    //   _controller.stopImageStream();
    //   _controller.dispose();
    // } else if (state == AppLifecycleState.resumed) {
    //   _onCreateNewController();
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose of the controller when the widget is disposed.
    // _controller.stopImageStream();
    // _controller.dispose();
    super.dispose();
  }

  Widget _buildFilterSelector() {
    List<Widget> child = _filters
        .map((e) => GestureDetector(
              onTap: () {
                _flutterGpuimagePlugin.setCameraFilter(e);
              },
              child: Container(
                height: 40,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: Text(e["name"]),
              ),
            ))
        .toList();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: child,
    );
  }

  Widget _buildValueSelect() {
    return Column(
      children: [
        Row(
          children: [
            const Text('对比度'),
            Expanded(
                child: Slider(
                    value: contrast,
                    min: 1.2,
                    max: 2,
                    onChanged: (value) {
                      setState(() {
                        contrast = value;
                        _flutterGpuimagePlugin.setCameraContrast(
                            {"type": "contrast", "contrast": value});
                      });
                    }))
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          children: [
            const Text('亮度'),
            Expanded(
                child: Slider(
                    value: brightness,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      setState(() {
                        brightness = value;
                        _flutterGpuimagePlugin.setCameraBrightness(
                            {"type": "brightness", "brightness": value});
                      });
                    })),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          children: [
            const Text('饱和度'),
            Expanded(
                child: Slider(
                    value: saturation,
                    min: 1.0,
                    max: 10.0,
                    onChanged: (value) {
                      setState(() {
                        saturation = value;
                        _flutterGpuimagePlugin.setCameraSaturation(
                            {"type": "saturation", "saturation": value});
                      });
                    })),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 4 / 3 * MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: const GpuCameraWidget(),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildFilterSelector(),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildValueSelect(),
            ],
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      isFront = !isFront;
                      _flutterGpuimagePlugin.switchCamera(isFront ? 1 : 0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: const Icon(
                        Icons.cameraswitch_outlined,
                        size: 35,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      as = as == 0 ? 1 : 0;
                      _flutterGpuimagePlugin.switchAspectRatio(as);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: const Icon(
                        Icons.aspect_ratio,
                        size: 35,
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
