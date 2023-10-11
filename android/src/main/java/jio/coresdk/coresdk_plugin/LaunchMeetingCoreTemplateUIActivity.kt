package jio.coresdk.coresdk_plugin

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Column
import com.jiomeet.core.main.models.Audience
import com.jiomeet.core.main.models.JMJoinMeetingConfig
import com.jiomeet.core.main.models.JMJoinMeetingData
import com.jiomeet.core.main.models.JMMeetingUser
import com.jiomeet.core.main.models.Speaker
import dagger.hilt.android.AndroidEntryPoint
import org.jio.sdk.analytics.AnalyticsEvent
import org.jio.sdk.common.customview.CustomView
import org.jio.sdk.common.utilities.Log
import org.jio.sdk.sdkmanager.JioMeetConnectionListener
import org.jio.sdk.templates.core.CoreNav
import org.jio.sdk.templates.core.model.CoreData

@AndroidEntryPoint
class LaunchMeetingCoreTemplateUIActivity : ComponentActivity() {
    private val jioMeetConnectionListener = object : JioMeetConnectionListener {
        override fun onLeaveMeeting() {
            JioCoreSdkPlugin.channel.invokeMethod("meetingEnded",  true)
             finish()
        }

        override fun onRemoveRemoteParticipant(jmMeetingUser: JMMeetingUser) {

        }


    }

    private var requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { mapGranted ->
        val isGranted = mapGranted.all { it.value }
        if (isGranted) {
            openMeetingCoreTemplateUI()
        } else {
            Toast.makeText(applicationContext, getString(R.string.permission_message),Toast.LENGTH_SHORT).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!HelperClass.isInternetAvailable(this)) {
            Toast.makeText(applicationContext, getString(R.string.internet_message),Toast.LENGTH_SHORT).show()
            finish()
        } else if (HelperClass.checkPermission(this)) {
            openMeetingCoreTemplateUI()
        } else{
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
        val jmJoinMeetingData = JMJoinMeetingData(
            meetingId = meetingId,
            meetingPin = meetingPin,
            displayName = displayName,
            version = "",
            deviceId = ""

        )
         val jmJoinMeetingConfig = JMJoinMeetingConfig(
            userRole = Speaker,
            isInitialAudioOn = isInitialAudioOn,
            isInitialVideoOn = isInitialVideoOn,
        )
        setContent {
            val coreData =  CoreData(
                clientToken = "",
                coreListener = jioMeetConnectionListener,
                hostToken = "null",
                jmJoinMeetingConfig = jmJoinMeetingConfig,
                jmJoinMeetingData = jmJoinMeetingData
            )
            Column {
                Log.d("**CoreScreen","$coreData")
                CoreNav(coreData = coreData)
            }
        }
    }
}