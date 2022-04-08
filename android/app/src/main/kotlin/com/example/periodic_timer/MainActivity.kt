package com.example.periodic_timer

import android.content.Context
import android.database.Cursor
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

class MainActivity: FlutterActivity() {
    private val channel1 = "com.example.periodic_timer1"
    private val channel2 = "com.example.periodic_timer2"
    private val channel3 = "com.example.periodic_timer3"
var _ringtone: Ringtone? = null;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, channel1)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAllRingtones" -> {
                        result.success(getAllRingtones(this))
                    }
                }


// add this method to handle the calls from flutter

            }
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, channel2)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "playRingtones" -> {
                        result.success(playMp3(myUri =  call.argument<String>("text")))
                    }
                }


// add this method to handle the calls from flutter

            }
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, channel3)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "stopRingtone" -> {
                        result.success(stopMp3())
                    }
                }


// add this method to handle the calls from flutter

            }

    }
    private fun getAllRingtones(context: Context): List<String> {

        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)

        val cursor: Cursor = manager.cursor

        val list: MutableList<String> = mutableListOf()

            val notificationTitle: Uri = manager.getRingtoneUri(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(notificationTitle.toString())

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
