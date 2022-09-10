// import 'dart:ffi';
// import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';



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


  Future<Null> _selectDate(BuildContext context) async {
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
    final Stream<QuerySnapshot> _Pexport = FirebaseFirestore.instance.collection('overtime')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo : 'proses')
        .snapshots();
    debugPrint(selectedDate.toString().substring(0,10));

    final Stream<QuerySnapshot> _PexportC = FirebaseFirestore.instance.collection('cuti')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo : 'proses')
        .snapshots();

    final Stream<QuerySnapshot> _export = FirebaseFirestore.instance.collection('overtime')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: '${FirebaseAuth.instance.currentUser!.email}')
        .where('status', isEqualTo: 'done')
        .snapshots();

    final Stream<QuerySnapshot> _exportC = FirebaseFirestore.instance.collection('cuti')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo: 'done')
        .snapshots();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu Export Data'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.lime,
            indicatorWeight: 5.0,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.only(top: 10.0),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Progress Overtime',
                icon: Icon(
                  Icons.fire_truck,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.only(bottom: 10.0),
              ),

              Tab(
                text: 'Request Cuti',
                icon: Icon(
                  Icons.rocket_launch_rounded,
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
                        Text(
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
                              margin: EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: InputDecoration(
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
                    stream: _Pexport,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            var peserta = documentSnapshot['peserta'];
                            var daftarPeserta = "Daftar Peserta Lembur:";
                            peserta.forEach((item){
                              daftarPeserta = daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal'] + " hingga pukul " + item['jamkhir'];
                            });
                            var tanggal = documentSnapshot['tanggal'];

                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: Text(documentSnapshot['stepid'].toString()),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('nama yang bertanggung jawab : ${documentSnapshot['name_pic'].toString()}'),
                                      ),
                                      ListTile(
                                        title: Text("Tanggal : ${tanggal.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("Shift ${documentSnapshot['shift'].toString()}"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
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
                              margin: EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: InputDecoration(
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
                    stream: _PexportC,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                            var tanggal = documentSnapshot['tanggal'];

                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: Text(documentSnapshot['section'].toString()),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Nama Pengaju: ${documentSnapshot['nama_pengaju'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("Tanggal : ${tanggal.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("Keterangan ${documentSnapshot['keterangan'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("Jumlah Cuti yang Diambil ${documentSnapshot['jumlahhari'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text('Cuti Tahunan = ${documentSnapshot['cutitahunan']} \n Dispensasi = ${documentSnapshot['dispensasi']} \n Izin Tidak Mendapatkan Upah = ${documentSnapshot['tidakupah']} \n sakit = ${documentSnapshot['sakit']} \n Dinas Luar = ${documentSnapshot['absen']} \n dinas luar = ${documentSnapshot['dinas luar']}'),
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
                         Text(
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
                              margin: EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: InputDecoration(
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
                    stream: _export,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            var peserta = documentSnapshot['peserta'];
                            var daftarPeserta = "Daftar Peserta Lembur:";
                            peserta.forEach((item){
                              daftarPeserta = daftarPeserta + "\n- " + item['name'] + ", Keterangan : " + item['job'] + " dari pukul " + item['jamawal'] + " hingga pukul " + item['jamkhir'];
                            });
                            var tanggal = documentSnapshot['tanggal'];

                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: Text(documentSnapshot['section'].toString()),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('nama yang bertanggung jawab : ${documentSnapshot['name_pic'].toString()}'),
                                      ),
                                      ListTile(
                                        title: Text("Tanggal : ${tanggal.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("Shift ${documentSnapshot['shift'].toString()}"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
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
                              margin: EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: InputDecoration(
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
                    stream: _exportC,
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (streamSnapshot.hasData ) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                            var tanggal = documentSnapshot['tanggal'];

                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  child: ExpansionTile(
                                    title: Text(documentSnapshot['section'].toString()),
                                    subtitle: Text(documentSnapshot['tanggal']),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Nama Pengaju: ${documentSnapshot['nama_pengaju'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("Tanggal : ${tanggal.substring(0,10)}"),
                                      ),
                                      ListTile(
                                        title: Text("Keterangan ${documentSnapshot['keterangan'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text("Jumlah Cuti yang Diambil ${documentSnapshot['jumlahhari'].toString()}"),
                                      ),
                                      ListTile(
                                        title: Text('Cuti Tahunan = ${documentSnapshot['cutitahunan']} \n Dispensasi = ${documentSnapshot['dispensasi']} \n Izin Tidak Mendapatkan Upah = ${documentSnapshot['tidakupah']} \n sakit = ${documentSnapshot['sakit']} \n Dinas Luar = ${documentSnapshot['absen']} \n dinas luar = ${documentSnapshot['dinas luar']}'),
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
}

