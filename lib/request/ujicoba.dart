import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'cuti_form.dart';

class UjiCoba extends StatefulWidget {
  const UjiCoba({Key? key}) : super(key: key);

  @override
  State<UjiCoba> createState() => _UjiCobaState();
}

class _UjiCobaState extends State<UjiCoba> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
      appBar: AppBar(
        title: const Text("UjiCoba"),
      ),
      body: ElevatedButton(
          style:
          TextButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['png', 'jpg', 'jpeg'],
            );

            if (result == null){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('No File Selected.')
                  )
              );
              return;
            }

            // final path = result.files.single.path;
            final Uint8List? fileBytes = result.files.first.bytes;
            final fileName = result.files.first.name;

            await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes!);

            // storage
            //     .uploadFile(fileBytes!, fileName)
            //     .then((value) => print('Done'));
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
          child: Text(
            'Upload Bukti Surat Dokter',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
