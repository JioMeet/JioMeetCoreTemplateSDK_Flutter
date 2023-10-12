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
        let arguments: [String: Any] = call.arguments as? [String : Any] ?? [:]
        switch call.method {
        case "launchMeetingCoreTemplateUi":
            loadTemplateSDK(data: arguments)
        case "setEnvironment":
            setEnvironment(data: arguments)
        case "setCoreSdkConfig":
            setConfigValues(data: arguments)
        case "setAuthParams":
            setUserLogin(data: arguments)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func loadTemplateSDK(data: [String: Any]) {
        jmMeetigHandler.showJioMeetView(data: data)
    }
    
    private func setEnvironment(data: [String: Any]) {
        jmMeetigHandler.setEnvironment(data: data)
    }
    
    private func setConfigValues(data: [String: Any]) {
        jmMeetigHandler.enableRequiredFeaturesFromConfig(data: data)
    }
    
    private func setUserLogin(data: [String: Any]) {
        jmMeetigHandler.setUserLogin(data: data)
    }
}

