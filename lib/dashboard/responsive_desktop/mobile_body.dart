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
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }
    final user = FirebaseAuth.instance.currentUser!;

    final Stream<QuerySnapshot> notif = FirebaseFirestore.instance.collection('overtime').where('stepid', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> notif1 = FirebaseFirestore.instance.collection('cuti').where('stepid', isEqualTo: user.email).snapshots();
    // final Stream<QuerySnapshot> _notif2 = FirebaseFirestore.instance.collection('inventaris').where('stepid', isEqualTo: user.email).snapshots();

    return Scaffold(
      backgroundColor: Color(0xFFF1f1f1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF1f1f1),
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Color(0xFF22215B),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              _signOut();
              },
            icon: Icon(
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
            margin: EdgeInsets.symmetric(horizontal: 25),
            padding: EdgeInsets.all(25),
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
                      return Text('loading');
                    }
                    return Column(
                      children: [
                        // Container(
                        //   width: 75,
                        //   height: 75,
                        // ),
                        SizedBox(height: 15),
                        Text(
                          snapshot.data!['nama'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF22215B),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data!['nik'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: notif,
                              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if(streamSnapshot.hasData && streamSnapshot.data?.docs.length == 0){
                                  return Text('Belum Ada Permintaan Lembur',
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
                                  style: TextStyle(
                                    color: Color(0xFF22215B),
                                    fontSize: 16,
                                  ),
                                );
                              }
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: notif1,
                                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                  if(streamSnapshot.hasData && streamSnapshot.data?.docs.length == 0){
                                    return Text('Belum Ada Permintaan Cuti',
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
                                    style: TextStyle(
                                      color: Color(0xFF22215B).withOpacity(0.6),
                                      fontSize: 16,
                                    ),
                                  );
                                }
                            ),
                            // StreamBuilder<QuerySnapshot>(
                            //     stream: _notif2,
                            //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            //       if(streamSnapshot.hasData && streamSnapshot.data?.docs.length == 0){
                            //         return Text('Belum Ada Permintaan Inventaris',
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             fontSize: 1,
                            //               color: Colors.white,
                            //           ),
                            //         );
                            //       }
                            //       return Text(
                            //         "Ada permintaan Inventaris ${streamSnapshot.data?.docs.length}",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           color: Color(0xFF22215B).withOpacity(0.6),
                            //           fontSize: 16,
                            //         ),
                            //       );
                            //     }
                            // ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestOvertime())
                    );
                  },
                  child: CardFolder(
                    image: const Icon(Icons.more_time_sharp, size: 25,),
                    title: "Overtime",
                    date: "Request Overtime",
                    color: Color(0xFF415EB6),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }
                    if(snapshot.data!['cuti'] == 'khusus') {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RequestCutiQusus()));
                          },
                          child: CardFolder(
                            image: const Icon(
                              Icons.card_travel,
                              size: 25,
                            ),
                            title: "Cuti",
                            date: "Tombol Formulit Cuti",
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
                        child: CardFolder(
                          image: const Icon(
                            Icons.card_travel,
                            size: 25,
                          ),
                          title: "Cuti",
                          date: "Tombol Formulit Cuti",
                          color: Color(0xFFFFB110),
                        ),
                      );
                    }
                  }
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
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
                  child: CardFolder(
                    image: const Icon(Icons.inventory),
                    title: "Pesan",
                    date: "Pesanan Masuk",
                    color: Color(0xFFAC4040),
                  ),
                ),

                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }
                      if(snapshot.data!['role'] == 'admin') {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ExportExel())
                            );
                          },
                          child: CardFolder(
                            image: const Icon(Icons.inbox, size: 25,),
                            // image: Image.asset("assets/icons/folder-23B0B0.png"),
                            title: "Inbox",
                            date: "Inbox Request",
                            color: Color(0xFF23B0B0),
                          ),
                        );
                      }
                      else{
                        return InkWell(
                          onTap: () {
                            ElegantNotification.error(
                              title: Text('Forbidden'),
                              description: Text('Menu Ini Hanya DIperuntukkan Untuk Admin'),
                              notificationPosition: NotificationPosition.top,
                              dismissible: true,
                            ).show(context);
                          },
                          child: CardFolder(
                            image: const Icon(Icons.inbox, size: 25,),
                            // image: Image.asset("assets/icons/folder-23B0B0.png"),
                            title: "Inbox",
                            date: "Inbox Request",
                            color: Color(0xFF23B0B0),
                          ),
                        );
                      }
                    }
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
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
          SizedBox(height: 10),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage())
              );
            },
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
              ),
              title: Text("Progress"),
              subtitle: Text("Menu untuk melihat progress pengajuan cuti"),
              trailing: Icon(Icons.history),
            ),
          ),
        ],
      ),
    );
  }
}

class CardFolder extends StatelessWidget {
  CardFolder({
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
      padding: EdgeInsets.all(15),
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
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 5),
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
