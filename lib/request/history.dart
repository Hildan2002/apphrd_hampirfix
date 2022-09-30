// import 'dart:ffi';
// import 'dart:io';
import 'package:aplikasi_hrd/request/ujicoba.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path/path.dart';
import 'package:intl/intl.dart';



class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final _tanggalController = TextEditingController();

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  late String dateTime;

  DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _tanggalController.text = DateFormat.yMMMEd().format(selectedDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    _tanggalController.text = DateFormat.yMMMEd().format(selectedDate);
    final Stream<QuerySnapshot> Pexport = FirebaseFirestore.instance.collection('overtime')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo : 'proses')
        .snapshots();
    debugPrint(selectedDate.toString().substring(0,10));
    final imel = FirebaseAuth.instance.currentUser!.email;
    debugPrint("${(imel)?.substring(imel.indexOf("@")+1, imel.indexOf("."))}");

    final Stream<QuerySnapshot> PexportC = FirebaseFirestore.instance.collection('cuti')
        // .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo : 'proses')
        .snapshots();

    final Stream<QuerySnapshot> export = FirebaseFirestore.instance.collection('overtime')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: '${FirebaseAuth.instance.currentUser!.email}')
        .where('status', isEqualTo: 'done')
        .snapshots();

    final Stream<QuerySnapshot> exportC = FirebaseFirestore.instance.collection('cuti')
        // .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo: 'done')
        .snapshots();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Riwayat Pengajuan'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.lime,
            indicatorWeight: 5.0,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.only(top: 10.0),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Progress OT',
                icon: Icon(
                  Icons.book_outlined,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),

              Tab(
                text: 'Progress Cuti',
                icon: Icon(
                  Icons.beach_access,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),

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
              children:<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Choose Date',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: 200,
                              height: 45,
                              margin: const EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: const InputDecoration(
                                    disabledBorder:
                                    UnderlineInputBorder(borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: StreamBuilder(
                    stream: Pexport,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            var peserta = documentSnapshot['peserta'];
                            var daftarPeserta = "Daftar Peserta Lembur:";
                            peserta.forEach((item){
                              daftarPeserta = "${daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal']} hingga pukul " + item['jamkhir'];
                            });
                            var tanggal = documentSnapshot['tanggal'];

                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: Text(nama[nik.indexOf(documentSnapshot['stepid'].toString().substring(documentSnapshot['stepid'].toString().indexOf("@")+1, documentSnapshot['stepid'].toString().indexOf(".")))]),
                                    // title: Text(documentSnapshot['stepid'].toString().substring(0,documentSnapshot['stepid'].toString().indexOf("@"))),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Dokumen ini telah diterima pada ${documentSnapshot['captanggal'].toString().substring(0,documentSnapshot['captanggal'].toString().indexOf("."))} '
                                            'dan sedang diverifikasi oleh Bapak/Ibu ${nama[nik.indexOf(documentSnapshot['stepid'].toString().substring(documentSnapshot['stepid'].toString().indexOf("@")+1, documentSnapshot['stepid'].toString().indexOf(".")))]}'),
                                      ),
                                      ListTile(
                                        title: Text("Tanggal diajukan: ${tanggal.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text(documentSnapshot['shift'].toString()),
                                      ),
                                      ListTile(
                                        title: Text(daftarPeserta),
                                      ),
                                    ],
                                  ),
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

            Column(
              children:<Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: const [
                //     // Column(
                //     //   children: [
                //     //     const Text(
                //     //       'Choose Date',
                //     //       style: TextStyle(
                //     //           fontStyle: FontStyle.italic,
                //     //           fontWeight: FontWeight.w600,
                //     //           letterSpacing: 0.5),
                //     //     ),
                //     //     Padding(
                //     //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
                //     //       child: InkWell(
                //     //         onTap: () {
                //     //           _selectDate(context);
                //     //         },
                //     //         child: Container(
                //     //           width: 200,
                //     //           height: 45,
                //     //           margin: const EdgeInsets.only(top: 2),
                //     //           alignment: Alignment.center,
                //     //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                //     //             color: Colors.grey[200],
                //     //             border: Border.all(color: Colors.grey),),
                //     //           child: TextFormField(
                //     //             style: const TextStyle(fontSize: 20),
                //     //             textAlign: TextAlign.center,
                //     //             enabled: false,
                //     //             keyboardType: TextInputType.text,
                //     //             controller: _tanggalController,
                //     //             decoration: const InputDecoration(
                //     //                 disabledBorder:
                //     //                 UnderlineInputBorder(borderSide: BorderSide.none),
                //     //                 // labelText: 'Time',
                //     //                 contentPadding: EdgeInsets.only(top: 0.0)),
                //     //           ),
                //     //         ),
                //     //       ),
                //     //     ),
                //     //   ],
                //     // ),
                //   ],
                // ),

                Expanded(
                  child: StreamBuilder(
                    stream: PexportC,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            var tanggal = documentSnapshot['tanggal'];
                            var tanggal2 = documentSnapshot['tanggal2'];
                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: Text(nama[nik.indexOf(documentSnapshot['stepid'].toString().substring(documentSnapshot['stepid'].toString().indexOf("@")+1, documentSnapshot['stepid'].toString().indexOf(".")))]),
                                    // title: Text(documentSnapshot['stepid'].toString().substring(0,documentSnapshot['stepid'].toString().indexOf("@"))),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Dokumen ini telah diterima pada ${documentSnapshot['captanggal'].toString().substring(0,documentSnapshot['captanggal'].toString().indexOf("."))} '
                                            'dan sedang diverifikasi oleh Bapak/Ibu ${nama[nik.indexOf(documentSnapshot['stepid'].toString().substring(documentSnapshot['stepid'].toString().indexOf("@")+1, documentSnapshot['stepid'].toString().indexOf(".")))]
                                        }'),
                                      ),
                                      ListTile(
                                        title: Text("Nama Pengaju: ${documentSnapshot['nama_pengaju'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("dari tanggal : ${tanggal.substring(0,10)} sampai dengan tanggal ${tanggal2.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("Keterangan : ${documentSnapshot['keterangan'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("Jumlah Cuti yang Diambil ${documentSnapshot['jumlahhari'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text(formatCuti(documentSnapshot)),
                                      ),
                                    ],
                                  ),
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

            Column(
              children:<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                         const Text(
                          'Choose Date',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: 200,
                              height: 45,
                              margin: const EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: const InputDecoration(
                                    disabledBorder:
                                    UnderlineInputBorder(borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: StreamBuilder(
                    stream: export,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            var peserta = documentSnapshot['peserta'];
                            var daftarPeserta = "Daftar Peserta Lembur:";
                            peserta.forEach((item){
                              daftarPeserta = "${daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal']} hingga pukul " + item['jamkhir'];
                              // daftarPeserta = "${daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal']} hingga pukul " + item['jamkhir'];
                            });
                            var tanggal = documentSnapshot['tanggal'];
                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: documentSnapshot['stepid'] == null && documentSnapshot['stepid'] == '' ? Text(documentSnapshot['stepid']) :
                                    Text('Permintaan Anda telah di' + documentSnapshot['stepid'].toString().substring(0,documentSnapshot['stepid'].toString().indexOf('@'))),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('nama yang bertanggung jawab : ${documentSnapshot['name_pic'].toString()}'),
                                      ),
                                      ListTile(
                                        title: Text("Tanggal : ${tanggal.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("${documentSnapshot['shift'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text(daftarPeserta),
                                      ),
                                    ],
                                  ),
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

            Column(
              children:<Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Column(
                //       children: [
                //         const Text(
                //           'Choose Date',
                //           style: TextStyle(
                //               fontStyle: FontStyle.italic,
                //               fontWeight: FontWeight.w600,
                //               letterSpacing: 0.5),
                //         ),
                //         // Padding(
                //         //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                //         //   child: InkWell(
                //         //     onTap: () {
                //         //       _selectDate(context);
                //         //     },
                //         //     child: Container(
                //         //       width: 200,
                //         //       height: 45,
                //         //       margin: const EdgeInsets.only(top: 2),
                //         //       alignment: Alignment.center,
                //         //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                //         //         color: Colors.grey[200],
                //         //         border: Border.all(color: Colors.grey),),
                //         //       child: TextFormField(
                //         //         style: const TextStyle(fontSize: 20),
                //         //         textAlign: TextAlign.center,
                //         //         enabled: false,
                //         //         keyboardType: TextInputType.text,
                //         //         controller: _tanggalController,
                //         //         decoration: const InputDecoration(
                //         //             disabledBorder:
                //         //             UnderlineInputBorder(borderSide: BorderSide.none),
                //         //             // labelText: 'Time',
                //         //             contentPadding: EdgeInsets.only(top: 0.0)),
                //         //       ),
                //         //     ),
                //         //   ),
                //         // ),
                //       ],
                //     ),
                //   ],
                // ),

                Expanded(
                  child: StreamBuilder(
                    stream: exportC,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            var tanggal = documentSnapshot['tanggal'];
                            var tanggal2 = documentSnapshot['tanggal2'];
                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: documentSnapshot['stepid'] == null && documentSnapshot['stepid'] == '' ? Text(documentSnapshot['stepid']) :
                                    Text('Permintaan Anda telah di${documentSnapshot['stepid'].toString().substring(0,documentSnapshot['stepid'].toString().indexOf('@'))}'),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Nama Pengaju: ${documentSnapshot['nama_pengaju'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("dari tanggal : ${tanggal.substring(0,10)} sampai dengan tanggal ${tanggal2.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("Keterangan ${documentSnapshot['keterangan'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("Jumlah Cuti yang Diambil ${documentSnapshot['jumlahhari'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text(formatCuti(documentSnapshot)),
                                      ),
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }

  String formatCuti(DocumentSnapshot<Object?> documentSnapshot) {
    String a = "";
    if (documentSnapshot['cutitahunan'] != "")  a += "Cuti Tahunan = ${documentSnapshot['cutitahunan']}";
    if (documentSnapshot['dispensasi'] != "")   a += "\nDispensasi = ${documentSnapshot['dispensasi']}";
    if (documentSnapshot['tidakupah'] != "")    a += "\nIzin Tidak Mendapatkan Upah = ${documentSnapshot['tidakupah']}";
    if (documentSnapshot['sakit'] != "")        a += "\nSakit = ${documentSnapshot['sakit']}";
    if (documentSnapshot['absen'] != "")        a += "\nAbsen = ${documentSnapshot['absen']}";
    if (documentSnapshot['dinas luar'] != "")   a += "\ndinas luar = ${documentSnapshot['dinas luar']}";
    return a;
  }
}

