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
    private var jioMeetView = JMMeetingView()
    
    func showJioMeetView(data: [String: Any]) {
        DispatchQueue.main.async {
            if let topVC = UIApplication.getTopViewController() {
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
                
                self.jioMeetView.joinMeeting(
                    meetingData: meetingData,
                    config: meetingCongfig,
                    delegate: self)
            }
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
        let okAction = UIAlertAction(title: "Ok", style: .default) {[weak self] _ in
        }
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
