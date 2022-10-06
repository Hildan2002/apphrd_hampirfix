import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'responsive_desktop/desktop_body.dart';
import 'responsive_desktop/mobile_body.dart';
import 'responsive_desktop/responsive layout.dart';
import 'responsive_desktop/tablet_body.dart';

Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({
    'tokens': token,
  });
}

class DashboardFilter extends StatefulWidget {
  const DashboardFilter({Key? key}) : super(key: key);

  @override
  State<DashboardFilter> createState() => _DashboardFilterState();
}

class _DashboardFilterState extends State<DashboardFilter> {

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken(vapidKey: 'BO4U3Qzh7Masot9WGLIpirfJEi4PFzLNxR6yuZe-hQpOfMXkG9eAEh807H781H4qEE2wnmnF0M_vOxqeZF5rY38');

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    print("Token: ${token} berhasil disimpan");
  }

  @override
  void initState() {
    super.initState();

    setupToken();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      ),
    );
  }
}