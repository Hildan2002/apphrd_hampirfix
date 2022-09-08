import 'package:aplikasi_hrd/dashboard/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../util/my_box.dart';
import '../util/my_tile.dart';

// Future<void> saveTokenToDatabase(String token) async {
//   // Assume user is logged in for this example
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .update({
//     'tokens': FieldValue.arrayUnion([token]),
//   });
// }

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  // Future<void> setupToken() async {
  //   // Get the token each time the application loads
  //   String? token = await FirebaseMessaging.instance.getToken();
  //
  //   // Save the initial token to the database
  //   await saveTokenToDatabase(token!);
  //
  //   // Any time the token refreshes, store this in the database too.
  //   FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  //   print("Token: ${token} berhasil disimpan");
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   setupToken();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // first 4 boxes in grid
            AspectRatio(
              aspectRatio: 4,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return MyBox();
                  },
                ),
              ),
            ),

            // list of previous days
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const MyTile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
