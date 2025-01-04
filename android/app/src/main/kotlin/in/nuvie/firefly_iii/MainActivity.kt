package `in`.nuvie.firefly_iii

import io.flutter.embedding.android.FlutterActivity
import android.database.Cursor
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "in.nuvie.firefly_iii/sms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSms") {
                val smsList = getSms()
                result.success(smsList)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSms(): List<Map<String, String>> {
        val smsList = mutableListOf<Map<String, String>>()
        val uri: Uri = Uri.parse("content://sms/inbox")
        val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)

        if (cursor != null) {
            while (cursor.moveToNext()) {
                val address = cursor.getString(cursor.getColumnIndexOrThrow("address"))
                val body = cursor.getString(cursor.getColumnIndexOrThrow("body"))
                val date = cursor.getString(cursor.getColumnIndexOrThrow("date"))

                val sms = mapOf("address" to address, "body" to body, "date" to date)
                smsList.add(sms)
            }
            cursor.close()
        }
        return smsList
    }
}  
