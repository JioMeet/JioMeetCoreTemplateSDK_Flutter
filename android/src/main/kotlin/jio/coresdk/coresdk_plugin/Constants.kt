package jio.coresdk.coresdk_plugin

class Constants {
    object MeetingDetails {
        const val MEETINGID = "meetingId"
        const val MEETINGPIN = "meetingPin"
        const val DISPLAYNAME = "displayName"
        const val ISINITIALAUDIOON = "isInitialAudioOn"
        const val ISINITIALVIDEOON = "isInitialVideoOn"
    }

    object MethodNames {
        const val LAUNCHMEETINGCORETEMPLATEUI = "launchMeetingCoreTemplateUi"
        const val SETENVIRONMENT = "setEnvironment"
        const val SETCORESDKCONFIG = "setCoreSdkConfig"
        const val SETAUTHPARAMS = "setAuthParams"
    }

    object Environments {
        const val RC = "rc"
        const val PRESTAGE = "prestage"
        const val VirginGroups = "virginGroups"
    }
}