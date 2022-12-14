// import 'dart:ffi';
// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:jiffy/jiffy.dart';



class ExportExel extends StatefulWidget {
  const ExportExel({Key? key}) : super(key: key);

  @override
  State<ExportExel> createState() => _ExportExelState();
}

class _ExportExelState extends State<ExportExel> {

  final _tanggalController = TextEditingController();

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  // TimeOfDay time = TimeOfDay(hour: 10, minute: 30);

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

    final Stream<QuerySnapshot> _export = FirebaseFirestore.instance.collection('overtime')
        .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('stepid', isEqualTo: 'Approve@')
        // .orderBy('shift', descending: false)
        .snapshots();
    final Stream<QuerySnapshot> _exportC = FirebaseFirestore.instance.collection('cuti')
        // .where('tanggal', isEqualTo: selectedDate.toString().substring(0,10))
        .where('stepid', isEqualTo: 'Approve@')
        .orderBy('idtime')
        .snapshots();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Menu Export Data'),
          centerTitle: true,
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

                      StreamBuilder<QuerySnapshot>(
                          stream: _export,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            return kIsWeb ? SizedBox(
                              width: 180,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.grey),),
                                child: ElevatedButton(onPressed: () {
                                   _onExport() async {
                                      var excel = Excel.createExcel();
                                      Sheet sheet = excel['Sheet1'];
                                      // for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                                      var semuaDokumen = streamSnapshot.data!
                                          .docs;
                                      var rows = 0,
                                          koloms = 0;
                                      var cell = sheet.cell(
                                          CellIndex.indexByColumnRow(
                                              columnIndex: koloms,
                                              rowIndex: rows));
                                      Map<String, int> header = {
                                        "ID": 0,
                                        "Date": 1,
                                        "New Working Shift": 2,
                                        "SPL On Date": 3,
                                        "SPL On Time": 4,
                                        "SPL On Break Duration": 5,
                                        "SPL Off Date": 6,
                                        "SPL Off Time": 7,
                                      };
                                      header.forEach((key, value) {
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = key;
                                        koloms = koloms + 1;
                                      });
                                      // cell.value = _tanggalController.text;
                                      semuaDokumen.forEach((element) {
                                        // debugPrint(element['tanggal']);
                                        // var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                        // cell.value = element['tanggal']; rows += 1;
                                        element['peserta'].forEach((pasukan) {
                                        DateTime tanggalBaru = DateFormat("yyyy-MM-dd").parse(element['tanggal']);
                                        String shiftBaru = element['shift'];
                                        if (tanggalBaru.weekday == DateTime.saturday || tanggalBaru.weekday == DateTime.sunday) {
                                          shiftBaru = (tanggalBaru.weekday == DateTime.friday)? "1J NEW" : "1 NEW";
                                        }
                                        if ((element['shift']).toString().contains("1")) {
                                        shiftBaru = (tanggalBaru.weekday == DateTime.friday)
                                            ? "1J NEW"
                                            : (tanggalBaru.weekday == DateTime.saturday || tanggalBaru.weekday == DateTime.sunday)
                                            ? "OFF"
                                            :"1 NEW";
                                        }
                                        if ((element['shift']).toString().contains("2")) {
                                          shiftBaru = (tanggalBaru.weekday == DateTime.saturday || tanggalBaru.weekday == DateTime.sunday)
                                              ? "OFF2"
                                              : "2 NEW";
                                        }
                                          gantiFormat(String tanggal) {
                                            var formatTanggalAwal = DateFormat(
                                                "yyyy-MM-dd").parse(tanggal);
                                            return DateFormat("dd-MMM-yyyy")
                                                .format(formatTanggalAwal);
                                          }
                                          koloms = 0;
                                          rows = rows + 1;
                                          koloms = header['ID']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          cell.value =
                                              pasukan['nik'].toString();
                                          koloms = header['Date']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          cell.value =
                                              gantiFormat(element['tanggal']);
                                          koloms = header['New Working Shift']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          cell.value = shiftBaru;
                                          koloms = header['SPL On Date']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          // cell.value = null;
                                          koloms = header['SPL On Time']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          // cell.value = pasukan['nik'];
                                          koloms =
                                          header['SPL On Break Duration']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          // cell.value = pasukan['nik'];
                                          koloms = (header['SPL Off Date'])!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          cell.value =
                                              gantiFormat(element['tanggal']);
                                          if ((element['shift'])
                                              .toString()
                                              .contains("2")) {
                                            cell.value = gantiFormat(
                                                (DateTime.parse(
                                                    element['tanggal']).add(
                                                    const Duration(days: 1)))
                                                    .toString()
                                                    .substring(0, 10));

                                            debugPrint(DateTime.parse(
                                                element['tanggal']).toString());
                                          }
                                          koloms = header['SPL Off Time']!;
                                          cell = sheet.cell(
                                              CellIndex.indexByColumnRow(
                                                  columnIndex: koloms,
                                                  rowIndex: rows));
                                          cell.value = pasukan['jamkhir'];
                                        });
                                      });
                                      excel.save(fileName: "${_tanggalController
                                          .text}.xlsx");
                                    }
                                    _onExport();

                                },
                                    child: Icon(Icons.download) ),
                              ),
                            ) : Container();
                          }
                      ),
                    ],
                  ),

                  // Text(
                  //   'Choose Date',
                  //   style: TextStyle(
                  //       fontStyle: FontStyle.italic,
                  //       fontWeight: FontWeight.w600,
                  //       letterSpacing: 0.5),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //   child: InkWell(
                  //     onTap: () {
                  //       _selectDate(context);
                  //     },
                  //     child: Container(
                  //       width: 200,
                  //       height: 45,
                  //       margin: EdgeInsets.only(top: 2),
                  //       alignment: Alignment.center,
                  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                  //         color: Colors.grey[200],
                  //         border: Border.all(color: Colors.grey),),
                  //       child: TextFormField(
                  //         style: TextStyle(fontSize: 20),
                  //         textAlign: TextAlign.center,
                  //         enabled: false,
                  //         keyboardType: TextInputType.text,
                  //         controller: _tanggalController,
                  //         decoration: InputDecoration(
                  //             disabledBorder:
                  //             UnderlineInputBorder(borderSide: BorderSide.none),
                  //             // labelText: 'Time',
                  //             contentPadding: EdgeInsets.only(top: 0.0)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                                // ElevatedButton(onPressed: () {
                                //   _onExport() async {
                                //     var excel = Excel.createExcel();
                                //     Sheet sheet = excel['Sheet1'];
                                //     // for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                                //     var semuaDokumen = streamSnapshot.data!.docs;
                                //     var rows = 0, koloms = 0;
                                //     var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //     Map<String, int> header = {
                                //       "ID": 0,
                                //       "Date": 1,
                                //       "New Working Shift": 2,
                                //       "SPL On Date":3,
                                //       "SPL On Time":4,
                                //       "SPL On Break Duration":5,
                                //       "SPL Off Date":6,
                                //       "SPL Off Time":7,
                                //       "Bonus":8
                                //     };
                                //     header.forEach((key, value) {
                                //       cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //       cell.value = key;
                                //       koloms = koloms + 1;
                                //     });
                                //     cell.value = _tanggalController.text;
                                //     semuaDokumen.forEach((element) {
                                //       // debugPrint(element['tanggal']);
                                //       // var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //       // cell.value = element['tanggal']; rows += 1;
                                //       element['peserta'].forEach((pasukan){
                                //         koloms = 0;
                                //         rows = rows + 1;
                                //         koloms = header['ID']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         cell.value = pasukan['nik'];
                                //         koloms = header['Date']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         cell.value = element['tanggal'];
                                //         koloms = header['New Working Shift']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         cell.value = element['shift'];
                                //         koloms = header['SPL On Date']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         // cell.value = null;
                                //         koloms = header['SPL On Time']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         // cell.value = pasukan['nik'];
                                //         koloms = header['SPL On Break Duration']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         // cell.value = pasukan['nik'];
                                //         koloms = header['SPL Off Date']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         cell.value = element['tanggal'];
                                //         if((element['shift']).toString().contains("2")){
                                //           cell.value = (DateTime.parse(element['tanggal']).add(const Duration(days: 1))).toString().substring(0,10);
                                //
                                //           debugPrint(DateTime.parse(element['tanggal']).toString());
                                //         }
                                //         koloms = header['SPL Off Time']!;
                                //         cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         cell.value = pasukan['jamkhir'];
                                //         // cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                                //         // cell.value = pasukan['name'];
                                //       });
                                //       // koloms = 0;
                                //       // rows = rows + 1;  //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
                                //
                                //     });
                                //     // peserta.forEach((pasukan){
                                //     // });
                                //     // var a =  documentSnapshot['section']; // Insert value to selected cell;
                                //     // cell.value = a;
                                //     // debugPrint(a);
                                //     // }
                                //     // var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1));   //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
                                //     // cell.value = "masuk masuk";
                                //
                                //     excel.save(fileName: "download.xlsx");
                                //
                                //   }
                                //   _onExport();
                                //
                                // },
                                //
                                //     child: Icon(Icons.download) ),

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
                                margin: EdgeInsets.only(top: 2),
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

                      // StreamBuilder<QuerySnapshot>(
                      //     stream: _export,
                      //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      //       return SizedBox(
                      //         width: 180,
                      //         height: 60,
                      //         child: Container(
                      //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                      //             color: Colors.grey[200],
                      //             border: Border.all(color: Colors.grey),),
                      //           child: ElevatedButton(onPressed: () {
                      //             _onExport() async {
                      //               var excel = Excel.createExcel();
                      //               Sheet sheet = excel['Sheet1'];
                      //               // for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                      //               var semuaDokumen = streamSnapshot.data!.docs;
                      //               var rows = 0, koloms = 0;
                      //               var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //               Map<String, int> header = {
                      //                 "ID": 0,
                      //                 "Date": 1,
                      //                 "New Working Shift": 2,
                      //                 "SPL On Date":3,
                      //                 "SPL On Time":4,
                      //                 "SPL On Break Duration":5,
                      //                 "SPL Off Date":6,
                      //                 "SPL Off Time":7,
                      //                 "Bonus":8
                      //               };
                      //               header.forEach((key, value) {
                      //                 cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                 cell.value = key;
                      //                 koloms = koloms + 1;
                      //               });
                      //               cell.value = _tanggalController.text;
                      //               semuaDokumen.forEach((element) {
                      //                 // debugPrint(element['tanggal']);
                      //                 // var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                 // cell.value = element['tanggal']; rows += 1;
                      //                 element['peserta'].forEach((pasukan){
                      //                   koloms = 0;
                      //                   rows = rows + 1;
                      //                   koloms = header['ID']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   cell.value = pasukan['nik'];
                      //                   koloms = header['Date']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   cell.value = element['tanggal'];
                      //                   koloms = header['New Working Shift']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   cell.value = element['shift'];
                      //                   koloms = header['SPL On Date']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   // cell.value = null;
                      //                   koloms = header['SPL On Time']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   // cell.value = pasukan['nik'];
                      //                   koloms = header['SPL On Break Duration']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   // cell.value = pasukan['nik'];
                      //                   koloms = header['SPL Off Date']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   cell.value = element['tanggal'];
                      //                   if((element['shift']).toString().contains("2")){
                      //                     cell.value = (DateTime.parse(element['tanggal']).add(const Duration(days: 1))).toString().substring(0,10);
                      //
                      //                     debugPrint(DateTime.parse(element['tanggal']).toString());
                      //                   }
                      //                   koloms = header['SPL Off Time']!;
                      //                   cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   cell.value = pasukan['jamkhir'];
                      //                   // cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: koloms, rowIndex: rows));
                      //                   // cell.value = pasukan['name'];
                      //                 });
                      //                 // koloms = 0;
                      //                 // rows = rows + 1;  //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
                      //
                      //               });
                      //               // peserta.forEach((pasukan){
                      //               // });
                      //               // var a =  documentSnapshot['section']; // Insert value to selected cell;
                      //               // cell.value = a;
                      //               // debugPrint(a);
                      //               // }
                      //               // var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1));   //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
                      //               // cell.value = "masuk masuk";
                      //
                      //               excel.save(fileName: "download.xlsx");
                      //
                      //             }
                      //             _onExport();
                      //
                      //           },
                      //
                      //               child: Icon(Icons.download) ),
                      //         ),
                      //       );
                      //     }
                      // ),

                      StreamBuilder<QuerySnapshot>(
                          stream: _exportC,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            return kIsWeb ? SizedBox(
                              width: 180,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.grey),),
                                child: ElevatedButton(onPressed: () {
                                  _onExport() async {
                                    var excel = Excel.createExcel();
                                    Sheet sheet = excel['Sheet1'];
                                    // for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                                    var semuaDokumen = streamSnapshot.data!.docs.where((element) => element['captanggal'].toString().substring(0,10) == selectedDate.toString().substring(0,10));
                                    var rows = 0,
                                        koloms = 0;
                                    var cell = sheet.cell(
                                        CellIndex.indexByColumnRow(
                                            columnIndex: koloms,
                                            rowIndex: rows));
                                    Map<String, int> header = {
                                      "ID": 0,
                                      "Fullname": 1,
                                      "Working Shift": 2,
                                      "Date": 3,
                                      "Permit/Leave Code": 4,
                                      "Duty On Date": 5,
                                      "Duty On Time": 6,
                                      "Duty Off Date": 7,
                                      "Duty Off Time": 8,
                                      "Actual Attendance Code" : 9,
                                      "Leave Note" : 10,
                                    };
                                    header.forEach((key, value) {
                                      cell = sheet.cell(
                                          CellIndex.indexByColumnRow(
                                              columnIndex: koloms,
                                              rowIndex: rows));
                                      cell.value = key;
                                      koloms = koloms + 1;
                                    });
                                    // cell.value = _tanggalController.text;
                                    semuaDokumen.forEach((element) {
                                      DateTime tanggalBaru = DateFormat("yyyy-MM-dd").parse(element['tanggal']);
                                      String shiftBaru = element['shift'];
                                      String kategoriString = "";
                                      // List kategorii = [
                                      //   element['absen'],
                                      //   element['cutitahunan'],
                                      //   element['dinas luar'],
                                      //   element['dispensasi'],
                                      //   element['sakit'],
                                      //   element['tidakupah']
                                      // ];
                                      if (element['absen'] != "") kategoriString += "A " ;
                                      if (element['cutitahunan'] != "") kategoriString += "CT ";
                                      if (element['dinas luar'] != "") kategoriString += "DL ";
                                      if (element['dispensasi'] != "") kategoriString += "D " ;
                                      if (element['sakit'] != "") kategoriString += "S " ;
                                      if (element['tidakupah'] != "") kategoriString += "TU ";

                                      for (var i = 0; i < int.parse(element['jumlahhari']); i++) {
                                        if (tanggalBaru.weekday == DateTime.saturday) {
                                          tanggalBaru = tanggalBaru.add(Duration(days: 2));
                                        }
                                        if ((element['shift']).toString().contains("1")) {
                                          shiftBaru = (tanggalBaru.weekday == DateTime.friday)? "1J NEW" : "1 NEW";
                                        }
                                        if ((element['shift']).toString().contains("2")) shiftBaru = "2 NEW";

                                        gantiFormat(String tanggal) {
                                          DateTime formatTanggalAwal = DateFormat(
                                              "yyyy-MM-dd").parse(tanggal);
                                          return DateFormat("M/d/yyyy")
                                              .format(formatTanggalAwal);
                                        }
                                        koloms = 0;
                                        rows = rows + 1;
                                        koloms = header['ID']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = element['nik'];

                                        koloms = header['Fullname']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = element['nama_pengaju'];

                                        koloms = header['Working Shift']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = shiftBaru;

                                        koloms = header['Date']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value =
                                            gantiFormat(element['tanggal']);

                                        koloms = header['Permit/Leave Code']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = kategoriString;

                                        koloms = header['Duty On Date']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = DateFormat("M/d/yyyy").format(tanggalBaru);

                                        koloms = header['Duty On Time']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = "07.00";
                                        if ((element['shift'])
                                            .toString()
                                            .contains("2")) {
                                          cell.value = "19.00";
                                        }

                                        koloms = header['Duty Off Date']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = DateFormat("M/d/yyyy").format(tanggalBaru);
                                        if ((element['shift'])
                                            .toString()
                                            .contains("2")) {
                                          cell.value = DateFormat("M/d/yyyy").format(tanggalBaru.add(Duration(days: 1)));
                                        }

                                        koloms = header['Duty Off Time']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = "16.10";
                                        if ((element['shift'])
                                            .toString()
                                            .contains("2")) {
                                          cell.value = "04.10";
                                        }

                                        koloms =
                                        header['Actual Attendance Code']!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = kategoriString;

                                        koloms = (header['Leave Note'])!;
                                        cell = sheet.cell(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: koloms,
                                                rowIndex: rows));
                                        cell.value = element['keterangan'];

                                        tanggalBaru = tanggalBaru.add(Duration(days: 1));
                                      }
                                    });

                                    excel.save(fileName: "${_tanggalController.text}.xlsx");
                                  }
                                  _onExport();

                                },
                                    child: Icon(Icons.download) ),
                              ),
                            ) : Container();
                          }
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
                                      subtitle: Text(Jiffy((documentSnapshot['idtime'] as Timestamp).toDate()).fromNow() + ', ' + (documentSnapshot['idtime'] as Timestamp).toDate().toString().substring(0, 10)),
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
                                          title: Text(formatCuti(documentSnapshot)),
                                            // title: Text("Huahahaha"),
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

