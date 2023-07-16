package com.example.native_contacts

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.provider.ContactsContract
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    @SuppressLint("Range", "SuspiciousIndentation")
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "example.com/channel").setMethodCallHandler {
                call, result ->
            if(call.method == "getContacts") {
                /// Check Contact Permission
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.READ_CONTACTS),
                        0
                    )
                } else {

                 var contacts = getNamePhoneDetails();
                    println(contacts)

                    /// distincBy filter the list and not let to add same contact again
                    /// also convert contacts to map to catch easily in flutter as a
                    val contactMaps = contacts.distinctBy { it.name }.map { it.toMap() }

                    result.success(contactMaps)
                }

            }
            else {
                result.notImplemented()
            }
        }
    }
    @SuppressLint("Range")
    fun getNamePhoneDetails(): MutableList<Contact> {

        val contacts = mutableListOf<Contact>()
        val cr = contentResolver
        val cur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,
            null, null, null)
        if (cur!!.count > 0) {
            while (cur.moveToNext()) {
                val id = cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NAME_RAW_CONTACT_ID))
                val name = cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME))
                val number = cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER))
                contacts.add(Contact(id,name,number))
            }

        }

        return contacts
    }
}

data class Contact(val id: String, val name: String, val number: String) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "id" to id,
            "name" to name,
            "number" to number
        )
    }

}
