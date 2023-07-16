import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_contacts/models/contact_models.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    super.key,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // initial methodCannel variable
  static const platform = MethodChannel('example.com/channel');

  // initial contact list
  List<ContactsModel> reveivedContacts = [];

  // fetch contacts from native kotlin
  Future<void> fetchContacts() async {
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
      setState(() {
        reveivedContacts = contacts;
      });
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  void initState() {
    fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Contacts"),
        ),
        body: ListView.builder(
            itemCount: reveivedContacts.length,
            itemBuilder: (context, index) {
              ContactsModel contact = reveivedContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(contact.id.toString(),
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text(
                  reveivedContacts[index].name.toString(),
                ),
                subtitle: Text(reveivedContacts[index].number ?? ''),
              );
            })
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
