import 'flutter_gpuimage_plugin_platform_interface.dart';

class FlutterGpuimagePlugin {
  Future<String?> getPlatformVersion() {
    return FlutterGpuimagePluginPlatform.instance.getPlatformVersion();
  }

  Future<dynamic> setImageFilter(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageFilter(args);
  }

  Future<dynamic> setImageContrast(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageContrast(args);
  }

  Future<dynamic> setImageBrightness(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageBrightness(args);
  }

  Future<dynamic> setImageSaturation(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageSaturation(args);
  }

}
