
import 'flutter_gpuimage_plugin_platform_interface.dart';

class FlutterGpuimagePlugin {
  Future<String?> getPlatformVersion() {
    return FlutterGpuimagePluginPlatform.instance.getPlatformVersion();
  }
}
