//
//  JMMeetingHandler.swift
//  coresdk_plugin
//
//  Created by Mani Baratam on 25/09/23.
//

import UIKit
import JioMeetUIKit
import JioMeetCoreSDK
import AVFoundation
import Flutter
class JMMeetingHandler: NSObject {
    private var jioMeetView: JMMeetingView!
    private var environmentName = ""
    private var jwToken = ""
    private var userID = ""
    func showJioMeetView(data: [String: Any]) {
        DispatchQueue.main.async {
            if let topVC = UIApplication.getTopViewController() {
                self.jioMeetView = JMMeetingView()
                self.jioMeetView.translatesAutoresizingMaskIntoConstraints = false
                topVC.view.addSubview(self.jioMeetView)
                
                NSLayoutConstraint.activate([
                    self.jioMeetView.leadingAnchor.constraint(equalTo: topVC.view.leadingAnchor),
                    self.jioMeetView.trailingAnchor.constraint(equalTo: topVC.view.trailingAnchor),
                    self.jioMeetView.topAnchor.constraint(equalTo: topVC.view.topAnchor),
                    self.jioMeetView.bottomAnchor.constraint(equalTo: topVC.view.bottomAnchor),
                ])
                
                let meetingID = data["meetingId"] as? String ?? ""
                let meetingPin = data["meetingPin"] as? String ?? ""
                let name = data["displayName"] as? String ?? ""
                let meetingData = JMJoinMeetingData(
                    meetingId: meetingID ,
                    meetingPin: meetingPin,
                    displayName: name)
                
                let meetingCongfig = JMJoinMeetingConfig(
                    userRole: .speaker,
                    isInitialAudioOn: false,
                    isInitialVideoOn: false)
                self.jioMeetView.setParameters(params: [JMClientConstants.serverEnvironment.rawValue: self.environmentName])
                self.jioMeetView.setParameters(params: ["jm_user_existing_id": self.userID, "jm_user_jwt_token": self.jwToken])

                self.jioMeetView.joinMeeting(
                    meetingData: meetingData,
                    config: meetingCongfig,
                    delegate: self)
            }
        }
    }

    func setEnvironment(data: [String: Any]) {
        guard let enviroment = data["environmentName"] as? String else { return }
        self.environmentName = enviroment
    }
    
    func enableRequiredFeaturesFromConfig(data: [String: Any]) {
        guard let config = data["config"] as? [String: Any] else { return }
        if let enableFlipCamera = config["enableFlipCamera"] as? Bool {
            JMUIKit.enableFlipCamera = enableFlipCamera
        }
        if let isAudioOnlyModeEnabled = config["isAudioOnlyModeEnabled"] as? Bool {
            JMUIKit.isAudioOnlyModeFeatureEnabled = isAudioOnlyModeEnabled
        }
        if let isChatEnabled = config["isChatEnabled"] as? Bool {
            JMUIKit.isChatViewEnabled = isChatEnabled
        }
        if let isMoreFeaturesEnabled = config["isMoreFeaturesEnabled"] as? Bool {
            JMUIKit.isMoreFeaturesEnabled = isMoreFeaturesEnabled
        }
        if let isParticipantPanelEnabled = config["isParticipantPanelEnabled"] as? Bool {
            JMUIKit.isParticipantPanelEnabled = isParticipantPanelEnabled
        }
        if let isRecordingEnabled = config["isRecordingEnabled"] as? Bool {
            JMUIKit.isRecordingEnabled = isRecordingEnabled
        }
        if let isShareEnabled = config["isShareEnabled"] as? Bool {
            JMUIKit.isScreenShareEnabled = isShareEnabled
            JMUIKit.isWhiteboardEnabled = isShareEnabled
        }
        if let isVirtualBackgroundEnabled = config["isVirtualBackgroundEnabled"] as? Bool {
            JMUIKit.isVirtualBackgroundEnabled = isVirtualBackgroundEnabled
        }
        if let showAudioOptions = config["showAudioOptions"] as? Bool {
            JMUIKit.showAudioOptions = showAudioOptions
        }
        if let showConnectionStateIndicator = config["showConnectionStateIndicator"] as? Bool {
            JMUIKit.showConnectionStateIndicator = showConnectionStateIndicator
        }
        if let showMeetingInfo = config["showMeetingInfo"] as? Bool {
            JMUIKit.showMeetingInfo = showMeetingInfo
        }
        if let showMeetingTimer = config["showMeetingTimer"] as? Bool {
            JMUIKit.showMeetingTimer = showMeetingTimer
        }
        if let showMeetingTitle = config["showMeetingTitle"] as? Bool {
            JMUIKit.showMeetingTitle = showMeetingTitle
        }
    }
    
    func setUserLogin(data: [String: Any]) {
        if let token = data["jwtToken"] as? String {
            jwToken = token
        }
        if let userId = data["userId"] as? String {
            userID = userId
        }
    }

    func removeJioMeetView(){
        DispatchQueue.main.async {
            self.jioMeetView.removeFromSuperview()
        }
    }
    
    private func showMeetingJoinError(message: String) {
        guard let topVc = UIApplication.getTopViewController() else { return }
        let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {_ in }
        errorAlertController.addAction(okAction)
        topVc.present(errorAlertController, animated: true)
    }
    
    func micCameraPermissons(){
        getAudioVideoAuthorization {[weak self] (isCameraAllowed, isMicAllowed, isFirstTime) in
            guard isCameraAllowed && isMicAllowed else {
                self?.showMicCameraErrorAlert()
                return
            }
        }
    }
    
    private func showMicCameraErrorAlert() {
        guard let topVc = UIApplication.getTopViewController() else { return }
        let errorAlert = UIAlertController(
            title: "Camera Mic Permission Error",
            message: "You have not granted Mic and Camera Permission. Please provide.",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            guard let appSettingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(appSettingURL) else { return }
            UIApplication.shared.open(appSettingURL)
        }
        errorAlert.addAction(cancelAction)
        errorAlert.addAction(settingsAction)
        topVc.present(errorAlert, animated: true)
    }
    
    private func getAudioVideoAuthorization(completion: @escaping ((_ isCameraAllowed: Bool, _ isMicAllowed: Bool, _ isFirstTime: Bool) -> Void)) {
        getVideoAuthorization(completion: {(isSuccess, isFirstTime) in
            let cameraAccess = isSuccess
            self.getAudioAuthorization(completion: {(isSuccess) in
                let micAccess = isSuccess
                completion(cameraAccess, micAccess, isFirstTime)
            })
        })
    }
    
    private func getVideoAuthorization(completion: @escaping (_ isAuthorized: Bool, _ isFirstTime: Bool) -> Void) {
        AVCaptureDevice.authorizeVideo(completion: {(status) in
            switch status {
            case .justAuthorized:
                completion(true, true)
            case .alreadyAuthorized:
                completion(true, false)
            case .justDenied:
                completion(false, true)
            case .alreadyDenied, .restricted:
                completion(false, false)
            default:
                completion(false, false)
            }
        })
    }
    
    private func getAudioAuthorization(completion: @escaping (_ isAuthorized: Bool) -> Void) {
        AVCaptureDevice.authorizeAudio(completion: {(status) in
            switch status {
            case .justAuthorized, .alreadyAuthorized:
                completion(true)
            default:
                completion(false)
            }
        })
    }
}

extension JMMeetingHandler: JMMeetingViewDelegate {
    
    func didLocalUserExitsMeetingView() {
        removeJioMeetView()
        JioCoreSdkPlugin.channel.invokeMethod("meetingEnded", arguments: true)
    }
    
    func didLocalUserFailedToJoinMeeting(errorMessage: String) {
        removeJioMeetView()
        showMeetingJoinError(message: errorMessage)
    }
    
    func didRequestToShareMeetingView(meetingID: String, meetingPin: String) {
    }
    
    func didRequestToBuildMeetingShareLink(meetingID: String, meetingPin: String, completion: @escaping ((String) -> Void)) {
    }
}


extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
