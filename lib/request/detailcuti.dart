import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'cuti_form.dart';


class Cutidetail extends StatefulWidget {

  final Timestamp timestamp;

  const Cutidetail({Key? key, required this.timestamp}) : super(key: key);

  @override
  State<Cutidetail> createState() => _CutidetailState();
}

class _CutidetailState extends State<Cutidetail> {
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

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    String? periksa2;

    final user = FirebaseAuth.instance.currentUser!;

    // String? ururu;
    // FirebaseStorage.instance.ref().child("cuti/ayuandini@0916").getDownloadURL().then((value) {
    //   setState((){
    //     ururu = value;
    //   });
    // });
    final Stream<QuerySnapshot> cutiform = FirebaseFirestore.instance.collection('cuti').where("idtime", isEqualTo: widget.timestamp).snapshots();

    switch(user.email){
      case 'ayuandini@0916.nsi':
      case 'viola@0962.nsi':
        periksa2 = 'Approve@';
        break;
      case 'yuki@takahashi.nsi':
      case 'adi@0947.nsi':
      case 'widodo@0368.nsi':
      case 'yujiro@takeuchi' :
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
        periksa2 = 'Anda Belum Input Department@';
    }
    debugPrint(periksa2);

    Future<void> _updateT([DocumentSnapshot? documentSnapshot]) async{
      await FirebaseFirestore.instance.collection('cuti').doc(documentSnapshot!.id).update({'stepid' : 'tolak@', 'status' : 'done'});
      // await FirebaseFirestore.instance.collection('cuti').doc(documentSnapshot.id).update({'stepid1' : periksa3});
      Navigator.pop(context);
    }

    Future<void> _update([DocumentSnapshot? documentSnapshot]) async{
      await FirebaseFirestore.instance.collection('cuti').doc(documentSnapshot!.id).update({'stepid' : periksa2, 'status' : 'proses'});
      // await FirebaseFirestore.instance.collection('cuti').doc(documentSnapshot.id).update({'stepid1' : periksa3});
      Navigator.pop(context);
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
              child: Text('Message Cuti',
                  textAlign: TextAlign.center),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: cutiform,
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
                                            title: Text(documentSnapshot['nama_pengaju'].toString()),
                                            subtitle: Text('nama pengaju cuti'),
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
                                            title: Text(documentSnapshot['nik'].toString()),
                                            subtitle: Text('NIK'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    documentSnapshot['section'] == null && documentSnapshot['section'] == '' ? Container() :
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
                                            title: Text(documentSnapshot['keterangan'].toString()),
                                            subtitle: Text('Keterangan Cuti'),
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
                                            title: Text(documentSnapshot['jumlahhari']),
                                            subtitle: Text('Jumlah Hari Yang Diambil'),
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
                                            title: Text(formatCuti(documentSnapshot)),
                                            subtitle: Text('Jenis Cuti Yang Diambil'),
                                          ),
                                        ),
                                      ),
                                    ),

                                    documentSnapshot['bukti'] == null && documentSnapshot['bukti'] == '' ? Container()
                                        : GestureDetector(
                                         onTap: (){
                                           Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                                               Scaffold(
                                                 body: Center(
                                                   child: GestureDetector(
                                                     onTap: (){Navigator.pop(context);},
                                                     child: Hero(
                                                       tag: "nihBuktiNih",
                                                       child: Image.network(documentSnapshot['bukti']),
                                                     ),
                                                   ),
                                                 ),
                                               )
                                           ));
                                           },
                                          child: Hero(
                                           tag: "nihBuktiNih",
                                           child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(documentSnapshot['bukti'], fit: BoxFit.cover,)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text('Pesan Konfirmasi'),
                                                content: const Text('Apakah anda telah yakin untuk menolak permintaan ini?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, 'OK');
                                                      _updateT(documentSnapshot);
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
                                                        description: Text('Anda Berhasil menolak request cuti'),
                                                        notificationPosition: NotificationPosition.top,
                                                        dismissible: true,
                                                      ).show(context);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      child: const Text('Tolak')),

                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: const Text('Pesan Konfirmasi'),
                                              content: const Text('Apakah anda telah yakin untuk menyetujui permintaan ini?'),
                                              actions: <Widget>[
                                              TextButton(
                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, 'OK');
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
                                                      description: Text('Anda Berhasil menyetujui request cuti'),
                                                      notificationPosition: NotificationPosition.top,
                                                      dismissible: true,
                                                    ).show(context);
                                                  },
                                                  child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                      );
                                    },
                                    child: const Text('Approve')),],
                              )

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

  String formatCuti(DocumentSnapshot<Object?> documentSnapshot) {
    String a = "";
    if (documentSnapshot['cutitahunan'] != "")  a += "\nCuti Tahunan = ${documentSnapshot['cutitahunan']}";
    if (documentSnapshot['dispensasi'] != "")   a += "\nDispensasi = ${documentSnapshot['dispensasi']}";
    if (documentSnapshot['tidakupah'] != "")    a += "\nIzin Tidak Mendapatkan Upah = ${documentSnapshot['tidakupah']}";
    if (documentSnapshot['sakit'] != "")        a += "\nSakit = ${documentSnapshot['sakit']}";
    if (documentSnapshot['absen'] != "")        a += "\nAbsen = ${documentSnapshot['absen']}";
    if (documentSnapshot['dinas luar'] != "")   a += "\ndinas luar = ${documentSnapshot['dinas luar']}";
    return a;
  }

  // void fullSizeNih(BuildContext context) {
  //     Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
  //         Scaffold(
  //           body: Center(
  //             child: GestureDetector(
  //               onTap: (){Navigator.pop(context);},
  //               child: Hero(
  //                 tag: "nihBuktiNih",
  //                 child: Image.network(),
  //               ),
  //             ),
  //           ),
  //         )
  //     ));
  // }
}
