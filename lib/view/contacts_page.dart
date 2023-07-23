import 'package:flutter/material.dart';
import 'package:native_contacts/models/contact_models.dart';
import 'package:native_contacts/service/contact_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    super.key,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // initial contact list
  List<ContactsModel> reveivedContacts = [];

  @override
  void initState() {
    getPageData();
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

  Future<void> getPageData() async {
    final PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      List<ContactsModel> fetchContacts = await contactService.fetchContacts();
      setState(() {
        reveivedContacts = fetchContacts;
      });
    } else {
      print("İzin Alınamadı.");
    }
  }
}
