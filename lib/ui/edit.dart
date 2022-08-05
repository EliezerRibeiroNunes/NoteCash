import 'package:app/ui/home_page.dart';
import 'package:flutter/material.dart';

import '../helpers/controller.dart';

class RegistryEdit extends StatefulWidget {
 final Contact contact;

  const RegistryEdit({Key key, this.contact}) : super(key: key);


  @override
  createState() => _RegistryEditState();
}

class _RegistryEditState extends State<RegistryEdit> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  // ignore: unused_field
  bool _registryEdited = false;
  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact != null ) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('CashNote'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_editedContact.name != null && _editedContact.name.isNotEmpty){
            Navigator.pop(context, _editedContact);
          }else {
                FocusScope.of(context).requestFocus(_nameFocus);
          }

        },

        backgroundColor: Colors.blue,
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //GestureDetector(
            //child: Container(
            //width: 140.0,
            //height:  140.0,
            //decoration: BoxDecoration(
            //shape: BoxShape.circle,
            //image: DecorationImage(
            //image: _editedContact.img != null ?
            // FileImage(File(_editedContact.img)) :
            //const AssetImage("assets/images/comprovante.png") as ImageProvider

            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: const InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _registryEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _registryEdited = true;

                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),

            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Valor"),
              onChanged: (text) {
                _registryEdited = true;
                _editedContact.phone = text;
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'CashNote',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
