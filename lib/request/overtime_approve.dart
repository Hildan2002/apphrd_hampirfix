import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class Overtimeinside extends StatelessWidget {

  void sendPushMessage(String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAmZ3YQms:APA91bFMbsTBWRlN6Taf3jZQrpri3hOBk8v2jjKFVGkR-KMIbmUb2sXN19HtX5VP30Oac_KkEzzht1ewhq6ksX2kjNTLLRiThYY54eY9jVC4YSBGjdf7YPhr5JtOiBGOrcroI11nxsGV',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Request Baru',
              'title': 'Anda mendapat request baru'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  final Timestamp timestamp;


  const Overtimeinside({Key? key, required this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? periksa2;
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> _overtimeform = FirebaseFirestore.instance.collection('overtime').where("idtime", isEqualTo: timestamp).snapshots();

    switch(user.email){
      case 'ayuandini@0916.nsi':
        periksa2 = 'Approve';
        break;
      case 'yuki@takahashi.nsi':
      case 'adi@0947.nsi':
      case 'widodo@0368.nsi':
        periksa2 = 'ayuandini@0916.nsi';
        break;
      case 'rohmad@0167.nsi'  :
      case  'samsu@0012.nsi' :
      case 'cep@0178.nsi'  :
        periksa2 = 'widodo@0368.nsi';
        break;
      case 'harlan@0693.nsi':
        periksa2 = 'yuki@takahashi.nsi';
        break;
      case 'sumadi@0068.nsi':
      case 'dedi@0519.nsi':
      case 'yana@0175.nsi':
        periksa2 = 'adi@0947.nsi';
        break;
      default :
        periksa2 = 'error';
    }
    debugPrint(periksa2);



    Future<void> _update([DocumentSnapshot? documentSnapshot]) async{
      await FirebaseFirestore.instance.collection('overtime').doc(documentSnapshot!.id).update({'stepid' : periksa2});
    }
    Future<void> _updateT([DocumentSnapshot? documentSnapshot]) async{
      await FirebaseFirestore.instance.collection('overtime').doc(documentSnapshot!.id).update({'stepid' : 'tolak', 'proses' : 'done'});
    }


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme : ThemeData.light().copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme)
        ),
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.black,
            title: Center(
              child: Text('Message Overtime',
                  textAlign: TextAlign.center),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _overtimeform,
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (streamSnapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                          final alamat = documentSnapshot['email'];
                          var peserta = documentSnapshot['peserta'];
                          var daftarPeserta = "Daftar Peserta Lembur:";
                          peserta.forEach((item){
                            daftarPeserta = daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal'] + " hingga pukul " + item['jamkhir'];

                          });
                          var tanggal = documentSnapshot['tanggal'];
                          return Column(
                            children: [
                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child:ListTile(
                                            title: Text(documentSnapshot['email'].toString()),
                                            subtitle: Text('Form ini Dikirim Oleh'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child:ListTile(
                                            title: Text(documentSnapshot['name_pic'].toString()),
                                            subtitle: Text('nama yang bertanggung jawab'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child:ListTile(
                                            title: Text(tanggal.substring(0,10)),
                                            subtitle: Text('tanggal'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child:ListTile(
                                            title: Text(documentSnapshot['shift'].toString()),
                                            subtitle: Text('shift'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child:ListTile(
                                            title: Text(documentSnapshot['section'].toString()),
                                            subtitle: Text('Department'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child:ListTile(
                                            title: Text(daftarPeserta),
                                            subtitle: Text('karyawan'),
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _updateT(documentSnapshot);
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .where("email", isEqualTo: alamat)
                                            .get().then(
                                                (QuerySnapshot snapshot) => {
                                              if(snapshot.docs.isNotEmpty){
                                                sendPushMessage((snapshot.docs.first.data() as Map)["tokens"]),
                                                debugPrint((snapshot.docs.first.data() as Map)["tokens"])
                                              }
                                            });
                                        ElegantNotification.success(
                                          title: Text('Berhasil'),
                                          description: Text('Anda Berhasil menolak request overtime'),
                                          notificationPosition: NotificationPosition.top,
                                          dismissible: true,
                                        ).show(context);

                                        Navigator.pop(context);
                                      },
                                      child: const Text('Tolak')),

                                  ElevatedButton(
                                      onPressed: () {
                                        _update(documentSnapshot);
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .where("email", isEqualTo: periksa2)
                                            .get().then(
                                                (QuerySnapshot snapshot) => {
                                              if(snapshot.docs.isNotEmpty){
                                                sendPushMessage((snapshot.docs.first.data() as Map)["tokens"]),
                                                debugPrint((snapshot.docs.first.data() as Map)["tokens"])
                                              }
                                            });
                                        ElegantNotification.success(
                                          title: Text('Berhasil'),
                                          description: Text('Anda Berhasil menyetujui request overtime'),
                                          notificationPosition: NotificationPosition.top,
                                          dismissible: true,
                                        ).show(context);
                                      },
                                      child: const Text('Approve')),
                                ],
                              ),
                            ],
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
        )
    );
  }
}
