import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@pragma("vm:entry-point")
void isolateEntryPoint() {
  WidgetsFlutterBinding.ensureInitialized();

  print("isolateEntryPoint");

  const MethodChannel("com.example.method_channel_ios/isolate")
      .setMethodCallHandler((call) async {
    print("got call ${call.method}");
  });
}
