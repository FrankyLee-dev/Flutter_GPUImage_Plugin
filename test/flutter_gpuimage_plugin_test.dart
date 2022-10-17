import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin_platform_interface.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterGpuimagePluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterGpuimagePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future setFilter(int filter) {
    // TODO: implement setFilter
    throw UnimplementedError();
  }

  @override
  Future updatePreviewFrame(Uint8List data, int width, int height) {
    // TODO: implement updatePreviewFrame
    throw UnimplementedError();
  }
}

void main() {
  final FlutterGpuimagePluginPlatform initialPlatform = FlutterGpuimagePluginPlatform.instance;

  test('$MethodChannelFlutterGpuimagePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterGpuimagePlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterGpuimagePlugin flutterGpuimagePlugin = FlutterGpuimagePlugin();
    MockFlutterGpuimagePluginPlatform fakePlatform = MockFlutterGpuimagePluginPlatform();
    FlutterGpuimagePluginPlatform.instance = fakePlatform;

    expect(await flutterGpuimagePlugin.getPlatformVersion(), '42');
  });
}
