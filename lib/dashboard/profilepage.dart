import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          const SizedBox(height: 150),
          Column(
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

                  },
                  child: Text('Change Password'))
            ],
          ),
          const SizedBox(height: 120),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'HRD APP',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    'v.1.0 beta',
                    style: TextStyle(color: Colors.black54),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
