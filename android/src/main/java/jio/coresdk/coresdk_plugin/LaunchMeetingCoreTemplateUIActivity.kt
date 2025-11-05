package jio.coresdk.coresdk_plugin

import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.Rational
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import com.jiomeet.core.constant.Constant
import com.jiomeet.core.main.models.JMJoinMeetingConfig
import com.jiomeet.core.main.models.JMJoinMeetingData
import com.jiomeet.core.main.models.JMMeetingUser
import com.jiomeet.core.main.models.Speaker
import com.jiomeet.core.utils.BaseUrl
import org.jio.sdk.sdkmanager.JioMeetConnectionListener
import org.jio.sdk.sdkmanager.JioMeetSdkManager
import org.jio.sdk.templates.core.LaunchCore

class LaunchMeetingCoreTemplateUIActivity : ComponentActivity() {
    private val jioMeetConnectionListener = object : JioMeetConnectionListener {
        override fun onLeaveMeeting() {
            JioCoreSdkPlugin.eventSink?.success("meetingEnded")
            finish()
        }

        override fun onLocalJoinedRoom(jmMeetingUser: JMMeetingUser) {
            super.onLocalJoinedRoom(jmMeetingUser)
            JioCoreSdkPlugin.eventSink?.success("meetingStarted")
            Log.d("Listener onLocalJoinedRoom", "UID: 0 $jmMeetingUser")
        }

        override fun onRemoveRemoteParticipant(jmMeetingUser: JMMeetingUser) {

        }

        override fun onRemoteUserLeftMeeting(jmMeetingUser: JMMeetingUser) {
            super.onRemoteUserLeftMeeting(jmMeetingUser)
            JioCoreSdkPlugin.eventSink?.success(
                mapOf(
                    "event" to "remoteUserLeftMeeting",
                    "name" to jmMeetingUser.displayName,
                    "userId" to jmMeetingUser.userId
                )
            )
            Log.d("Listener onRemoteUserLeftMeeting", "$jmMeetingUser")
        }

        override fun onRemoteParticipantJoined(jmMeetingUser: JMMeetingUser) {
            super.onRemoteParticipantJoined(jmMeetingUser)
            JioCoreSdkPlugin.eventSink?.success(
                mapOf(
                    "event" to "remoteUserJoinedMeeting",
                    "name" to jmMeetingUser.displayName,
                    "userId" to jmMeetingUser.userId
                )
            )
            Log.d("Listener onRemoteParticipantJoined", "$jmMeetingUser")
        }

        override fun onMinimizeMeetingView() {
            super.onMinimizeMeetingView()
            JioCoreSdkPlugin.eventSink?.success("minimizeMeetingView")
            enterPictureInPictureModeIfSupported()
        }
    }

    private var requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { mapGranted ->
        val isGranted = mapGranted.all { it.value }
        if (isGranted) {
            openMeetingCoreTemplateUI()
        } else {
            Toast.makeText(
                applicationContext,
                getString(R.string.permission_message),
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!HelperClass.isInternetAvailable(this)) {
            Toast.makeText(
                applicationContext,
                getString(R.string.internet_message),
                Toast.LENGTH_SHORT
            ).show()
            finish()
        } else if (HelperClass.checkPermission(this)) {
            openMeetingCoreTemplateUI()
        } else {
            requestPermissionLauncher.launch(PermissionConstant.requiredPermissions)
        }
    }

    private fun openMeetingCoreTemplateUI() {
        val data = intent.extras
        val meetingId = data?.getString(Constants.MeetingDetails.MEETINGID) ?: ""
        val meetingPin = data?.getString(Constants.MeetingDetails.MEETINGPIN) ?: ""
        val displayName = data?.getString(Constants.MeetingDetails.DISPLAYNAME) ?: ""
        val isInitialAudioOn = data?.getBoolean(Constants.MeetingDetails.ISINITIALAUDIOON) ?: false
        val isInitialVideoOn = data?.getBoolean(Constants.MeetingDetails.ISINITIALVIDEOON) ?: false
        val hostToken = data?.getString(Constants.MeetingDetails.HOSTTOKEN) ?: null

        val jmJoinMeetingData = JMJoinMeetingData(
            meetingId = meetingId,
            meetingPin = meetingPin,
            displayName = displayName,
            hostToken = hostToken,
            version = "",
            deviceId = ""

        )
        val jmJoinMeetingConfig = JMJoinMeetingConfig(
            userRole = Speaker,
            isInitialAudioOn = isInitialAudioOn,
            isInitialVideoOn = isInitialVideoOn
        )
        setContent {
            LaunchCore(
                jioMeetConnectionListener = jioMeetConnectionListener,
                jmJoinMeetingConfig = jmJoinMeetingConfig,
                jmJoinMeetingData = jmJoinMeetingData
            )
        }
    }

    private fun enterPictureInPictureModeIfSupported() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        ) {
            try {
                val aspectRatio = Rational(9, 16)
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(aspectRatio)
                    .build()
                val entered = enterPictureInPictureMode(params)
                if (!entered) {
                    Log.w("LaunchMeeting", "PiP not entered; moving task to back")
                    moveTaskToBack(true)
                }
            } catch (t: Throwable) {
                Log.w("LaunchMeeting", "Failed to enter PiP", t)
                moveTaskToBack(true)
            }
        } else {
            // PiP not supported on this device/API. Keep activity alive in background.
            moveTaskToBack(true)
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode)
        if (!isInPictureInPictureMode) {
            try {
                JioMeetSdkManager.instance?.showMeetingControls()
            } catch (t: Throwable) {
                Log.w("LaunchMeeting", "Failed to show controls on PiP exit", t)
            }
        }
    }
}