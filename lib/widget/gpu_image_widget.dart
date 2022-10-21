import 'package:flutter/material.dart';

import '../controller/gpu_image_controller.dart';

/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: gpu_image_widget
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/13 11:44
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/13 11:44
/// @UpdateRemark: 更新说明
///

class GpuImageWidget extends StatelessWidget {
  const GpuImageWidget(
      {super.key, required this.imageController, this.creationParams});

  final GpuImageController imageController;

  final Map<String, dynamic>? creationParams;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: imageController,
        builder: (BuildContext context, Object? value, Widget? child) {
          return imageController.buildPreview(creationParams);
        });
  }
}
