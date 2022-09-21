import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _PasswordlamaController = TextEditingController();
  final _PasswordbaruController = TextEditingController();

  @override
  void dispose() {
    _PasswordlamaController.dispose();
    _PasswordbaruController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _PasswordlamaController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password Lama',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _PasswordbaruController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password Baru',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(EmailAuthProvider.credential(email: FirebaseAuth.instance.currentUser!.email.toString(), password: _PasswordlamaController.text))
                          .then((value){
                        FirebaseAuth.instance.currentUser!.updatePassword(_PasswordbaruController.text);
                        FirebaseAuth.instance.signOut();
                      });
                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'password' : _PasswordbaruController});

                    },
                    child: Text('Change Password'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
