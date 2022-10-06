import 'package:aplikasi_hrd/constant/const_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var usernameController = TextEditingController();
    var passwordController = TextEditingController();

    Future signIn() async{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: '${usernameController.text.trim().toLowerCase()}.nsi',
            password: passwordController.text.trim(),
        );
      }
      on FirebaseAuthException catch (e) {
        // print(e);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: Text(e.message.toString()),
              );
            });
      }
    }


    return Form(
        child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your username",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value){
                  signIn();
                },
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "Your password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Hero(
              tag: "login_btn",
              child: ElevatedButton(
                onPressed: signIn,
                child: Text(
                  "Login".toUpperCase(),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
          TextButton(
              onPressed: () async {
                const url = 'https://drive.google.com/file/d/1hM5O6EkRzLvvhKYtSnIsG6XL98rdNVvu/view?usp=sharing';
                if (await canLaunchUrlString(url)){
                  await launchUrlString(url);
                } else {
                  throw 'error';
                }
              },
              child: const Text("Download WI")
          ),
          ],
        ),
      );
  }
}
