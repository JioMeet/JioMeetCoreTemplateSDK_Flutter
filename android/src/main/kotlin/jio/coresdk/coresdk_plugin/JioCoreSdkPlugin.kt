package jio.coresdk.coresdk_plugin

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** JioCoreSdkPlugin */
class JioCoreSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  private lateinit var context: Context
  companion object {
       lateinit var channel : MethodChannel
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "coresdk_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        Constants.MethodNames.LAUNCHMEETINGCORETEMPLATEUI -> {
            val bundle: Bundle = Bundle().apply {
                putString(Constants.MeetingDetails.MEETINGID, call.argument<String>("meetingId").toString())
                putString(Constants.MeetingDetails.MEETINGPIN, call.argument<String>("meetingPin").toString())
                putString(Constants.MeetingDetails.DISPLAYNAME, call.argument<String>("displayName").toString())
            }
          launchNativeActivity(bundle = bundle)
          result.success("")
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun launchNativeActivity(bundle: Bundle) {
    val intent = Intent(context, LaunchMeetingCoreTemplateUIActivity::class.java)
      intent.putExtras(bundle)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    context.startActivity(intent)
  }
}
