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
import org.jio.sdk.config.JioMeetCoreTemplateUiConfig
import org.json.JSONObject


/** JioCoreSdkPlugin */
class JioCoreSdkPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var context: Context

    companion object {
        lateinit var channel: MethodChannel
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "coresdk_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            Constants.MethodNames.LAUNCHMEETINGCORETEMPLATEUI -> {
                val bundle: Bundle = Bundle().apply {
                    putString(
                        Constants.MeetingDetails.MEETINGID,
                        call.argument<String>("meetingId").toString()
                    )
                    putString(
                        Constants.MeetingDetails.MEETINGPIN,
                        call.argument<String>("meetingPin").toString()
                    )
                    putString(
                        Constants.MeetingDetails.DISPLAYNAME,
                        call.argument<String>("displayName").toString()
                    )
                    putBoolean(
                        Constants.MeetingDetails.ISINITIALAUDIOON,
                        call.argument<Boolean>("isInitialAudioOn") ?: false
                    )
                    putBoolean(
                        Constants.MeetingDetails.ISINITIALVIDEOON,
                        call.argument<Boolean>("isInitialVideoOn") ?: false
                    )
                }
                launchNativeActivity(bundle = bundle)
                result.success("")
            }

            Constants.MethodNames.SETENVIRONMENT -> {
                val environment = when (call.argument<String>("environmentName").toString()) {
                    Constants.Environments.PRESTAGE -> Constant.Environment.PRESTAGE
                    Constants.Environments.RC -> Constant.Environment.RC
                    Constants.Environments.VirginGroups -> Constant.Environment.VirginGroups
                    else -> Constant.Environment.PROD
                }
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
                    }
                    JioMeetCoreTemplateUiConfig.FeatureManager.MoreOptions.apply {
                        isAudioOnlyModeEnabled = it.isAudioOnlyModeEnabled
                        isRecordingEnabled = it.isRecordingEnabled
                        isShareEnabled = it.isShareEnabled
                        isVirtualBackgroundEnabled = it.isVirtualBackgroundEnabled
                    }
                    JioMeetCoreTemplateUiConfig.FeatureManager.TopControlBar.apply {
                        showAudioOptions = it.showAudioOptions
                        showMeetingInfo = it.showMeetingInfo
                        showMeetingTimer = it.showMeetingTimer
                        showMeetingTitle = it.showMeetingTitle
                        showConnectionStateIndicator = it.showConnectionStateIndicator

                    }
                }
            }

            Constants.MethodNames.SETAUTHPARAMS -> {
                val authParams = JSONObject()
                authParams.apply {
                    put("user_id",call.argument<String>("userId").toString())
                    put("jwt_token",call.argument<String>("jwtToken").toString())
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
    }

    private fun launchNativeActivity(bundle: Bundle) {
        val intent = Intent(context, LaunchMeetingCoreTemplateUIActivity::class.java)
        intent.putExtras(bundle)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
