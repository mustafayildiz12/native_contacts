import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_contacts/models/contact_models.dart';

class ContactService {
  //Yalnızca tek bir nesne üzerinden işlem yapılır.
  static final ContactService _singleton = ContactService._internal();

  ContactService._internal();

  factory ContactService() {
    return _singleton;
  }

  // initial methodCannel variable
  static const platform = MethodChannel('example.com/channel');

/*
  Future<bool> getPermissionResult() async {
    bool data = await platform.invokeMethod('contactPermission');

    return data;
  }

 */
  // fetch contacts from native kotlin
  Future<List<ContactsModel>> fetchContacts() async {
    try {
      // call invoke method
      // method name must be same
      var data = await platform.invokeMethod('getContacts');

      List<ContactsModel> contacts = [];

      /// there is one little trick here
      /// we are getting conctact from kotlin as Contact model type
      /// but invoke method returns Object;
      /// to conver our Objects to [ContactsModel]
      /// we have to seperate objects and
      /// get their id,name,number one by one.
      /// Then we just need to add contact to [contacts] list.

      for (var item in data) {
        ContactsModel contact = ContactsModel(
            id: item['id'], name: item['name'], number: item['number']);

        contacts.add(contact);

        /// its sorting operation depends on
        /// contact id.It is not necessary but
        /// it seems better on ui (My think)
        contacts.sort((a, b) {
          int firstId = int.parse(a.id.toString());
          int secondId = int.parse(b.id.toString());

          return firstId.compareTo(secondId);
        });
      }

      /// After getting contacts one by one
      /// we just need to set [reveivedContacts]

      return contacts;
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return [];
    }
  }
}

ContactService contactService = ContactService();
