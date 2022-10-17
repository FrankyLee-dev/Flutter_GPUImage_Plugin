import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
class GpuImageWidget extends StatelessWidget {
  const GpuImageWidget({super.key, this.uri});

  final String? uri;

  // This is used in the platform side to register the view.
  final String viewType = 'com.gpuimageview.FGpuImageView';

  @override
  Widget build(BuildContext context) {
    debugPrint('GpuImageWidget---$uri');
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{"uri": uri};
    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
