import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_gpuimage_plugin_platform_interface.dart';

/// An implementation of [FlutterGpuimagePluginPlatform] that uses method channels.
class MethodChannelFlutterGpuimagePlugin extends FlutterGpuimagePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_gpuimage_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<dynamic> switchCamera(int front) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('switchCamera', {"front": front});
    return value;
  }

  @override
  Future<dynamic> switchAspectRatio(int ar) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('switchAspectRatio', {"aspectRatio": ar});
    return value;
  }

  @override
  Future<dynamic> setFilter(int filter) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('setFilter', {"filter": filter});
    return value;
  }

  @override
  Future<dynamic> setCameraFilter(Map args) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('setCameraFilter', args);
    return value;
  }

  /// 设置对比度
  @override
  Future<dynamic> setCameraContrast(Map args) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('setCameraContrast', args);
    return value;
  }

  /// 设置亮度
  @override
  Future<dynamic> setCameraBrightness(Map args) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('setCameraBrightness', args);
    return value;
  }

  /// 设置饱和度
  @override
  Future<dynamic> setCameraSaturation(Map args) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('setCameraSaturation', args);
    return value;
  }
}
