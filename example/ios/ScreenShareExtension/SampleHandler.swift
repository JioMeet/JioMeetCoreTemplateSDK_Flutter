//
//  SampleHandler.swift
//  ScreenShareExtension
//
//  Created by Mani Baratam on 19/12/24.
//

import ReplayKit
import JioMeetScreenShareSDK

class SampleHandler: JMScreenShareHandler {
  override func getAppGroupsIdentifier() -> String {
    return "group.com.jio.jiomeet.nativesdk"
  }
}
