package jio.coresdk.coresdk_plugin
import com.google.gson.Gson

data class MeetingDetails(
    var meetingId:String,
    var meetingPin:String,
    var displayName:String,
    var isInitialAudioOn:Boolean,
    var isInitialVideoOn:Boolean,
    var hostToken: String?
) {
    fun toJsonString() : String {
        return Gson().toJson(this, MeetingDetails::class.java)
    }

    companion object {
        fun fromJson(json : String) : MeetingDetails? {
            return Gson().fromJson(json, MeetingDetails::class.java)
        }
    }
}
