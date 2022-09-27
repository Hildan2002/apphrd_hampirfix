import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_hrd/main.dart';
import 'package:aplikasi_hrd/request/ujicoba.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:backdrop/backdrop.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RequestCuti extends StatefulWidget {
  const RequestCuti({Key? key}) : super(key: key);

  @override
  State<RequestCuti> createState() => _RequestCutiState();
}


class _RequestCutiState extends State<RequestCuti> {
  final storage = FirebaseStorage.instance;
  // File? image;
  // File? _pickedImage;
  File? _pickerImage;
  Uint8List webImage = Uint8List(8);

  final _formKey = GlobalKey<FormState>();

  // Future<File> compressFile(File file) async{
  //   File compressedFile = await FlutterNativeImage.compressImage(file.path,
  //     quality: 5,);
  //   return compressedFile;
  // }

  // Future getImage() async {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clear 2")));
  //   if(!kIsWeb){
  //     final ImagePicker _picker = ImagePicker();
  //     XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 640);
  //     if(image != null){
  //       var selected = File(image.path);
  //       setState(() {
  //         _pickedImage = selected;
  //         // _pickedImage = compressFile(selected);
  //       });
  //     } else{
  //       debugPrint('error mas');
  //     }
  //   } else if (kIsWeb){
  //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clear 3")));
  //     final ImagePicker _picker = ImagePicker();
  //     XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //     if(image != null){
  //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clear 4")));
  //       var f = await image.readAsBytes();
  //       setState(() {
  //           webImage = f;
  //           _pickedImage = File('a');
  //       });
  //     } else{
  //       debugPrint('error mas');
  //     }
  //   } else {
  //     debugPrint('ana sing error');
  //   }
  //   // final ImagePicker _picker = ImagePicker();
  //   // final XFile? imagePicked =
  //   //     await _picker.pickImage(source: ImageSource.gallery);
  //   // if (kIsWeb) {
  //   //   Image.network(imagePicked!.path);
  //   // } else {
  //   //   image = File(imagePicked!.path);    }
  //   // setState(() {});
  // }

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
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

  static const menuItems = <String>[
    'CAM',
    'CNC',
    'MFG2',
    'MAINTENANCE',
    'MARKETING',
    'PPIC',
    'IT',
    'ACCOUNTING',
    'ADMIN',
    'ENGINEERING',
    'QA',
    'QC',
  ];

  static const menuItems2 = <String>[
    'Shift 1',
    'Shift 2'
  ];


  String? _butonSelected1;
  String? _butonSelected2;

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


  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        selectableDayPredicate: (DateTime val) =>
          val.weekday == 6 || val.weekday == 7 ? false : true,
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _tanggalController.text = DateFormat.yMMMEd().format(selectedDate);
        tanggalOtomatis(_tanggalController.text, harii: _jumlahhariController.text);
      });
    }
  }

  String? dateTime2;
  bool lampiran = false;

  DateTime selectedDate2 = DateTime.now();

  TimeOfDay time2 = const TimeOfDay(hour: 10, minute: 30);

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        initialDatePickerMode: DatePickerMode.day,
        selectableDayPredicate: (DateTime val) =>
        val.weekday == 6 || val.weekday == 7 ? false : true,
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
    _tanggalController.text = DateFormat.yMMMEd().format(DateTime.now());
    _tanggal2Controller.text = DateFormat.yMMMEd().format(DateTime.now());
    super.initState();

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      Navigator.pushNamed(
        context,
        '/message',
      );
    });

  }

  String? periksa;
  String nameid = FirebaseAuth.instance.currentUser!.email.toString().substring(FirebaseAuth.instance.currentUser!.email.toString().indexOf('@')+1, FirebaseAuth.instance.currentUser!.email.toString().indexOf('.'));
  String pengaju = nama[nik.indexOf(FirebaseAuth.instance.currentUser!.email.toString().substring(FirebaseAuth.instance.currentUser!.email.toString().indexOf('@')+1, FirebaseAuth.instance.currentUser!.email.toString().indexOf('.')))];
  // String pengaju = FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf('@'));

  _onDone() {
    debugPrint("ondony");
    var cutitahunan = _cutitahunanController.text;
    var dispensasi = _dispensasiController.text;
    var izintidakupah = _izintidakupahController.text;
    var sakit = _sakitController;
    var absen = _absenController;
    var dinasluar = _dinasluarController.text;
    var jumlahHari = _jumlahhariController;
    // var nik = _nikController;
    var keterangan = _keteranganController;
    // var namePic = _atasnamaController.text;
    DateTime tanggal = selectedDate;
    DateTime tanggal2 = selectedDate2;
    var secdept = _butonSelected1;
    // var list_pegawai = "ujicoba";
    // final idStep =  {
    switch (secdept) {
      case 'MARKETING' :
        periksa = 'yujiro@takeuchi.nsi';
        break;
      case 'CAM':
      case 'CNC':
        periksa = 'rohmad@0167.nsi';
        // idtoken
        break;
      case 'MFG2' :
        periksa = 'samsu@0012.nsi';
        break;
      case 'PPIC' :
        periksa = 'cep@0178.nsi';
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
        periksa = 'salah@';
        break;
    }
    debugPrint(periksa);

    debugPrint("name_pengaju "+ pengaju);
    debugPrint("nik "+ nameid);

    CRUD(
      name_pengaju: pengaju,
      nik: nameid,
      tanggal: tanggal,
      secdept: secdept,
      periksa: periksa,
      tanggal2: tanggal2,
      shift: _butonSelected2,
      keterangan: keterangan.text,
      jumlah_hari: jumlahHari.text,
      cutitahunan: cutitahunan,
      dispensasi: dispensasi,
      izintidakupah: izintidakupah,
      sakit: sakit.text,
      absen: absen.text,
      dinasluar: dinasluar,
      adaFile: lampiran
    );


    Navigator.pop(context);

  }

  String? path, pathWeb, filenamec;
  Uint8List? fileBytes;

  // static const List<String> _kOptions = <String>[
  //   'aardvark',
  //   'bobcat',
  //   'chameleon',
  // ];

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    var imel = FirebaseAuth.instance.currentUser!.email;
    return BackdropScaffold(
          backLayerBackgroundColor: Colors.lightBlueAccent,
          resizeToAvoidBottomInset: true,
          appBar: BackdropAppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Pengajuan Cuti',
               style: TextStyle(
                 color: Colors.black54
               ),
            ),
          ),
          headerHeight: 120,
          frontLayer: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //   child: Autocomplete<String>(
                        //     optionsBuilder: (TextEditingValue textEditingValue) {
                        //   if (textEditingValue.text == '') {
                        //   return const Iterable<String>.empty();
                        //   }
                        //   return _kOptions.where((String option) {
                        //
                        //   return option.contains(textEditingValue.text.toLowerCase());
                        //
                        //   });
                        //   },
                        //     onSelected: (String selection) {
                        //       debugPrint('You just selected $selection');
                        //     },
                        //   ),
                        // ),

                        // RawAutocomplete(
                        //     optionsBuilder: (TextEditingValue textEditingValue) {
                        //       if (textEditingValue.text == '') {
                        //         return const Iterable<String>.empty();
                        //       }
                        //       return nama.where((String option) {
                        //         return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        //       });
                        //     },
                        //
                        //     fieldViewBuilder: (BuildContext context, TextEditingController texteditingcontroller,
                        //         FocusNode focusNode,
                        //         VoidCallback onFieldSubmitted) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //         child: TextFormField(
                        //           autofocus: true,
                        //           validator: (value) {
                        //             if (value == null || value.isEmpty) {
                        //               return 'Form ini wajib diisi';
                        //             }
                        //             return null;
                        //           },
                        //           decoration: const InputDecoration(
                        //               border: UnderlineInputBorder(),
                        //               labelText: 'Nama'
                        //
                        //           ),
                        //           controller: texteditingcontroller,
                        //           focusNode: focusNode,
                        //           textInputAction: TextInputAction.next,
                        //           onFieldSubmitted: (String selection) {
                        //             _atasnamaController.text = texteditingcontroller.text;
                        //           },
                        //         ),
                        //       );
                        //     },
                        //     optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                        //         Iterable<String> options) {
                        //       return Material(
                        //           child: SizedBox(
                        //               height: 200,
                        //               child: SingleChildScrollView(
                        //                   child: Column(
                        //                     children: options.map((opt) {
                        //                       return GestureDetector(
                        //                           onTap: () {
                        //                             onSelected(opt);
                        //                             _nikController.text = nik[nama.indexOf(opt)];
                        //                           },
                        //                           child: Container(
                        //                               padding: const EdgeInsets.only(right: 60),
                        //                               child: Card(
                        //                                   child: Container(
                        //                                     width: double.infinity,
                        //                                     padding: const EdgeInsets.all(10),
                        //                                     child: Text(opt),
                        //                                   )
                        //                               )
                        //                           )
                        //                       );
                        //                     }).toList(),
                        //                   )
                        //               )
                        //           )
                        //       );
                        //     }),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //   child: TextFormField(
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Form ini wajib diisi';
                        //       }
                        //       return null;
                        //     },
                        //     controller: _atasnamaController,
                        //     textInputAction: TextInputAction.next,
                        //     // autofocus: true,
                        //     decoration: const InputDecoration(
                        //       border: UnderlineInputBorder(),
                        //       labelText: 'Nama Bersangkutan',
                        //     ),
                        //   ),
                        // ),


                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //   child: TextFormField(
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Form ini wajib diisi, apabila lupa maka dapat menekan tombol di pojok kiri atas';
                        //       }
                        //       return null;
                        //     },
                        //     controller: _nikController,
                        //     textInputAction: TextInputAction.next,
                        //     // autofocus: true,
                        //     decoration: const InputDecoration(
                        //       border: UnderlineInputBorder(),
                        //       labelText: 'NIK',
                        //     ),
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Form ini wajib diisi';
                              }
                              return null;
                            },
                            controller: _keteranganController,
                            textInputAction: TextInputAction.next,
                            // autofocus: true,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Form ini wajib diisi';
                              }
                              return null;
                            },
                            controller: _jumlahhariController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (String hariii){
                              tanggalOtomatis(_tanggalController.text, harii: hariii);
                            },
                            // autofocus: true,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Jumlah Hari yang Diambil',
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Form ini wajib dipilih';
                              }
                              return null;
                            },
                            value: _butonSelected2,
                            hint: Text('Pilih Shift'),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _butonSelected2 = newValue;
                                });
                              }
                            }, items: _dropDownMenuItems2,
                          ),
                        ),

                        // ListTile(
                        //   title: const Text('Pilih Department :'),
                        //   trailing:
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: DropdownButtonFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Form ini wajib dipilih';
                                }
                                return null;
                              },
                              value: _butonSelected1,
                              hint: const Text('Pilih Department'),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _butonSelected1 = newValue;
                                  });
                                }
                              }, items: _dropDownMenuItems,
                            ),
                          ),
                        // ),

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

                        const SizedBox(height: 10),

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
                                    margin: const EdgeInsets.only(top: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),),
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 20),
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
                              const Text("Hingga"),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    _selectDate2(context);
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),),
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 20),
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
                                  // autofocus: true,
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
                                  // autofocus: true,
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
                                  // autofocus: true,
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
                                  // autofocus: true,
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
                                  // autofocus: true,
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
                                  // autofocus: true,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Dinas Luar',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _pickerImage != null
                                  ? GestureDetector(
                                    onTap: (){
                                      fullSizeNih(context);
                                      },
                                    child: Hero(
                                      tag: "nihBuktiNih",
                                      child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: kIsWeb?Image.file(_pickerImage!, fit: BoxFit.cover,): Image.file(_pickerImage!, fit: BoxFit.cover,)
                                  ),
                                ),
                              )
                                  : Container(),

                            ],
                          ),
                        ),

                        Center(
                          child: ElevatedButton(
                              style: TextButton.styleFrom(backgroundColor: Colors.blueAccent, maximumSize: MediaQuery.of(context).size),
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
                                );

                                if (result == null){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('No File Selected.')
                                      )
                                  );
                                  return;
                                } else {
                                  if(kIsWeb){
                                    fileBytes = result.files.first.bytes;
                                    filenamec = result.files.first.name;
                                    pathWeb = File.fromRawPath(fileBytes!).path;

                                    debugPrint(filenamec);

                                    // await FirebaseStorage.instance.ref("cuti/$filename").putData(fileBytes);
                                    setState((){
                                      _pickerImage = File.fromRawPath(fileBytes!);
                                    });
                                    // _pickerImage = File.fromRawPath(fileBytes);
                                  } else {
                                    path = result.files.single.path;
                                    setState(() {
                                      _pickerImage = File((result.files.single.path)!);
                                    });
                                  }
                                }
                                // try{
                                //   getImage();
                                // } catch (error){
                                //   ElegantNotification.error(
                                //     title: Text('Berhasil'),
                                //     description: Text('$error'),
                                //     notificationPosition: NotificationPosition.top,
                                //     dismissible: true,
                                //   ).show(context);
                                // }
                              },
                              child: const Text(
                                  'Upload Surat Keterangan Dokter',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),

                        const SizedBox(height: 20),

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
                                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clear")));
                                      Navigator.pop(context);
                                      // try{
                                      //   getImage();
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clear 1")));
                                      // } catch (error){
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error 1")));
                                      //   ElegantNotification.error(
                                      //     title: Text('Berhasil'),
                                      //     description: Text('$error'),
                                      //     notificationPosition: NotificationPosition.top,
                                      //     dismissible: true,
                                      //   ).show(context);
                                      // }
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
                                    child: const Text('Kirim'),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if(kIsWeb){
                                          if (fileBytes != null) {
                                            lampiran = true;
                                            await FirebaseStorage.instance.ref().child("cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}${filenamec!.substring(filenamec!.indexOf("."))}")
                                              .putData(fileBytes!);
                                          }
                                        } else {
                                          if (path != null) {
                                            lampiran = true;
                                            storage
                                              .uploadFile(path!, FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf(".")))
                                          //baca dari url: "gs://apphrd.appspot.com/cuti/"+FirebaseAuth.instance.currentUser!.uid.toString()
                                              .then((value) => print('Done'));
                                          }
                                        }
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
                                          title: const Text('Berhasil'),
                                          description: const Text('Anda Berhasil mengirim request cuti'),
                                          notificationPosition: NotificationPosition.top,
                                          // dismissible: true,
                                        ).show(context);
                                      }
                                    }
                                ),
                              ),
                            ),

                          ]
                        ),
                      ],
                    ),
            ),
          ),
                  backLayer: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: FirebaseAnimatedList(
                          query: FirebaseDatabase.instance.ref().child("1WN6-rKKfO8AryfhtQ7ZbDxZcGLEM7W45Qm2I7bmmfu4/Sheet1/A${(imel)?.substring(imel.indexOf("@")+1, imel.indexOf("."))}"),
                          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
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
    required String? shift,
    required String name_pengaju,
    required String nik,
    required String keterangan,
    required DateTime tanggal,
    required DateTime tanggal2,
    required String? secdept,
    required String? periksa,
    required bool adaFile}) async {
    final cutii = FirebaseFirestore.instance.collection('cuti');
    var inputTime = DateTime.now();
    // String alamaaat = kIsWeb ? "cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}${filenamec!.substring(filenamec!.indexOf("."))}" : "cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}";
    // String buktiiii = kIsWeb ? await FirebaseStorage.instance.ref().child("cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}${filenamec!.substring(filenamec!.indexOf("."))}").getDownloadURL() : await FirebaseStorage.instance.ref().child("cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}").getDownloadURL();


    final json = <String, dynamic>{
      'idtime': inputTime,
      'nama_pengaju': name_pengaju,
      'section': secdept,
      'tanggal': tanggal.toString().substring(0, 10),
      'tanggal2': tanggal2.toString().substring(0, 10),
      'stepid': periksa,
      'nik' : nik,
      'keterangan' : keterangan,
      'jumlahhari' : jumlah_hari,
      'shift' : shift,
      'cutitahunan' : cutitahunan,
      'dispensasi' : dispensasi,
      'tidakupah' : izintidakupah,
      'sakit' : sakit,
      'absen' : absen,
      'dinas luar' : dinasluar,
      'status' : 'proses',
      'email' : '${FirebaseAuth.instance.currentUser!.email}',
      'alamatfile' : adaFile ? kIsWeb ? "cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}${filenamec!.substring(filenamec!.indexOf("."))}" : "cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}"
        : "",
      'bukti' : adaFile ?  kIsWeb ? await FirebaseStorage.instance.ref().child("cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}${filenamec!.substring(filenamec!.indexOf("."))}").getDownloadURL() : await FirebaseStorage.instance.ref().child("cuti/${FirebaseAuth.instance.currentUser!.email.toString().substring(0, FirebaseAuth.instance.currentUser!.email.toString().indexOf("."))}").getDownloadURL()
        : "",
      'captanggal' : DateTime.now().toString()

    };
    await cutii.add(json);

    //todo: add notification

    debugPrint('json: $json');
    // }
  }

  fullSizeNih(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
        Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
                },
              child: Hero(
                tag: "nihBuktiNih",
                child: kIsWeb?Image.memory(
                  _pickerImage!.readAsBytesSync(),):Image.file(_pickerImage!),

              ),
            ),
          ),
        )
    ));
  }

  void tanggalOtomatis(String dateTimeee,
      {String harii = "1"}) {
    DateTime tanggalBaru = DateFormat('EEE, MMM dd, yyyy').parse(dateTimeee);
    if (harii != ""){
      var x = int.parse(harii);
      while (x > 1){
        do {
          tanggalBaru = tanggalBaru.add(Duration(days: 1));
        } while (tanggalBaru.weekday == DateTime.saturday || tanggalBaru.weekday == DateTime.sunday);
        x--;
      }
      selectedDate2 = tanggalBaru;
      _tanggal2Controller.text = DateFormat.yMMMEd().format(tanggalBaru);
    } else {
      _tanggal2Controller.text = DateFormat.yMMMEd().format(selectedDate);
    }
    // harii != ''  ? _tanggal2Controller.text = DateFormat.yMMMEd().format(DateTime.now().add(Duration(days: int.parse(harii)))) : _tanggal2Controller.text = DateFormat.yMMMEd().format(DateTime.now());
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
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 5),
        Text(
          id['Tahun Lalu'],
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 5),
        Text(
          id['Tahun ini'],
          style: const TextStyle(
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

class Storage{
  final storage = FirebaseStorage.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);

    try{
      await storage.ref('cuti/$fileName').putFile(file);
    } on FirebaseException catch (e){
      print(e);
    }


  }

}
