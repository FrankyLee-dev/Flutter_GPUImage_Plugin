import 'package:flutter/material.dart';
import 'package:flutter_gpuimage_plugin/controller/gpu_image_controller.dart';
import 'package:flutter_gpuimage_plugin/widget/gpu_image_widget.dart';

/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: display_picture
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/14 11:46
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/14 11:46
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  final bool isFront;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.isFront});

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final GpuImageController _gpuImageController = GpuImageController();

  final List<Map> _list = [
    {"type": "colorInvert"},
    {"type": "pixelation", "pixel": 30},
    {"type": "grayscale"},
    {"type": "sepia", "sepia": 15},
    {"type": "sharpen", "sharpen": 25},
    {"type": "transformOperation"}
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildFilterBtn() {
    List<Widget> child = _list
        .map((e) => Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _gpuImageController.setImageFilter(e);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(e["type"]),
              ),
            )))
        .toList();
    return Row(
      children: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPU Image Filter'),
      ),
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 4 / 3 * MediaQuery.of(context).size.width,
              child: GpuImageWidget(
                  imageController: _gpuImageController,
                  creationParams: {
                    "uri": widget.imagePath,
                    "isFront": widget.isFront
                  })),
          Padding(padding: EdgeInsets.only(top: 20)),
          _buildFilterBtn(),
          Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }
}
