import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var channel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let callerChannel = FlutterMethodChannel(
      name: "com.example.method_channel_ios/caller",
      binaryMessenger: controller.binaryMessenger)
    callerChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "start":
        if let args = call.arguments as? [String: Any],
          let callbackHandle = args["callbackHandle"] as? Int64,
          let flutterCallbackInformation = FlutterCallbackCache.lookupCallbackInformation(
            callbackHandle)
        {
          let isolate = FlutterEngine(name: "isolate")  // for the bg channel
          isolate.run(
            withEntrypoint: flutterCallbackInformation.callbackName,
            libraryURI: flutterCallbackInformation.callbackLibraryPath)
          GeneratedPluginRegistrant.register(with: isolate)
          print("call started")
          self?.channel = FlutterMethodChannel(
            name: "com.example.method_channel_ios/isolate",
            binaryMessenger: isolate.binaryMessenger)
          self?.channel?.invokeMethod("triggered", arguments: nil)
        }
        result(nil)
      case "trigger":
        print("call triggered")
        self?.channel?.invokeMethod("triggered", arguments: nil)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
