import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Cutidetail extends StatelessWidget {
  final Timestamp timestamp;

  const Cutidetail({Key? key, required this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? periksa2;
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> cutiform = FirebaseFirestore.instance.collection('cuti').where("idtime", isEqualTo: timestamp).snapshots();

    switch(user.email){
      case 'ayuandini@0916.nsi':
      case 'viola@0962.nsi':
        periksa2 = 'Approved';
        break;
      case 'yuki@takahashi.nsi':
      case 'adi@0217.nsi':
      case 'widodo@0368.nsi':
        periksa2 = 'ayuandini@0916.nsi';
        break;
      case 'rohmad@0167.nsi'  :
      case  'samsu@0012.nsi' :
      case 'cecep@0123.nsi'  :
        periksa2 = 'widodo@0368.nsi';
        break;
      case 'harlan@0693.nsi':
        periksa2 = 'generalmanageraccounting@gmail.com';
        break;
      case 'sumadi@0068.nsi':
      case 'dedi@0519.nsi':
      case 'yana@0175.nsi':
        periksa2 = 'adi@0217.nsi';
        break;
      default :
        periksa2 = 'error';
    }
    debugPrint(periksa2);



    Future<void> _update([DocumentSnapshot? documentSnapshot]) async{
      await FirebaseFirestore.instance.collection('cuti').doc(documentSnapshot!.id).update({'stepid' : periksa2});
      // await FirebaseFirestore.instance.collection('cuti').doc(documentSnapshot.id).update({'stepid1' : periksa3});
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
                          // var peserta = documentSnapshot['peserta'];
                          // var daftarPeserta = "Daftar Peserta Lembur:";
                          // peserta.forEach((item){
                          //   daftarPeserta = daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal'] + " hingga pukul " + item['jamkhir'];
                          //
                          // });
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
                                            title: Text('Cuti Tahunan = ${documentSnapshot['cutitahunan']} \n Dispensasi = ${documentSnapshot['dispensasi']} \n Izin Tidak Mendapatkan Upah = ${documentSnapshot['tidakupah']} \n sakit = ${documentSnapshot['sakit']} \n Dinas Luar = ${documentSnapshot['absen']} \n dinas luar = ${documentSnapshot['dinas luar']}'),
                                            subtitle: Text('Jenis Cuti Yang Diambil'),
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () => _update(documentSnapshot),
                                  child: const Text('Approve'))
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
