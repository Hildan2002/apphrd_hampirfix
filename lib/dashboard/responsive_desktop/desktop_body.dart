import 'package:aplikasi_hrd/dashboard/constant.dart';
import 'package:aplikasi_hrd/dashboard/profilepage.dart';
import 'package:aplikasi_hrd/dashboard/responsive_desktop/calendar.dart';
import 'package:aplikasi_hrd/request/cuti_form.dart';
import 'package:aplikasi_hrd/request/cuti_qusus.dart';
import 'package:aplikasi_hrd/request/export_excel.dart';
import 'package:aplikasi_hrd/request/history.dart';
import 'package:aplikasi_hrd/request/overtime_form.dart';
import 'package:aplikasi_hrd/request/request_message.dart';
import 'package:aplikasi_hrd/request/ujicoba.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}



class _DesktopScaffoldState extends State<DesktopScaffold> {

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> notif = FirebaseFirestore.instance.collection('overtime').where('stepid', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> notif1 = FirebaseFirestore.instance.collection('cuti').where('stepid', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> notif2 = FirebaseFirestore.instance.collection('inventaris').where('stepid', isEqualTo: user.email).snapshots();

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            Drawer(
              backgroundColor: Colors.grey[300],
              elevation: 0,
              child: Column(
                children: [
                  const DrawerHeader(
                    child: Icon(
                      Icons.favorite,
                      size: 64,
                    ),
                  ),
                  // Padding(
                  //   padding: tilePadding,
                  //   child: ListTile(
                  //     leading: Icon(Icons.home),
                  //     title: Text(
                  //       'D A S H B O A R D',
                  //       style: drawerTextColor,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: tilePadding,
                  //   child: ListTile(
                  //     leading: Icon(Icons.settings),
                  //     title: Text(
                  //       'S E T T I N G S',
                  //       style: drawerTextColor,
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: (){
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => const UjiCoba())
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: tilePadding,
                  //     child: ListTile(
                  //       leading: const Icon(Icons.person_outlined),
                  //       title: Text(
                  //         'Upload',
                  //         style: drawerTextColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePassword())
                      );
                    },
                    child: Padding(
                      padding: tilePadding,
                      child: ListTile(
                        leading: const Icon(Icons.person_outlined),
                        title: Text(
                          'P R O F I L',
                          style: drawerTextColor,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryPage())
                      );
                    },
                    child: Padding(
                      padding: tilePadding,
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(
                          'H I S T O R Y',
                          style: drawerTextColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: tilePadding,
                    child: ListTile(
                      onTap: (){
                        _signOut();
                      },
                      leading: const Icon(Icons.logout),
                      title: Text(
                        'L O G O U T',
                        style: drawerTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // first half of page
            Expanded(
              flex: 2,
              child: Column(
                children: [
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
                          child: const CardFolderDesktop(
                            image: Icon(Icons.more_time_sharp, size: 25,),
                            title: "Overtime",
                            date: "Request Overtime",
                            color: Color(0xFF415EB6),
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text("Loading");
                              }
                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return const Text("Document does not exist");
                              }
                              if(snapshot.data!['cuti'] == 'khusus') {
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  const RequestCutiQusus())
                                    );
                                  },
                                  child: const CardFolderDesktop(
                                    image: Icon(Icons.card_travel, size: 25,),
                                    title: "Off Work",
                                    date: "Tombol Form Cuti",
                                    color: Color(0xFFFFB110),
                                  ),
                                );
                              }
                              else{
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  const RequestCuti())
                                    );
                                  },
                                  child: const CardFolderDesktop(
                                    image: Icon(Icons.card_travel, size: 25,),
                                    title: "Off Work",
                                    date: "Tombol Form Cuti",
                                    color: Color(0xFFFFB110),
                                  ),
                                );
                              }

                          }
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>const OvertimeView())
                            );
                          },
                          child: const CardFolderDesktop(
                            image: Icon(Icons.inventory),
                            title: "Pesan",
                            date: "kotak pesan",
                            color: Color(0xFFAC4040),
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }
                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return const Text("Document does not exist");
                              }
                              if (snapshot.data!['role'] == 'admin') {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (
                                            context) => const ExportExel())
                                    );
                                  },
                                  child: const CardFolderDesktop(
                                    image: Icon(Icons.inbox, size: 25,),
                                    // image: Image.asset("assets/icons/folder-23B0B0.png"),
                                    title: "Inbox",
                                    date: "Inbox Request",
                                    color: Color(0xFF23B0B0),
                                  ),
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  ElegantNotification.error(
                                    title: const Text('Forbidden'),
                                    description: const Text('Menu Ini Hanya DIperuntukkan Untuk Admin'),
                                    notificationPosition: NotificationPosition.top,
                                    dismissible: true,
                                  ).show(context);
                                },
                                child: const CardFolderDesktop(
                                  image: Icon(Icons.inbox, size: 25,),
                                  // image: Image.asset("assets/icons/folder-23B0B0.png"),
                                  title: "Inbox",
                                  date: "Inbox Request",
                                  color: Color(0xFF23B0B0),
                                ),
                              );
                            }
                        ),
                      ],
                    ),

                  ),

                  const SizedBox(height: 20),
                  // Expanded(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         Text('Inbox',
                  //           textAlign: TextAlign.start,
                  //           style: TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //           ),),
                  //         // StreamBuilder(
                  //         //   stream: _overtimeform,
                  //         //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  //         //     if (streamSnapshot.hasError) {
                  //         //       return Container(
                  //         //         margin: const EdgeInsets.all(10),
                  //         //         decoration: BoxDecoration(
                  //         //             color: Colors.grey[350],
                  //         //             borderRadius: BorderRadius.circular(15)
                  //         //         ),
                  //         //         child: const ListTile(
                  //         //             title: Text('Belum Ada Pesan')),
                  //         //       );
                  //         //     }
                  //         //     if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  //         //       return const Text("Loading");
                  //         //     }
                  //         //     if (streamSnapshot.hasData ) {
                  //         //       return ListView.builder(
                  //         //         itemCount: streamSnapshot.data!.docs.length,
                  //         //         itemBuilder: (context, index) {
                  //         //           final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  //         //           return Container(
                  //         //             margin: const EdgeInsets.all(10),
                  //         //             decoration: BoxDecoration(
                  //         //                 color: Colors.grey[350],
                  //         //                 borderRadius: BorderRadius.circular(15)
                  //         //             ),
                  //         //             child: Card(
                  //         //               margin: const EdgeInsets.all(5),
                  //         //               child: ListTile(
                  //         //                 title: Text(documentSnapshot['section'].toString()),
                  //         //                 subtitle: Text(documentSnapshot['name_pic']),
                  //         //                 trailing: Text(documentSnapshot['tanggal']),
                  //         //                 onTap: (){
                  //         //                   var id = documentSnapshot['idtime'];
                  //         //                   Navigator.push(context
                  //         //                       ,MaterialPageRoute(builder: (context) =>  Overtimeinside(timestamp: id)));
                  //         //                 },
                  //         //               ),
                  //         //             ),
                  //         //           );
                  //         //         },
                  //         //       );
                  //         //     }
                  //         //
                  //         //     return const Center(
                  //         //       child: Text('Belum Ada Permintaan'),
                  //         //     );
                  //         //   },
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // second half of page
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(80),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                                return const Text('loading');
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
                                    textAlign: TextAlign.center,
                                  ),
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
                                                fontSize: 15,
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
                                              style: TextStyle(
                                                color: const Color(0xFF22215B).withOpacity(0.6),
                                                fontSize: 16,
                                              ),
                                            );
                                          }
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: notif2,
                                          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                            if(streamSnapshot.hasData && streamSnapshot.data!.docs.isEmpty){
                                              return const Text('Belum Ada Permintaan Inventaris',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 1,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                            return Text(
                                              "Ada permintaan Inventaris ${streamSnapshot.data?.docs.length}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFF22215B).withOpacity(0.6),
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
                  // list of stuff
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CalendarWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardFolderDesktop extends StatelessWidget {
  const CardFolderDesktop({
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
      width: Get.width * 0.12,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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


