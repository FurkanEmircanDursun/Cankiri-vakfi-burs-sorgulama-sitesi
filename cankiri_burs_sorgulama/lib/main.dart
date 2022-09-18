import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

final Future<FirebaseApp> initialization = Firebase.initializeApp();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  TextEditingController tcText = TextEditingController();

  String sonuc = "";

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "burs sonucu",
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 300,
                ),
                Center(
                    child: Text(
                  "Burs Sorgulama Sistemi",
                  style: TextStyle(fontSize: 25, color: Colors.pink),
                )),
                Container(
                  width: 400,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: tcText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'TC Kimlik Numaranız',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    width: 350,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      child: const Text('Sonucu görüntüle'),
                      onPressed: () async {
                        var myQuery = await FirebaseFirestore.instance
                            .collection('wins')
                            .where('tc', isEqualTo: int.parse(tcText.text))
                            .get();

                        setState(() {
                          if (myQuery.size > 0) {
                            sonuc = "Tebrikler " +
                                myQuery.docs.first.data()['name'] +
                                " " +
                                myQuery.docs.first.data()['surname'];
                          } else {
                            sonuc = "Üzgünüz";
                          }
                        });
                      },
                    )),
                SizedBox(
                  height: 30,
                ),
                Text(sonuc.toUpperCase(),
                    style: TextStyle(fontSize: 30, color: Colors.green)),
              ],
            ),
          ),
        ));
  }
}
