import Flutter
import UIKit

public class JioCoreSdkPlugin: NSObject, FlutterPlugin {
    let jmMeetigHandler = JMMeetingHandler()
    static var channel = FlutterMethodChannel()
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "coresdk_plugin", binaryMessenger: registrar.messenger())
        let instance = JioCoreSdkPlugin()
        instance.jmMeetigHandler.micCameraPermissons()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
        
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "launchMeetingCoreTemplateUi":
            if call.arguments is [String: Any] {
                let arguments: [String: Any] = call.arguments as! [String : Any]
                loadTemplateSDK(data: arguments)
                result("Success")
            }
            result("Success")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func loadTemplateSDK(data: [String: Any]) {
        jmMeetigHandler.showJioMeetView(data: data)
    }
}

