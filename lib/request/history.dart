import 'dart:developer';
import 'package:aplikasi_hrd/request/detailcuti.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:aplikasi_hrd/request/overtime_approve.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;
    final step = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final Stream<QuerySnapshot> _overtimeform = FirebaseFirestore.instance.collection('overtime').where('email', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> _cutiform = FirebaseFirestore.instance.collection('overtime').where('stepid', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> _overtimeformv = FirebaseFirestore.instance.collection('overtime').where('stepid1', isEqualTo: user.email).snapshots();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
            child: Text('History',
                textAlign: TextAlign.start),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.lime,
            indicatorWeight: 5.0,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.only(top: 10.0),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Progress',
                icon: Icon(
                  Icons.more_time_sharp,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
              //child: Image.asset('images/android.png'),

              Tab(
                text: 'Disetujui',
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),
              Tab(
                text: 'Ditolak',
                icon: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),

            ],
          ),
        ),
        body: SingleChildScrollView(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: StreamBuilder(
                      stream: _overtimeform,
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (streamSnapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        if (streamSnapshot.hasData ) {
                          return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                              return Card(
                                margin: const EdgeInsets.all(5),
                                child: ListTile(
                                  title: Text(documentSnapshot['section'].toString()),
                                  subtitle: Text(documentSnapshot['name_pic']),
                                  trailing: Text(documentSnapshot['tanggal']),
                                  onTap: (){
                                    var id = documentSnapshot['idtime'];
                                    Navigator.push(context
                                        ,MaterialPageRoute(builder: (context) =>  Overtimeinside(timestamp: id)));
                                  },
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  // StreamBuilder(
                  //   stream: _overtimeformv,
                  //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  //     if (streamSnapshot.hasError) {
                  //       return Text('nothing',
                  //       style: TextStyle(
                  //         color: Colors.white
                  //       ),);
                  //     }
                  //     if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  //       return Text("Loading");
                  //     }
                  //     if (streamSnapshot.hasData ) {
                  //       return ListView.builder(
                  //         itemCount: streamSnapshot.data!.docs.length,
                  //         itemBuilder: (context, index) {
                  //           final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  //           return Card(
                  //             margin: const EdgeInsets.all(5),
                  //             child: ListTile(
                  //               title: Text(documentSnapshot['section'].toString()),
                  //               subtitle: Text(documentSnapshot['name_pic']),
                  //               trailing: Text(documentSnapshot['tanggal']),
                  //               onTap: (){
                  //                 var id = documentSnapshot['idtime'];
                  //                 Navigator.push(context
                  //                     ,MaterialPageRoute(builder: (context) =>  Overtimeinside(timestamp: id)));
                  //               },
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     }
                  //
                  //     return const Center(
                  //       child: CircularProgressIndicator(),
                  //     );
                  //   },
                  // ),
                  Expanded(
                    child: StreamBuilder(
                      stream: _cutiform,
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (streamSnapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        if (streamSnapshot.hasData ) {
                          return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                              return Card(
                                margin: const EdgeInsets.all(5),
                                child: ListTile(
                                  title: Text(documentSnapshot['section'].toString()),
                                  subtitle: Text(documentSnapshot['name_pic']),
                                  trailing: Text(documentSnapshot['tanggal']),
                                  onTap: (){
                                    var id = documentSnapshot['idtime'];
                                    Navigator.push(context
                                        ,MaterialPageRoute(builder: (context) =>  Cutidetail(timestamp: id)));
                                  },
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
