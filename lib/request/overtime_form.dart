import 'dart:convert';
import 'package:aplikasi_hrd/main.dart';
import 'package:http/http.dart' as http;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';


class RequestOvertime extends StatefulWidget {
  const RequestOvertime({Key? key}) : super(key: key);

  @override
  State<RequestOvertime> createState() => _RequestOvertimeState();
}

class _RequestOvertimeState extends State<RequestOvertime> {

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

  static const menuItems = <String>[
    'CAM',
    'CNC',
    'MFG2',
    'MAINTENANCE',
    'PPIC',
    'IT',
    'ACCOUNTING',
    'ADMIN',
    'ENGINEERING',
    'QA',
    'QC',
  ];

  static const menuItems2 = <String>[
    '1NEW',
    '1JNEW',
    '2NEW',
    'OFF',
    'OFF2',
    '1NEWP',
    '1JNEWP',
    '2NEWP'
  ];

  String? _butonSelected1;
  String? _butonSelected2;

  var nameTECs = <TextEditingController>[];
  var nikTECs = <TextEditingController>[];
  var jobTECs = <TextEditingController>[];
  var jamaTECs = <TextEditingController>[];
  var jamkhirTECs = <TextEditingController>[];
  var cards = <Card>[];
  final _tjController = TextEditingController();
  final _atasnamaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _secdepController = TextEditingController();
  final _shiftController = TextEditingController();


  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems.map(
        (String value) =>
        DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
  ).toList();

  final List<DropdownMenuItem<String>> _dropDownMenuItems2 = menuItems2.map(
        (String value) =>
        DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
  ).toList();

  @override
  void dispose() {
    _atasnamaController.dispose();
    _tjController.dispose();
    _tanggalController.dispose();
    _secdepController.dispose();
    _shiftController.dispose();
    super.dispose();
  }


  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);

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

  Card createCard() {
    var nameController = TextEditingController();
    var nikController = TextEditingController();
    var jobController = TextEditingController();
    var jamawalController = TextEditingController();
    var jamkhirController = TextEditingController();
    nameTECs.add(nameController);
    nikTECs.add(nikController);
    jobTECs.add(jobController);
    jamaTECs.add(jamawalController);
    jamkhirTECs.add(jamkhirController);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 5),
          Text('Karyawan ${cards.length + 1}'),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nama',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: nikController,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'NIK',
              ),
            ),
          ),

          // SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: jobController,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Keterangan Lembur',
              ),
            ),
          ),

          // SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: jamawalController,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Perkiraan waktu lembur dimulai',
              ),
            ),
          ),

          // SizedBox(height: 5),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              onFieldSubmitted: (value){
                setState(() => cards.add(createCard()));
              },
              controller: jamkhirController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'perkiraan waktu lembur berakhir',

              ),
              textInputAction: TextInputAction.done,
            ),
          ),

          // SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  void initState() {

    // FirebaseMessaging.instance.subscribeToTopic("Animal");
    _tanggalController.text = DateFormat.yMMMEd().format(DateTime.now());
    super.initState();
    cards.add(createCard());

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
      );
    });

  }

  String? periksa;

  _onDone() {
    var name_pic = _tjController.text;
    var tanggal = selectedDate;
    var secdept = _butonSelected1;
    var shift = _butonSelected2;
    List<Employee> list_pegawai = [];
    for (int i = 0; i < cards.length; i++) {
      var name = nameTECs[i].text;
      var nik = nikTECs[i].text;
      var job = jobTECs[i].text;
      var jamawal = jamaTECs[i].text;
      var jamkhir = jamkhirTECs[i].text;
      // var format = DateFormat('HH.mm');
      // var awal = format.parse(jamawal);
      // var akhir = format.parse(jamkhir);
      // if (akhir.isBefore(awal)) akhir = akhir.add(const Duration(hours: 24));
      // Duration beda = akhir.difference(awal);
      //
      // String twoDigits(int n){
      //   return n.toString().padLeft(2,"0");
      // }
      // String selisih = "${twoDigits(beda.inHours)}:${twoDigits(beda.inMinutes.remainder(60))}";
      Employee employee = Employee(name, nik, job, jamawal, jamkhir);
      list_pegawai.add(employee);
    }
    // final idStep =  {
    switch (secdept) {
      case 'CAM':
      case 'CNC':
        periksa = 'rohmad@0167.nsi';
        // idtoken
        break;
      case 'MFG2' :
        periksa = 'samsu@0012.nsi';
        break;
      case 'PPIC' :
        periksa = 'cecep@0123.nsi';
        break;
      case 'ACCOUNTING' :
        periksa = 'harlan@0693.nsi';
        break;
      case 'ENGINEERING' :
        periksa = 'sumadi@0068.nsi';
        break;
      case 'QA' :
        periksa = 'dedi@0519.nsi';
        break;
      case 'QC' :
        periksa = 'yana@0175.nsi';
        break;
      case 'IT' :
      case'ADMIN':
      case 'MAINTENANCE' :
        periksa = 'widodo@0368.nsi';
        break;
      default :
        periksa = 'salah';
        break;
    }
    debugPrint(periksa);

    CRUD(name_pic: name_pic,
      tanggal: tanggal,
      secdept: secdept,
      list: list_pegawai,
      shift: shift,
      periksa: periksa,
      );


    Navigator.pop(context);

  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
        length: 2,
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Request Overtime'),
            bottom: TabBar(
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: Colors.white,
              labelColor: Colors.black,
              indicator: BoxDecoration(
                  color: Colors.amberAccent,
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 5,
                      )
                  )
              ),
              tabs: [
                Tab(
                  text: 'Header'
                  ,
                ),
                Tab(
                  text: 'Content',
                )
              ],
            ),
          ),
          body: TabBarView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   StreamBuilder(
                       stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                       builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot) {
                         if (streamSnapshot.hasError) {
                           return Text('Something went wrong');
                         }
                         if (streamSnapshot.connectionState ==
                             ConnectionState.waiting) {
                           return Text("Loading");
                         }
                         if (streamSnapshot.hasData) {
                            return ListTile(
                                  title: Text('Formulir ini Atas nama : ${streamSnapshot.data!['nama']}'),
                            );
                         }
                         return CircularProgressIndicator();
                       }
                   ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: _tjController,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Nama Penanggung Jawab',
                        ),
                      ),
                    ),

                    ListTile(
                      title: const Text('Pilih Department :'),
                      trailing: DropdownButton(
                        value: _butonSelected1,
                        hint: const Text('pilih'),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _butonSelected1 = newValue;
                            });
                          }
                        }, items: _dropDownMenuItems,
                      ),
                    ),

                    ListTile(
                      title: const Text('Pilih Shift :'),
                      trailing: DropdownButton(
                        value: _butonSelected2,
                        hint: const Text('pilih'),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _butonSelected2 = newValue;
                            });
                          }
                        }, items: _dropDownMenuItems2,
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              width: 250,
                              height: 50,
                              margin: EdgeInsets.only(top: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),),
                              child: TextFormField(
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _tanggalController,
                                decoration: InputDecoration(
                                    disabledBorder:
                                    UnderlineInputBorder(borderSide: BorderSide
                                        .none),
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
           Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                 ElevatedButton(
                   child: Text('Tambah Peserta'),
                   onPressed: () => setState(() => cards.add(createCard()))),
                 ElevatedButton(
                   child: Text('Kurangi Peserta'),
                   onPressed: () => setState(() => cards.removeLast())),
                   ElevatedButton(
                   child: Text('Send'),
                   onPressed: () async {
                     _onDone();

                   FirebaseFirestore.instance
                       .collection("users")
                       .where("email", isEqualTo: periksa)
                       .get().then(
                           (QuerySnapshot snapshot) => {
                             if(snapshot.docs.isNotEmpty){
                               sendPushMessage((snapshot.docs.first.data() as Map)["tokens"]),
                               debugPrint((snapshot.docs.first.data() as Map)["tokens"])
                             }
                           });

                     ElegantNotification.success(
                        title: Text('Berhasil'),
                        description: Text('Anda Berhasil mengirim request overtime'),
                        notificationPosition: NotificationPosition.top,
                        dismissible: true,
                       ).show(context);



                     }

                   ),
               ],
               ),
               Expanded(
                 child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cards[index];
                  },
          ),
               ),

             ],
           ),
              ]
          ),
        )
    );
  }

  Future CRUD({required String name_pic,
    required DateTime tanggal,
    required String? secdept,
    required String? shift,
    required String? periksa,
    // required Double step,
    required List<Employee> list}) async {
    final overtime = FirebaseFirestore.instance.collection('overtime');
    var inputTime = DateTime.now();
    final json = <String, dynamic>{
      'idtime': inputTime,
      'name_pic': name_pic,
      'section': secdept,
      'tanggal': tanggal.toString().substring(0, 10),
      'shift': shift,
      'peserta': list.map((e) => e.toJson()).toList(),
      'stepid': periksa,
    };
    await overtime.add(json);

    //todo: add notification

    debugPrint('json: $json');
    // }
  }

}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
class Lembur {
  var name_pic, secdept, tanggal, shift;
  List<Employee> list_employee = [];

  Lembur(String name_pic, String tanggal, String shift, String secdept, List<Employee> list_pegawai);
}
class Employee {
  var name, nik, job, jamawal, jamkhir;

  Employee(this.name, this.nik, this.job, this.jamawal, this.jamkhir);

  Map<String, dynamic> toJson() => {
    'name':name,
    'nik':nik,
    'job':job,
    'jamawal':jamawal,
    'jamkhir':jamkhir,
  };
}