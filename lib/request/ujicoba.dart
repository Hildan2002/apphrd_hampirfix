import 'package:flutter/material.dart';
// import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class Person {
  Person(this.name, this.address);
  final String name, address;
  @override
  String toString() => name;
}

class UjiCoba extends StatefulWidget {
  const UjiCoba({Key? key}) : super(key: key);

  @override
  State<UjiCoba> createState() => _UjiCobaState();
}

List<String> nama = ["Ayuandini Thriziska Suhendi",
"Eko Dida Prasetya",
"Harlan Budiharto",
"Mohammad Hibban Ferdhana",
"Nanang Bin Darpi",
"Parmanti",
"Rahimah Saleh",
"Resha Eka Yuliyanto",
"Umi Wakhidah",
"Widodo Bodro H",
"Yuni Sasfiranti",
"Zhalilla Viola Risqa Setiani",
"Zubair Affandi",
"Agustian Budi Arianto",
"Antonio Ruriansyah",
"Damanhuri",
"Darsono",
"Dedi Handoko",
"Endang Soemadi",
"Erik Setiawan",
"Faisal Maulana (CAM)",
"Haerul Hasan Basri",
"Haryono",
"Idi Rohidi",
"Mochamad Ridho Susilo",
"Mustafa Husen",
"Pramuji Rahmat Prihatin",
"Ridho Murtiadi",
"Solikhin",
"Sutandria",
"Usman Abdul R",
"Yulian Hartanto",
"Abdul Azis",
"Abdul Haris",
"Abdul Holik",
"Abidin",
"Achmad Jauhari",
"Ade Suhendar",
"Afdol Solihin",
"Agung Prasetiyo",
"Agung Susilo",
"Agus Riyadi",
"Ahmad Ristanto",
"Annas Yuda Laksana",
"Ari Triwidodo",
"Arif Handaru",
"Asmun Mundari",
"Bayu Setiaji",
"Catur Rochani",
"Chaerul Rossid",
"Chairulloh",
"Daryanto",
"Deni Syaifunida",
"Dian Firmansyah",
"Dian Rizky Putra Pambayun",
"Didi Mulyadi",
"Didi Wahyudi",
"Dwi Apriyanto",
"Eka Candra",
"Eka Nurjana",
"Eka Putriningsih",
"Eki Cahya Ridhowi",
"Elisa Cahya Setyaningsih",
"Fajar Igo Saputra",
"Feri Budiyono",
"Gustia Gita Komara",
"Herdanu Murtioko",
"Ign Dwi Prabowo",
"Ipong Yopianto",
"Irwansyah",
"Julius Doni Saputra",
"Julius Yusuf",
"Jumadi",
"Khairul Umam",
"Lilis Mardiyanti",
"Meli Sagita",
"Mohammad Ramdhoni",
"Muhamad Aziz Saleh",
"Muhamad Bahtiar",
"Muhamad Efendi",
"Muhammad Afandi",
"Muhammad Erfa Efendi",
"Muhammad Rheihan",
"Mukodim",
"Naib Mufasil",
"Nanang Kosim",
"Nila Hasanatunnisa",
"Nir Wahyu Waluyo",
"Pebi Yuliandri",
"Rahadi Budianto",
"Rahayu Tri Wahyuni",
"Riska Sulistiyani",
"Rohmad Hidayat",
"Roni Saputra",
"Rony Wijayanto",
"Rudi Gunawan",
"Rudy Hervian",
"Saiful Ahmad",
"Satya Kismanto",
"Sonny Aristianto",
"Sukendi",
"Suratno (CNC)",
"Suryadi Haryanto",
"Sutarso",
"Taufik Setiawan",
"Tri Purwanti",
"Teguh Widianto",
"Wagiyono",
"Wilda Setiani",
"Wildan Shofiyandi",
"Yachubus Rawadi",
"Yakobus Rhio Widodo",
"Yan Ari Rizki",
"Yosep Cherry Ramartaji",
"Yuda Pramono",
"Anang Kus Wicaksono",
"Desti Retnowati",
"Riandika Satia Nugraha",
"Sumadi",
"Wahyu Haidar Pratama",
"Dede Arsika Lubis",
"Florentinus Lintang Wahyu N",
"Ris Ardianto",
"Royadi",
"Achmad Sabilah",
"Adi Mulyadi",
"Ardi Pranoto",
"Ari Styono",
"Arif Hartanto",
"Asep Ridiansah",
"Bayi Rahman",
"Cahyani Nurlaeli",
"Catur Rinawati",
"Cecep Supriadi",
"Dafhi Setiyawan",
"Diana Nengsih",
"Didin Solahudin",
"Eko Sasongko",
"Eko Widoyono",
"Eva Nur Afifah",
"Fadhilatul Hidayah",
"Farid Nur Rochmat",
"Febri Kurnia",
"Hadi Sumanto",
"Hadi Widiyanto",
"Hana Pertiwi",
"Harun Al Rasyid",
"Hasan Basri",
"Hellen Vidiana",
"Heri Heryanto",
"Heri Siswanto",
"Imam Purwanto",
"Indra Wahyudi",
"Irmawati",
"Ita Aditya Sinar Dewi",
"Jahidin",
"Jenal Abidin",
"Jihan Faiza",
"Joni Hidayat",
"Kurniawan",
"Lulu Nurul Sintayani",
"Mahbub Soleh",
"Mohamad Najib Al Hikam",
"Muhamad Al Fajri",
"Muhamad Irfan",
"Muslimin",
"Natika Anggraeni",
"Parjono",
"Priyo Handono",
"Puri Maya Andini",
"Purwoto",
"Putri Irma Suryani",
"Raehan",
"Ratu Dhinar Bilqisty",
"Reza Banu Iman Saputro",
"Reza Septian Andrianto",
"Ria Sulistiyani",
"Riyan Fitria Wulandari",
"Rizki Wahyu Widayati",
"Salis Solikhah",
"Samsu",
"Stevanus Wahyu Prihantoro",
"Subendi",
"Suherman",
"Sukarno",
"Surohman",
"Suryadi (MFG2)",
"Syafrina Afrillia",
"Tomik",
"Toto Sunarto",
"Umi Nuryani",
"Untung Bairul M",
"Wasim",
"Winda Sulistia Ningsih",
"Yahya Ibrahim",
"Yanwar Sapta Hadi",
"Yeni Herawati",
"Yusup Witono",
"Zam Zam Maskur",
"Agus Salim",
"Ahmad Kurtubi",
"Alvin Maycelino Lukito",
"Angkyn Widcaksana Ilmawati",
"Antoni",
"Aris Supriyanto",
"Bambang Hariyanto",
"Budi Irawan",
"Cep Suwandi",
"Dina Irmayanti",
"Erdin Syarifudin",
"Evin Dondri",
"Faisal Maulana",
"Ida Wahyuni",
"Karyadi",
"Muhamad Faizal",
"Mursodik",
"Pasha Dwi Mahendra",
"Priyanto",
"Reza Fidiati",
"Riyadi",
"Saifun Ni'am",
"Setia Utaminingtyas",
"Solihin Hidayat",
"Veri Yuli Yantorio",
"Wandi Ahmad S",
"Dedi Irawadi",
"Hartono",
"Manung Suranto",
"Moch Hari Purnomo",
"Tetty Filawati",
"Adi Prasodjo",
"Adistie Dita Saputri",
"Ainun Noviana",
"Aisyah Nurhusna",
"Ambar Afriyani",
"Ana Febrina",
"Arif Rahman",
"Audia Awali",
"Ayu Ratna Ningsih",
"Azuardi",
"Basyarani Ursha",
"Binah",
"Bovi Ferdiansa",
"Diyan Supriyadi",
"Endang Trimurtini",
"Erna Diana Astuti",
"Ery Safitri",
"Etik Lestari",
"Fauziarti",
"Fika Dian Pratami",
"Fitri Rahmawati",
"Ikhda Fitrotunnisa",
"Irma Ayu Santika",
"Jesi Nur Rochmawati",
"Junita",
"Justiawan Indra Atmaja",
"Kokok Susilo",
"Lia Yunita",
"Lilis Handayani",
"Mad Saefurohman",
"Malahayati",
"Mayasari",
"Muki",
"Muslimatun",
"Nanditha Shendi Thriziska",
"Novan Wicaksono",
"Novi Dwi Santoso",
"Novi Sari Handayani",
"Novi Utami",
"Novia Tri Handayani",
"Nurhidayatul Laili",
"Nuril Amelia",
"Nurul Alfiyani",
"Nurul Komariyah",
"Nuswantari",
"Oktivianne Nurertha K",
"Puji Rahayu",
"Rani Riswanti",
"Rifani Madjid",
"Rikha Susanti",
"Rinna Untari",
"Riyana",
"Rizka Novining Dias",
"Romasti Naomi Hutauruk",
"Rosimah",
"Rosinih",
"Rully Hendriyanto",
"Siti Aliyah",
"Siti Aulia Yulistia",
"Siti Jamangatun",
"Siti Kartini",
"Siti Rifa'atul H",
"Soleh Ibnu",
"Sri Sulastri",
"Susi Listiani",
"Suyatno Surtana",
"Tri Kuati",
"Tutut Rizki Pramudita",
"Uki Indra Perwitasari",
"Wahyu Deriana",
"Wahyu Setiadi",
"Weni Rezeki",
"Wiji Lestari",
"Yana Suryana",
"Yohanes Alferdo Oktama",
"Yustina Widhianti"];
List<String> nik = [
  "0916",
  "0921",
  "0693",
  "0985",
  "r0782",
  "01009",
  "OJT684",
  "OJT690",
  "0832",
  "0368",
  "OJT702",
  "0962",
  "0589",
  "0908",
  "0510",
  "0144",
  "0004",
  "0999",
  "0149",
  "0120",
  "0963",
  "OJT704",
  "OJT686",
  "0010",
  "0919",
  "0225",
  "OJT679",
  "01010",
  "OJT710",
  "0117",
  "0237",
  "OJT657",
  "0224",
  "0031",
  "0190",
  "0152",
  "OJT699",
  "0064",
  "0935",
  "0240",
  "0939",
  "0948",
  "0191",
  "r0856",
  "0940",
  "OJT663",
  "0193",
  "OJT687",
  "0907",
  "0909",
  "0103",
  "r0867",
  "0904",
  "OJT701",
  "0910",
  "0353",
  "0420",
  "0427",
  "0354",
  "OJT703",
  "0905",
  "0965",
  "0964",
  "OJT713",
  "01011",
  "0983",
  "0995",
  "r0664",
  "r0865",
  "0147",
  "0949",
  "0080",
  "0899",
  "0917",
  "OJT717",
  "0941",
  "0125",
  "OJT722",
  "OJT719",
  "r0814",
  "0171",
  "OJT700",
  "OJT712",
  "0413",
  "0994",
  "0124",
  "0976",
  "0966",
  "OJT693",
  "0101",
  "0934",
  "OJT718",
  "0167",
  "0933",
  "0203",
  "0906",
  "r0849",
  "0777",
  "0137",
  "01012",
  "0142",
  "0174",
  "0238",
  "0112",
  "OJT677",
  "r0896",
  "0239",
  "0202",
  "0942",
  "0961",
  "0053",
  "r0743",
  "0100",
  "r0740",
  "0110",
  "0998",
  "r0895",
  "0402",
  "0068",
  "0988",
  "0760",
  "0981",
  "OJT697",
  "0121",
  "0186",
  "0217",
  "0931",
  "0213",
  "01006",
  "0943",
  "0231",
  "OJT680",
  "01000",
  "0123",
  "0923",
  "OJT706",
  "01004",
  "0244",
  "0166",
  "OJT692",
  "0901",
  "OJT714",
  "OJT695",
  "0164",
  "0214",
  "0977",
  "0247",
  "0185",
  "OJT708",
  "0141",
  "0073",
  "0230",
  "0223",
  "OJT721",
  "OJT709",
  "0235",
  "0226",
  "OJT720",
  "0040",
  "0091",
  "0900",
  "0967",
  "01013",
  "0969",
  "01005",
  "0938",
  "OJT665",
  "0184",
  "0097",
  "0996",
  "0215",
  "0951",
  "0970",
  "0913",
  "0925",
  "0936",
  "OJT705",
  "OJT675",
  "OJT682",
  "0950",
  "0012",
  "0924",
  "0930",
  "0074",
  "0216",
  "0229",
  "0236",
  "0920",
  "0232",
  "0154",
  "0971",
  "0206",
  "0153",
  "0911",
  "0132",
  "0968",
  "OJT661",
  "0127",
  "OJT694",
  "r0824",
  "01007",
  "0891",
  "0932",
  "OJT711",
  "0099",
  "r0753",
  "0789",
  "0178",
  "OJT707",
  "0915",
  "0761",
  "0808",
  "r0543",
  "r0787",
  "OJT664",
  "0997",
  "OJT715",
  "r0650",
  "0980",
  "0881",
  "0974",
  "OJT696",
  "01003",
  "0979",
  "0205",
  "0519",
  "0377",
  "0762",
  "0208",
  "0033",
  "0947",
  "0958",
  "0978",
  "0991",
  "0954",
  "OJT716",
  "0098",
  "01014",
  "01015",
  "0176",
  "0946",
  "0050",
  "OJT723",
  "OJT674",
  "0029",
  "0914",
  "OJT673",
  "0831",
  "0057",
  "0955",
  "OJT683",
  "01016",
  "OJT691",
  "01001",
  "0081",
  "01017",
  "0063",
  "0222",
  "0982",
  "0076",
  "0918",
  "0975",
  "0018",
  "0993",
  "0972",
  "01018",
  "0071",
  "0990",
  "0220",
  "0956",
  "r0734",
  "0945",
  "0898",
  "0952",
  "0048",
  "OJT658",
  "0959",
  "OJT668",
  "0902",
  "0129",
  "0989",
  "0957",
  "OJT669",
  "0072",
  "0020",
  "01002",
  "01008",
  "0987",
  "OJT671",
  "0165",
  "0953",
  "0210",
  "0912",
  "0085",
  "01019",
  "0209",
  "0903",
  "0973",
  "0201",
  "OJT698",
  "OJT659",
  "0992",
  "0926",
  "0175",
  "r0665",
  "r0893"
];
List<String> kerjaan = [
  'Input Doc Epson',
  'Input Doc Request',
  'CS',
  'Support QC',
  'Repair Mesin',
  'WH',
  'Control',
  'Setting Mesin',
  'Burry',
  'CG',
  'Brother',
  'Run Machine',
  'Sortir',
  'Killer',
  'Stopper',
  'NID',
  'OQC',
];

class _UjiCobaState extends State<UjiCoba> {
  // final a = FirebaseFirestore.instance.collection('users').snapshots();
  List<Person> people = [];

  // a.length
  // a.forEach()
  // final people = <Person>[Person('Alice', '123 Main'), Person('Bob', '456 Main')];
  // final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  String? selectedLetter;
  Person? selectedPerson;

  final formKey = GlobalKey<FormState>();

  bool autovalidate = false;
  @override
  Widget build(BuildContext context) {
    // for (var i = 0; i < nama.length; i++){
    //   people.add(Person(nama[i], nik[i]));
    // }
    TextEditingController nikController = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: const Text('title')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: [
                  Container(
                      alignment : Alignment.centerLeft,
                      child: const Text("Nama", textAlign: TextAlign.start,)
                  ),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return nama.where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      nikController.text = nik[nama.indexOf(selection)];
                    },
                  ),
                ],
              ),
            ),
            Padding(
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
            Container(
              alignment: Alignment.bottomLeft,
                child: const Text('Kerjaan', textAlign: TextAlign.start,)
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return kerjaan.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
            ),
            RawAutocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return nama.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },

              fieldViewBuilder: (BuildContext context, TextEditingController nama,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                //   validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Form ini wajib diisi';
                //   }
                //   return null;
                // },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  controller: nama,
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {

                  },
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
                              return InkWell(
                                  onTap: () {
                                    onSelected(opt);
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
          ],


          //     Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Form(
          //     key: formKey,
          //     autovalidateMode: autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
          //     child: ListView(children: <Widget>[
          //       SizedBox(height: 16.0),
          //       Text('Selected person: "$selectedPerson"'),
          //       Text('Selected letter: "$selectedLetter"'),
          //       SizedBox(height: 16.0),
          //       SimpleAutocompleteFormField<Person>(
          //         controller: namahihi,
          //         decoration: InputDecoration(labelText: 'Person', border: OutlineInputBorder()),
          //         suggestionsHeight: 80.0,
          //         itemBuilder: (context, person) => Padding(
          //           padding: EdgeInsets.all(8.0),
          //           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //             Text(person!.name, style: TextStyle(fontWeight: FontWeight.bold)),
          //             Text(person.address)
          //           ]),
          //         ),
          //         onSearch: (search) async => people
          //             .where((person) =>
          //         person.name.toLowerCase().contains(search.toLowerCase()) ||
          //             person.address.toLowerCase().contains(search.toLowerCase()))
          //             .toList(),
          //         itemFromString: (string) {
          //           final matches = people.where((person) => person.name.toLowerCase() == string.toLowerCase());
          //           return matches.isEmpty ? null : matches.first;
          //         },
          //         onChanged: (value) => setState(() => selectedPerson = value.name),
          //         onSaved: (value) => setState(() => namahihi.text = value.name),
          //         validator: (person) => person == null ? 'Invalid person.' : null,
          //       ),
          //       SizedBox(height: 16.0),
          //
          //       SimpleAutocompleteFormField<String>(
          //         decoration: InputDecoration(labelText: 'Letter', border: OutlineInputBorder()),
          //         // suggestionsHeight: 200.0,
          //         maxSuggestions: 10,
          //         itemBuilder: (context, item) => Padding(
          //           padding: EdgeInsets.all(8.0),
          //           child: Text(item!),
          //         ),
          //         onSearch: (String search) async => search.isEmpty
          //             ? letters
          //             : letters.where((letter) => search.toLowerCase().contains(letter)).toList(),
          //         itemFromString: (string) =>
          //             letters.singleWhere((letter) => letter == string.toLowerCase(), orElse: () => ''),
          //         onChanged: (value) => setState(() => selectedLetter = value),
          //         onSaved: (value) => setState(() => selectedLetter = value),
          //         validator: (letter) => letter == null ? 'Invalid letter.' : null,
          //       ),
          //       SizedBox(height: 16.0),
          //       ElevatedButton(
          //           child: Text('Submit'),
          //           onPressed: () {
          //             if (formKey.currentState?.validate() ?? false) {
          //               formKey.currentState!.save();
          //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fields valid!')));
          //             } else {
          //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fix errors to continue.')));
          //               setState(() => autovalidate = true);
          //             }
          //           })
          //     ]),
          //   ),
          // ),
        )
    );
  }
}
