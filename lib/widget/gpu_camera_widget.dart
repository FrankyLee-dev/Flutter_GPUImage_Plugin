import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: gpu_camera_widget
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/18 12:13
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/18 12:13
/// @UpdateRemark: 更新说明
class GpuCameraWidget extends StatefulWidget {
  const GpuCameraWidget({super.key});

  // This is used in the platform side to register the view.
  final String viewType = 'com.gpuimageview.FGpuCameraView';

  @override
  GpuCameraWidgetState createState() => GpuCameraWidgetState();
}

class GpuCameraWidgetState extends State<GpuCameraWidget> {
  bool granted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission(Permission.camera);
  }

  void _checkPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      setState(() {
        granted = true;
      });
    } else {
      PermissionStatus statuses = await permission.request();
      if (statuses.isGranted) {
        setState(() {
          granted = true;
        });
      } else {
        debugPrint('没有权限');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return granted
        ? AndroidView(
            viewType: widget.viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          )
        : Container();
  }
}
