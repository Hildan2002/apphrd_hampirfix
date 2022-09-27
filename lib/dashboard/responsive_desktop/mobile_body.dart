import 'package:aplikasi_hrd/dashboard/profilepage.dart';
import 'package:aplikasi_hrd/request/cuti_form.dart';
import 'package:aplikasi_hrd/request/cuti_qusus.dart';
import 'package:aplikasi_hrd/request/export_excel.dart';
import 'package:aplikasi_hrd/request/history.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasi_hrd/request/overtime_form.dart';
import 'package:aplikasi_hrd/request/request_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
    }
    final user = FirebaseAuth.instance.currentUser!;

    final Stream<QuerySnapshot> notif = FirebaseFirestore.instance.collection('overtime').where('stepid', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> notif1 = FirebaseFirestore.instance.collection('cuti').where('stepid', isEqualTo: user.email).snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFFF1f1f1),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePassword()),
              );
            },
            icon: const Icon(Icons.lock, color: Colors.black)),
        backgroundColor: const Color(0xFFF1f1f1),
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Color(0xFF22215B),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              signOut();
              },
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF22215B),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if(snapshot.hasError){
                      return Text('Error : ${snapshot.error}');
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        // Container(
                        //   width: 75,
                        //   height: 75,
                        // ),
                        const SizedBox(height: 15),
                        Text(
                          snapshot.data!['nama'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF22215B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          snapshot.data!['nik'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: notif,
                              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if(streamSnapshot.hasData && streamSnapshot.data!.docs.isEmpty){
                                  return const Text('Belum Ada Permintaan Lembur',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 1,
                                    color: Colors.white
                                  ),
                                  );
                                }
                                return Text(
                                  "Ada Permintaan Lembur ${streamSnapshot.data?.docs.length}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF22215B),
                                    fontSize: 16,
                                  ),
                                );
                              }
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: notif1,
                                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                  if(streamSnapshot.hasData && streamSnapshot.data!.docs.isEmpty){
                                    return const Text('Belum Ada Permintaan Cuti',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 1,
                                          color: Colors.white
                                      ),
                                    );
                                  }
                                  return Text(
                                    "Ada Permintaan Cuti ${streamSnapshot.data?.docs.length}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF22215B),
                                      fontSize: 16,
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      if(snapshot.data!['lembur'] == 'khusus') {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RequestOvertime())
                            );
                          },
                          child: const CardFolder(
                            image: Icon(Icons.more_time_sharp, size: 25,),
                            title: "Lembur",
                            date: "Pengajuan Lembur",
                            color: Color(0xFF415EB6),
                          ),
                        );
                      }
                      else{
                        return InkWell(
                          onTap: () {
                            ElegantNotification.error(
                              title: const Text('Forbidden'),
                              description: const Text('Menu Ini Hanya DIperuntukkan Untuk Admin'),
                              notificationPosition: NotificationPosition.top,
                              // dismissible: true,
                            ).show(context);
                          },
                          child: const CardFolder(
                            image: Icon(Icons.inbox, size: 25,),
                            // image: Image.asset("assets/icons/folder-23B0B0.png"),
                            title: "Approval",
                            date: "Approved by HRD",
                            color: Color(0xFF23B0B0),
                          ),
                        );
                      }
                    }
                ),
                // InkWell(
                //   onTap: (){
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const RequestOvertime())
                //     );
                //   },
                //   child: const CardFolder(
                //     image: Icon(Icons.more_time_sharp, size: 25,),
                //     title: "Lembur",
                //     date: "Pengajuan Lembur",
                //     color: Color(0xFF415EB6),
                //   ),
                // ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    if(snapshot.data!['cuti'] == 'khusus') {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RequestCutiQusus()));
                          },
                          child: const CardFolder(
                            image: Icon(
                              Icons.card_travel,
                              size: 25,
                            ),
                            title: "Cuti",
                            date: "Pengajuan Cuti",
                            color: Color(0xFFFFB110),
                          ),
                        );
                      }
                    else{
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RequestCuti()));
                        },
                        child: const CardFolder(
                          image: Icon(
                            Icons.card_travel,
                            size: 25,
                          ),
                          title: "Cuti",
                          date: "Pengajuan Cuti",
                          color: Color(0xFFFFB110),
                        ),
                      );
                    }
                  }
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OvertimeView())
                    );
                  },
                  child: const CardFolder(
                    image: Icon(Icons.inventory),
                    title: "Permintaan",
                    date: "Permintaan Masuk",
                    color: Color(0xFFAC4040),
                  ),
                ),

                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      if(snapshot.data!['role'] == 'admin') {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ExportExel())
                            );
                          },
                          child: const CardFolder(
                            image: Icon(Icons.inbox, size: 25,),
                            // image: Image.asset("assets/icons/folder-23B0B0.png"),
                            title: "Approval",
                            date: "Approved by HRD",
                            color: Color(0xFF23B0B0),
                          ),
                        );
                      }
                      else{
                        return InkWell(
                          onTap: () {
                            ElegantNotification.error(
                              title: const Text('Forbidden'),
                              description: const Text('Menu Ini Hanya DIperuntukkan Untuk Admin'),
                              notificationPosition: NotificationPosition.top,
                              // dismissible: true,
                            ).show(context);
                          },
                          child: const CardFolder(
                            image: Icon(Icons.inbox, size: 25,),
                            // image: Image.asset("assets/icons/folder-23B0B0.png"),
                            title: "Approval",
                            date: "Approved by HRD",
                            color: Color(0xFF23B0B0),
                          ),
                        );
                      }
                    }
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Additional Menu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage())
              );
            },
            child: const ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
              ),
              title: Text("History"),
              subtitle: Text("Menu untuk melihat History pengajuan"),
              trailing: Icon(Icons.history),
            ),
          ),
        ],
      ),
    );
  }
}

class CardFolder extends StatelessWidget {
  const CardFolder({
    Key? key,
    required this.title,
    required this.date,
    required this.color,
    required this.image,
  }) : super(key: key);

  final String title;
  final String date;
  final Color color;
  final Icon image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: Get.width * 0.4,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image,
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

