import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin_method_channel.dart';

void main() {
  MethodChannelFlutterGpuimagePlugin platform = MethodChannelFlutterGpuimagePlugin();
  const MethodChannel channel = MethodChannel('flutter_gpuimage_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
