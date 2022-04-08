package com.example.periodic_timer

import android.content.Context
import android.database.Cursor
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel1 = "com.example.periodic_timer1"
var _ringtone: Ringtone? = null;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, channel1)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAllRingtones" -> {
                        result.success(getAllRingtones(this))
                    }
                    "playRingtones" -> {
                        result.success(playMp3(myUri =  call.argument<String>("text")))
                    }
                    "stopRingtone" -> {
                        result.success(stopMp3())
                    }
                }


// add this method to handle the calls from flutter

            }

    }
    private fun getAllRingtones(context: Context): Map<String, Any> {

        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)

        val cursor: Cursor = manager.cursor
        val list: MutableMap<String, String> = LinkedHashMap()
        val title = "Set to Default"
        val defaultRingtoneUri =
            RingtoneManager.getActualDefaultRingtoneUri(activity, RingtoneManager.TYPE_RINGTONE)
        list[title] = defaultRingtoneUri.toString() // first add the default, to get back if select another


        while (cursor.moveToNext()) {
            val notificationTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            val notificationUri = manager.getRingtoneUri(cursor.position)
            list[notificationTitle] = notificationUri.toString()
        }
//         cursor.close();


        return list
    }

    private fun playMp3(myUri: String?): Void? {

            try {
                val myUri1 = Uri.parse(myUri)

                _ringtone = RingtoneManager.getRingtone(applicationContext, myUri1)

                _ringtone!!.play()
                return null
            } catch (e: Exception) {
                e.printStackTrace()
            }
        return null
    }

    private fun stopMp3(): Void?{
        _ringtone!!.stop()
        return null
    }
}
