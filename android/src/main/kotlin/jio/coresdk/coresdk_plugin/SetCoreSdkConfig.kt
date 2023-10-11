package jio.coresdk.coresdk_plugin

import com.google.gson.Gson

data class SetCoreSdkConfig(
    var enableFlipCamera: Boolean,
    var isChatEnabled: Boolean,
    var isParticipantPanelEnabled: Boolean,
    var isMoreFeaturesEnabled: Boolean,
    var isAudioOnlyModeEnabled: Boolean,
    var isVirtualBackgroundEnabled: Boolean,
    var isRecordingEnabled: Boolean,
    var isShareEnabled: Boolean,
    var showMeetingTitle: Boolean,
    var showConnectionStateIndicator: Boolean,
    var showAudioOptions: Boolean,
    var showMeetingInfo: Boolean,
    var showMeetingTimer: Boolean
) {
    fun toJsonString(): String {
        return Gson().toJson(this, SetCoreSdkConfig::class.java)
    }

    companion object {
        fun fromJson(json: String): SetCoreSdkConfig? {
            return Gson().fromJson(json, SetCoreSdkConfig::class.java)
        }
    }
}
