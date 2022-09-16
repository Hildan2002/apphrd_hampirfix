import 'package:aplikasi_hrd/request/detailcuti.dart';
import 'package:aplikasi_hrd/request/overtime_approve.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OvertimeView extends StatelessWidget {
  const OvertimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> overtimeform = FirebaseFirestore.instance.collection('overtime').where('stepid', isEqualTo: user.email).snapshots();
    final Stream<QuerySnapshot> cutiform = FirebaseFirestore.instance.collection('cuti').where('stepid', isEqualTo: user.email).snapshots();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Center(
              child: Text('Inbox',
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
                  text: 'Overtime',
                  icon: Icon(
                    Icons.more_time_sharp,
                    color: Colors.white,
                  ),
                  iconMargin: EdgeInsets.only(bottom: 10.0),
                ),
                //child: Image.asset('images/android.png'),

                Tab(
                  text: 'Cuti',
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                  ),
                  iconMargin: EdgeInsets.only(bottom: 10.0),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: overtimeform,
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (streamSnapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
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
                  Expanded(
                    child: StreamBuilder(
                      stream: cutiform,
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (streamSnapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        if (streamSnapshot.hasData ) {
                          return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                              return Card(
                                margin: const EdgeInsets.all(5),
                                child: ListTile(
                                  title: Text(documentSnapshot['nama_pengaju'].toString()),
                                  subtitle: Text(documentSnapshot['keterangan']),
                                  trailing: Text("${documentSnapshot['tanggal']}"),
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
              // Column(
              //   children: [
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
              //     Expanded(
              //       child: StreamBuilder(
              //         stream: _cutiform,
              //         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              //           if (streamSnapshot.hasError) {
              //             return Text('Something went wrong');
              //           }
              //           if (streamSnapshot.connectionState == ConnectionState.waiting) {
              //             return Text("Loading");
              //           }
              //           if (streamSnapshot.hasData ) {
              //             return ListView.builder(
              //               itemCount: streamSnapshot.data!.docs.length,
              //               itemBuilder: (context, index) {
              //                 final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
              //                 return Card(
              //                   margin: const EdgeInsets.all(5),
              //                   child: ListTile(
              //                     title: Text(documentSnapshot['nik']),
              //                     subtitle: Text(documentSnapshot['nik']),
              //                     trailing: Text((documentSnapshot['nik'])),
              //                     onTap: (){
              //                       var id = documentSnapshot['idtime'];
              //                       Navigator.push(context
              //                           ,MaterialPageRoute(builder: (context) =>  Cutidetail(timestamp: id)));
              //                     },
              //                   ),
              //                 );
              //               },
              //             );
              //           }
              //
              //           return const Center(
              //             child: CircularProgressIndicator(),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),

            ],
          ),
        ),
    );
  }
}
