package jio.coresdk.coresdk_plugin

import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.jiomeet.core.constant.Constant
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.jiomeet.core.utils.BaseUrl
import com.jiomeet.core.CoreApplication
import io.flutter.plugin.common.EventChannel
import org.jio.sdk.common.utilities.Log
import org.jio.sdk.config.JioMeetCoreTemplateUiConfig
import org.json.JSONObject
import org.jio.sdk.sdkmanager.JioMeetSdkManager


/** JioCoreSdkPlugin */
class JioCoreSdkPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var context: Context

    companion object {
        lateinit var channel: MethodChannel
        lateinit var eventChannel: EventChannel
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "coresdk_plugin_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                eventSink = sink
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "coresdk_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            Constants.MethodNames.LAUNCHMEETINGCORETEMPLATEUI -> {
                val meetingDetailsJson = call.argument<String>("meeting_details").toString()
                val meetingDetails = MeetingDetails.fromJson(meetingDetailsJson)
                meetingDetails?.let {
                    val bundle: Bundle = Bundle().apply {
                        putString(
                            Constants.MeetingDetails.MEETINGID,
                            it.meetingId
                        )
                        putString(
                            Constants.MeetingDetails.MEETINGPIN,
                            it.meetingPin
                        )

                        putString(
                            Constants.MeetingDetails.HOSTTOKEN,
                            it.hostToken
                        )

                        putString(
                            Constants.MeetingDetails.DISPLAYNAME,
                            it.displayName
                        )
                        putBoolean(
                            Constants.MeetingDetails.ISINITIALAUDIOON,
                            it.isInitialAudioOn
                        )
                        putBoolean(
                            Constants.MeetingDetails.ISINITIALVIDEOON,
                            it.isInitialVideoOn
                        )
                    }
                    launchNativeActivity(bundle = bundle)
                    result.success("")
                }
            }

            Constants.MethodNames.SETENVIRONMENT -> {
                val environment = when (call.argument<String>("environmentName").toString()) {
                    Constants.Environments.PRESTAGE -> Constant.Environment.PRESTAGE
                    Constants.Environments.RC -> Constant.Environment.RC
                    Constants.Environments.VirginGroups -> Constant.Environment.VirginGroups
                    Constants.Environments.Prod -> Constant.Environment.PROD
                    else -> {
                        Constant.Environment.PROD
                    }
                }
                CoreApplication().recreateModules(context)
                BaseUrl.initializedNetworkInformation(selectedEnvironment = environment)
            }

            Constants.MethodNames.SETCORESDKCONFIG -> {
                val config = call.argument<String>("config").toString()
                val coreSdkConfig = SetCoreSdkConfig.fromJson(config)
                coreSdkConfig?.let {
                    JioMeetCoreTemplateUiConfig.FeatureManager.apply {
                        enableFlipCamera = it.enableFlipCamera
                        isChatEnabled = it.isChatEnabled
                        isMoreFeaturesEnabled = it.isMoreFeaturesEnabled
                        isParticipantPanelEnabled = it.isParticipantPanelEnabled
                        isVideoFeatureEnabled = it.isVideoFeatureEnabled
                        isRecordingLabelEnabled = it.isRecordingLabelEnabled
                        headphonesOrEarpieceOnly = it.headphonesOrEarpieceOnly
                    }
                    JioMeetCoreTemplateUiConfig.FeatureManager.MoreOptions.apply {
                        isAudioOnlyModeEnabled = it.isAudioOnlyModeEnabled
                        isRecordingEnabled = it.isRecordingEnabled
                        isShareEnabled = it.isShareEnabled
                        isVirtualBackgroundEnabled = it.isVirtualBackgroundEnabled
                        isReactionEnabled = it.isReactionEnabled
                    }
                    JioMeetCoreTemplateUiConfig.FeatureManager.TopControlBar.apply {
                        showAudioOptions = it.showAudioOptions
                        showMeetingInfo = it.showMeetingInfo
                        showMeetingTimer = it.showMeetingTimer
                        showMeetingTitle = it.showMeetingTitle
                        showConnectionStateIndicator = it.showConnectionStateIndicator
                        enableAppMinimize = it.enableAppMinimize
                    }
                }
            }

            Constants.MethodNames.LEAVEMEETING -> {
               JioMeetSdkManager.instance?.leaveMeeting()
            }

            Constants.MethodNames.MAXIMIZEMEETING -> {
                JioMeetSdkManager.instance?.showMeetingControls()
            }

            Constants.MethodNames.SETAUTHPARAMS -> {
                val authParams = JSONObject()
                authParams.apply {
                    put("user_id", call.argument<String>("userId").toString())
                    put("jwt_token", call.argument<String>("jwtToken").toString())
                }
                BaseUrl.setParameters(authParams.toString())
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
    }

    private fun launchNativeActivity(bundle: Bundle) {
        val intent = Intent(context, LaunchMeetingCoreTemplateUIActivity::class.java)
        intent.putExtras(bundle)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
