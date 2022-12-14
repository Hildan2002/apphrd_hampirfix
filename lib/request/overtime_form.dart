import 'dart:convert';
import 'package:aplikasi_hrd/main.dart';
import 'package:aplikasi_hrd/request/ujicoba.dart';
import 'package:http/http.dart' as http;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RequestOvertime extends StatefulWidget {
  const RequestOvertime({Key? key}) : super(key: key);

  @override
  State<RequestOvertime> createState() => _RequestOvertimeState();
}

class _RequestOvertimeState extends State<RequestOvertime> {
  String nameid = FirebaseAuth.instance.currentUser!.email.toString().substring(FirebaseAuth.instance.currentUser!.email.toString().indexOf('@')+1, FirebaseAuth.instance.currentUser!.email.toString().indexOf('.'));
  String pengaju = nama[nik.indexOf(FirebaseAuth.instance.currentUser!.email.toString().substring(FirebaseAuth.instance.currentUser!.email.toString().indexOf('@')+1, FirebaseAuth.instance.currentUser!.email.toString().indexOf('.')))];
  final _formKey = GlobalKey<FormState>();
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


  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 5),
          Text('${cards.length + 1}.'),
          const SizedBox(height: 10),
          Expanded(
            child: RawAutocomplete(
                textEditingController: nameController,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return nama.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },

                fieldViewBuilder: (BuildContext context, TextEditingController texteditingcontroller,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                        autofocus: true,
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Form ini wajib diisi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Nama'

                      ),
                      controller: texteditingcontroller,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String selection) {
                          if (texteditingcontroller.text.isEmpty){
                            texteditingcontroller.text = nameController.text;
                          }
                        // nameController.text = texteditingcontroller.text;
                        // texteditingcontroller.text = nameController.text;
                      },
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                    Iterable<String> options) {
                  return Material(
                      child: SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                              child: Column(
                                children: options.map((opt) {
                                  return GestureDetector(
                                      onTap: () {
                                        onSelected(opt);
                                        nameController.text = opt;
                                        // nameController.text = nama[nama.indexOf(opt)];
                                        nikController.text = nik[nama.indexOf(opt)].toUpperCase();
                                        jamawalController.text = _butonSelected2 == "Shift 1"
                                            ? selectedDate.weekday == DateTime.friday
                                            ? "16.40" //jumat
                                            : selectedDate.weekday == DateTime.saturday || selectedDate.weekday == DateTime.sunday
                                            ? "07.00" //weekend
                                            : "16.10" //biasa
                                            : (selectedDate.weekday == DateTime.saturday || selectedDate.weekday == DateTime.sunday
                                            ? "19.00" //weekend 2
                                            : "04.10");//shift 2
                                        jamkhirController.text = _butonSelected2 == "Shift 1"
                                            ? selectedDate.weekday == DateTime.saturday || selectedDate.weekday == DateTime.sunday
                                            ? "16.10" //weekend
                                            : "19.00" //biasa
                                            : (selectedDate.weekday == DateTime.saturday || selectedDate.weekday == DateTime.sunday
                                            ? "04.10" //weekend 2
                                            : "07.00");//shift 2
                                        // if(_butonSelected2 == "Shift 1"){
                                        //   jamawalController.text = "16.10";
                                        //   if(selectedDate.weekday == DateTime.friday) jamawalController.text = "16.40";
                                        // } else if (_shiftController.text == "Shift 2") {
                                        //   jamawalController.text = "04.10";
                                        // } else {
                                        //   jamawalController.text = "Bingung";
                                        // }
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.only(right: 60),
                                          child: Card(
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(10),
                                                child: Text(opt),
                                              )
                                          )
                                      )
                                  );
                                }).toList(),
                              )
                          )
                      )
                  );
                }),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: TextFormField(
          //     validator: (value) {
          //       if (value == null || value.isEmpty) {
          //         return 'Form ini wajib diisi';
          //       }
          //       return null;
          //     },
          //     textInputAction: TextInputAction.next,
          //     controller: nameController,
          //     autofocus: true,
          //     decoration: const InputDecoration(
          //       border: UnderlineInputBorder(),
          //       labelText: 'Nama',
          //     ),
          //   ),
          // ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Form ini wajib diisi';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                controller: nikController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'NIK',
                ),
              ),
            ),
          ),

          // SizedBox(height: 5),

          Expanded(
            child: RawAutocomplete(
                textEditingController: jobController,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return kerjaan.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },

                fieldViewBuilder: (BuildContext context, TextEditingController texteditingcontroller,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      autofocus: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Form ini wajib diisi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Pekerjaan'

                      ),
                      controller: texteditingcontroller,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String selection) {
                        onFieldSubmitted();
                        // nameController.text = texteditingcontroller.text;
                        // texteditingcontroller.text = nameController.text;
                      },
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                    Iterable<String> options) {
                  return Material(
                      child: SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                              child: Column(
                                children: options.map((opt) {
                                  return GestureDetector(
                                      onTap: () {
                                        onSelected(opt);
                                        jobController.text = opt;
                                        nikController.text = nik[nama.indexOf(opt)];
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.only(right: 60),
                                          child: Card(
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(10),
                                                child: Text(opt),
                                              )
                                          )
                                      )
                                  );
                                }).toList(),
                              )
                          )
                      )
                  );
                }),
          ),

          // Expanded(
          //   child: RawAutocomplete(
          //       textEditingController: jobController,
          //       optionsBuilder: (TextEditingValue textEditingValue) {
          //         if (textEditingValue.text == '') {
          //           return const Iterable<String>.empty();
          //         }
          //         return kerjaan.where((String option) {
          //           return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          //         });
          //       },
          //
          //       fieldViewBuilder: (BuildContext context, TextEditingController texteditingcontroller,
          //           FocusNode focusNode,
          //           VoidCallback onFieldSubmitted) {
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //           child: TextFormField(
          //             autofocus: true,
          //             validator: (value) {
          //               if (value == null || value.isEmpty) {
          //                 return 'Form ini wajib diisi';
          //               }
          //               return null;
          //             },
          //                 decoration: const InputDecoration(
          //                   border: UnderlineInputBorder(),
          //                   labelText: 'Pekerjaan',
          //                   ),
          //             controller: texteditingcontroller,
          //             focusNode: focusNode,
          //             textInputAction: TextInputAction.next,
          //             onFieldSubmitted: (String selection) {
          //               jobController.text = texteditingcontroller.text;
          //             },
          //             textAlign: TextAlign.start,
          //             onChanged: (String value){
          //               jobController.text = texteditingcontroller.text;
          //             },
          //           ),
          //         );
          //       },
          //       optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
          //           Iterable<String> options) {
          //         return Material(
          //             child: SizedBox(
          //                 height: 200,
          //                 child: SingleChildScrollView(
          //                     child: Column(
          //                       children: options.map((opt) {
          //                         return GestureDetector(
          //                             onTap: () {
          //                               onSelected(opt);
          //                               jobController.text = opt;
          //                               // nikController.text = nik[nama.indexOf(opt)];
          //                             },
          //                             child: Container(
          //                                 padding: const EdgeInsets.only(right: 60),
          //                                 child: Card(
          //                                     child: Container(
          //                                       width: double.infinity,
          //                                       padding: const EdgeInsets.all(10),
          //                                       child: Text(opt),
          //                                     )
          //                                 )
          //                             )
          //                         );
          //                       }).toList(),
          //                     )
          //                 )
          //             )
          //         );
          //       }),
          // ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: TextFormField(
          //     validator: (value) {
          //       if (value == null || value.isEmpty) {
          //         return 'Form ini wajib diisi';
          //       }
          //       return null;
          //     },
          //     textInputAction: TextInputAction.next,
          //     controller: jobController,
          //     autofocus: true,
          //     decoration: const InputDecoration(
          //       border: UnderlineInputBorder(),
          //       labelText: 'Pekerjaan',
          //     ),
          //   ),
          // ),

          // SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Form ini wajib diisi dengan format hh.mm';
                  }
                  return null;
                },
                // initialValue: _shiftController.text == "Shift 1"
                //     ? selectedDate.weekday == DateTime.friday
                //     ? "16.40"
                //     : "16.10"
                //     : "04.10",
                textInputAction: TextInputAction.next,
                controller: jamawalController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Jam Awal',
                ),
              ),
            ),
          ),

          // SizedBox(height: 5),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Form ini wajib diisi dengan format "hh.mm"';
                  }
                  return null;
                },
                onFieldSubmitted: (value){
                  setState(() => cards.add(createCard()));
                },
                controller: jamkhirController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Jam Akhir',

                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          // SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  void initState() {
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
    var namePic = _tjController.text;
    var tanggal = selectedDate;
    var secdept = _butonSelected1;
    var shift = _butonSelected2;
    List<Employee> listPegawai = [];
    for (int i = 0; i < cards.length; i++) {
      var name = nameTECs[i].text;
      var nik = nikTECs[i].text;
      var job = jobTECs[i].text;
      var jamawal = jamaTECs[i].text;
      var jamkhir = jamkhirTECs[i].text;
      var format = DateFormat('HH.mm');
      var format2 = DateFormat('HH:mm');
      var awal = format.parse(jamawal);
      var akhir = format.parse(jamkhir);
      // if (akhir.isBefore(awal)) akhir = akhir.add(const Duration(hours: 24));
      // Duration beda = akhir.difference(awal);
      // //
      // String twoDigits(int n){
      //   return n.toString().padLeft(2,"0");
      // }
      // String selisih = "${twoDigits(beda.inHours)}:${twoDigits(beda.inMinutes.remainder(60))}";
      Employee employee = Employee(name, nik, job, format2.format(awal), format2.format(akhir));
      listPegawai.add(employee);
    }
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
        periksa = 'salah';
        break;
    }

    debugPrint(periksa);

    CRUD(name_pic: namePic,
      tanggal: tanggal,
      secdept: secdept,
      list: listPegawai,
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
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Pengajuan Lembur'),
            bottom: const TabBar(
              indicatorColor: Colors.lime,
              indicatorWeight: 5.0,
              labelColor: Colors.white,
              labelPadding: EdgeInsets.only(top: 10.0),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Penanggung Jawab'
                  ,
                ),
                Tab(
                  text: 'Peserta',
                )
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: TabBarView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                switch (newValue) {
                                  case 'MARKETING' :
                                    _tjController.text = 'Yujiro Takeuchi-San';
                                    break;
                                  case 'CAM':
                                  case 'CNC':
                                    _tjController.text = 'Bapak Rohmad Hidayat';
                                    // idtoken
                                    break;
                                  case 'MFG2' :
                                    _tjController.text = 'Bapak Samsu';
                                    break;
                                  case 'PPIC' :
                                    _tjController.text = 'Bapak Cep Suwandi';
                                    break;
                                  case 'ACCOUNTING' :
                                    _tjController.text = 'Bapak Harlan Budiharto';
                                    break;
                                  case 'ENGINEERING' :
                                    _tjController.text = 'Bapak Sumadi';
                                    break;
                                  case 'QA' :
                                    _tjController.text = 'Bapak Dedi Irawadi';
                                    break;
                                  case 'QC' :
                                    _tjController.text = 'Bapak Yana Suryana';
                                    break;
                                  case 'IT' :
                                  case'ADMIN':
                                  case 'MAINTENANCE' :
                                    _tjController.text = 'Bapak Widodo Bodro Husodo';
                                    break;
                                  default :
                                    _tjController.text = 'Salah Belum Input nama@';
                                    break;
                                }
                              });
                            }
                          }, items: _dropDownMenuItems,
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
                          controller: _tjController,
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Nama Penanggung Jawab',
                          ),
                        ),
                      ),

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
                          value: _butonSelected2,
                          hint: const Text('Pilih Shift'),
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
                      //   trailing: DropdownButton(
                      //     value: _butonSelected1,
                      //     hint: const Text('pilih'),
                      //     onChanged: (String? newValue) {
                      //       if (newValue != null) {
                      //         setState(() {
                      //           _butonSelected1 = newValue;
                      //         });
                      //       }
                      //     }, items: _dropDownMenuItems,
                      //   ),
                      // ),
                      //
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                     child: const Text('Tambah Peserta'),
                     onPressed: () => setState(() => cards.add(createCard()))),
                   ElevatedButton(
                     child: const Text('Kurangi Peserta'),
                     onPressed: () => setState(() => cards.removeLast())),
                     ElevatedButton(
                     child: const Text('Send'),
                     onPressed: () {
                       if(cards.length != 0){
                              if (_formKey.currentState!.validate()) {
                                _onDone();
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .where("email", isEqualTo: periksa)
                                    .get()
                                    .then((QuerySnapshot snapshot) => {
                                          if (snapshot.docs.isNotEmpty)
                                            {
                                              sendPushMessage(
                                                  (snapshot.docs.first.data()
                                                      as Map)["tokens"]),
                                              debugPrint((snapshot.docs.first
                                                  .data() as Map)["tokens"]),
                                              ElegantNotification.success(
                                                title: const Text('Berhasil'),
                                                description: const Text(
                                                    'Anda Berhasil mengirim request overtime'),
                                                notificationPosition:
                                                    NotificationPosition.top,
                                                // dismissible: true,
                                              ).show(context)
                                            }
                                        });
                              }
                            }
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

                 const SizedBox(height: 40)

               ],
             ),
                ]
            ),
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
      'status' : 'proses',
      'email' : '${FirebaseAuth.instance.currentUser!.email}',
      'nama_pengaju': pengaju,
      'captanggal' : DateTime.now().toString()
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

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({super.key});

  static const List<String> _kOptions = <String>[
    'aardvark paling cool',
    'bobcat',
    'chameleon',
  ];
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}