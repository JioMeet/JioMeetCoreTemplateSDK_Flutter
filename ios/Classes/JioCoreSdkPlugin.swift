import Flutter
import UIKit

public class JioCoreSdkPlugin: NSObject, FlutterPlugin {
    let jmMeetigHandler = JMMeetingHandler()
    private static var channel = FlutterMethodChannel()
    static var eventChannel = FlutterEventChannel()
    static var eventSink: FlutterEventSink?
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "coresdk_plugin", binaryMessenger: registrar.messenger())
        
        eventChannel = FlutterEventChannel(name: "coresdk_plugin_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(EventStreamHandler())

        let instance = JioCoreSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    
    private class EventStreamHandler: NSObject, FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
            JioCoreSdkPlugin.eventSink = eventSink
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            JioCoreSdkPlugin.eventSink = nil
            return nil
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments as? [String : Any] ?? [:]
        switch call.method {
        case "launchMeetingCoreTemplateUi":
            loadTemplateSDK(data: arguments)
        case "leaveMeeting":
            leaveMeeting()
        case "setEnvironment":
            setEnvironment(data: arguments)
        case "setScreenShareConfig":
            setScreenShareConfig(data: arguments)
        case "setCoreSdkConfig":
            setConfigValues(data: arguments)
        case "setAuthParams":
            setUserLogin(data: arguments)
        case "onMaximizeMeetingView":
            maximizeMeetingView()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func loadTemplateSDK(data: [String: Any]) {
        let instance = JioCoreSdkPlugin()
        instance.jmMeetigHandler.micCameraPermissons { isSuccess in
            if isSuccess {
                self.jmMeetigHandler.showJioMeetView(data: data)
            }
        }
    }
    
    private func leaveMeeting() {
        jmMeetigHandler.leaveMeeting()
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
    
    private func setScreenShareConfig(data: [String: Any]) {
        jmMeetigHandler.setScreenShareConfig(data: data)
    }
    
    private func maximizeMeetingView() {
        jmMeetigHandler.maximizeMeetingView()
    }
}

