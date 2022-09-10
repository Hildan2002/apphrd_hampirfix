import 'dart:convert';
import 'package:aplikasi_hrd/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:backdrop/backdrop.dart';

class RequestCutiQusus extends StatefulWidget {
  const RequestCutiQusus({Key? key}) : super(key: key);

  @override
  State<RequestCutiQusus> createState() => _RequestCutiQususState();
}


class _RequestCutiQususState extends State<RequestCutiQusus> {

  void sendPushMessage(String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=APA91bFMbsTBWRlN6Taf3jZQrpri3hOBk8v2jjKFVGkR-KMIbmUb2sXN19HtX5VP30Oac_KkEzzht1ewhq6ksX2kjNTLLRiThYY54eY9jVC4YSBGjdf7YPhr5JtOiBGOrcroI11nxsGV',
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



  String? _butonSelected1;

  final _jumlahhariController = TextEditingController();
  final _atasnamaController = TextEditingController();
  final _nikController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _tanggal2Controller = TextEditingController();
  final _secdepController = TextEditingController();
  final _shiftController = TextEditingController();
  final _cutitahunanController = TextEditingController();
  final _dispensasiController = TextEditingController();
  final _izintidakupahController = TextEditingController();
  final _sakitController = TextEditingController();
  final _absenController = TextEditingController();
  final _dinasluarController = TextEditingController();


  @override
  void dispose() {
    _jumlahhariController.dispose();
    _nikController.dispose();
    _keteranganController.dispose();
    _atasnamaController.dispose();
    _tanggalController.dispose();
    _tanggal2Controller.dispose();
    _secdepController.dispose();
    _shiftController.dispose();
    _cutitahunanController.dispose();
    _dispensasiController.dispose();
    _izintidakupahController.dispose();
    _sakitController.dispose();
    _dinasluarController.dispose();
    _absenController.dispose();
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

  late String dateTime2;

  DateTime selectedDate2 = DateTime.now();

  TimeOfDay time2 = TimeOfDay(hour: 10, minute: 30);

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate2 = picked;
        _tanggal2Controller.text = DateFormat.yMMMEd().format(selectedDate2);
      });
    }
  }

  @override
  void initState() {
    _tanggal2Controller.text = DateFormat.yMMMEd().format(DateTime.now());
    _tanggalController.text = DateFormat.yMMMEd().format(DateTime.now());
    super.initState();

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
    var cutitahunan = _cutitahunanController.text;
    var dispensasi = _dispensasiController.text;
    var izintidakupah = _izintidakupahController.text;
    var sakit = _sakitController;
    var absen = _absenController;
    var dinasluar = _dinasluarController.text;
    var jumlah_hari = _jumlahhariController;
    var nik = _nikController;
    var keterangan = _keteranganController;
    var name_pic = _atasnamaController.text;
    var tanggal = selectedDate;
    var tanggal2 = selectedDate2;
    // var list_pegawai = "ujicoba";
    // final idStep =  {
    switch (FirebaseAuth.instance.currentUser!.email) {
      case 'widodo@0368.nsi':
      case 'harlan@0693.nsi':
        periksa = 'yuki@takahashi.nsi';
        break;
      case 'rohmad@0167.nsi' :
      case 'mukodim@0413.nsi' :
      case 'abdulharits@0031.nsi' :
      case 'adi@0947.nsi' :
      case 'cep@0178.nsi' :
        periksa = 'widodo@0368.nsi';
        break;
      case 'samsu@0012.nsi' :
      case 'yana@0175.nsi' :
      case 'dedi@0519.nsi':
      case 'sumadi@0068.nsi' :
        periksa = 'adi@0947.nsi';
        break;
      default :
        periksa = 'salah';
        break;
    }
    debugPrint(periksa);

    CRUD(name_pengaju: name_pic,
      tanggal: tanggal,
      periksa: periksa,
      tanggal2: tanggal2,
      nik: nik.text,
      keterangan: keterangan.text,
      jumlah_hari: jumlah_hari.text,
      cutitahunan: cutitahunan,
      dispensasi: dispensasi,
      izintidakupah: izintidakupah,
      sakit: sakit.text,
      absen: absen.text,
      dinasluar: dinasluar,
    );


    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    var imel = FirebaseAuth.instance.currentUser!.email;
    return BackdropScaffold(
      backLayerBackgroundColor: Colors.lightBlueAccent,
      resizeToAvoidBottomInset: true,
      appBar: BackdropAppBar(
        backgroundColor: Colors.blue,
        title: Text('Request Cuti'),
      ),
      headerHeight: 120,
      frontLayer: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _atasnamaController,
                textInputAction: TextInputAction.next,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nama Bersangkutan',
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _nikController,
                textInputAction: TextInputAction.next,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'NIK',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _keteranganController,
                textInputAction: TextInputAction.next,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Keterangan Cuti',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _jumlahhariController,
                textInputAction: TextInputAction.next,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Jumlah Hari yang Diambil',
                ),
              ),
            ),

            // ListTile(
            //   title: const Text('Pilih Shift :'),
            //   trailing: DropdownButton(
            //     value: _butonSelected2,
            //     hint: const Text('pilih'),
            //     onChanged: (String? newValue) {
            //       if (newValue != null) {
            //         setState(() {
            //           _butonSelected2 = newValue;
            //         });
            //       }
            //     }, items: _dropDownMenuItems2,
            //   ),
            // ),

            SizedBox(height: 10),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          decoration: const InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide
                                  .none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                  ),
                  Text("Hingga"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: InkWell(
                      onTap: () {
                        _selectDate2(context);
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
                          controller: _tanggal2Controller,
                          decoration: const InputDecoration(
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
            ),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child:
                    TextFormField(
                      controller: _cutitahunanController,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Cuti Tahunan',
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _dispensasiController,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Dispensasi',
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _izintidakupahController,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Izin Tanpa Upah',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _sakitController,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Sakit',
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _absenController,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Absen',
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _dinasluarController,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Dinas Luar',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: const Text('Back'),
                          onPressed: ()  {
                            Navigator.pop(context);
                          }

                      ),
                    ),
                  ),


                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: Text('Kirim'),
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
                    ),
                  ),

                ]
            ),


          ],
        ),
      ),
      backLayer: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: FirebaseAnimatedList(
          // query: FirebaseDatabase.instance.ref().child("1WN6-rKKfO8AryfhtQ7ZbDxZcGLEM7W45Qm2I7bmmfu4/Sheet1/${(FirebaseAuth.instance.currentUser!.email).indexOf(pattern)}"),
            query: FirebaseDatabase.instance.ref().child("1WN6-rKKfO8AryfhtQ7ZbDxZcGLEM7W45Qm2I7bmmfu4/Sheet1/A${(imel)?.substring(imel.indexOf("@")+1, imel.indexOf("."))}"),
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
              // Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              // map.values.toList()[index]['id'];
              return Text('${snapshot.key}: ${snapshot.value}',
                textAlign: TextAlign.justify,
                style: GoogleFonts.roboto(fontSize: 20,),
              );
            }),
      ),
    );
  }

  Future CRUD({
    required String cutitahunan,
    required String dispensasi,
    required String izintidakupah,
    required String sakit,
    required String absen,
    required String dinasluar,
    required String jumlah_hari,
    required String name_pengaju,
    required String nik,
    required String keterangan,
    required DateTime tanggal,
    required DateTime tanggal2,
    // required String? secdept,
    required String? periksa}) async {
    final overtime = FirebaseFirestore.instance.collection('cuti');
    var inputTime = DateTime.now();
    final json = <String, dynamic>{
      'idtime': inputTime,
      'nama_pengaju': name_pengaju,
      // 'section': secdept,
      'tanggal': tanggal.toString().substring(0, 10),
      'tanggal2': tanggal2.toString().substring(0, 10),
      'stepid': periksa,
      'nik' : nik,
      'keterangan' : keterangan,
      'jumlahhari' : jumlah_hari,
      'cutitahunan' : cutitahunan,
      'dispensasi' : dispensasi,
      'tidakupah' : izintidakupah,
      'sakit' : sakit,
      'absen' : absen,
      'dinas luar' : dinasluar,

    };
    await overtime.add(json);

    //todo: add notification

    debugPrint('json: $json');
    // }
  }

}

Widget listItem({required Map id}) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    height: 80,
    color: Colors.amber,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          id['id'],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 5),
        Text(
          id['Tahun Lalu'],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 5),
        Text(
          id['Tahun ini'],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),

  );
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
  // List<Employee> list_employee = [];

  Lembur(String name_pic, String tanggal, String shift, String secdept);
}