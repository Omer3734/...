import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:not_al_app_5/NotDetaySayfa.dart';
import 'package:not_al_app_5/NotKayitSayfa.dart';
import 'package:not_al_app_5/controller/geolocator_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Notlar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {


  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  final geoLocatorController = Get.put(GeolocatorController());

  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  var notlarListesi = <Notlar>[];


  Future<bool> cikisYap() async {
    await exit(0);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: (){
            cikisYap();
          },
          ),
          title: Text("Notlar Uygulaması")
      ),
      body: WillPopScope(
        onWillPop: cikisYap,
        child: StreamBuilder<DatabaseEvent>(
          stream: refNotlar.onValue,
          builder: (context, event){
            if(event.hasData){

              var notlarListesi = <Notlar>[];

              var gelenDegerler = event.data!.snapshot.value as dynamic;

              if(gelenDegerler != null){
                gelenDegerler.forEach((key, nesne){
                  var gelenNot = Notlar.fromJson(key, nesne);
                  notlarListesi.add(gelenNot);
                });
              }
              return ListView.builder(
                itemCount: notlarListesi.length,
                itemBuilder: (context,indeks){
                  var not = notlarListesi[indeks];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not)));
                    },
                    child: Card(
                      child: SizedBox(height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(not.baslik, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(not.icerik),
                            Text("X : ${not.konumX}"),
                            Text("Y : ${not.konumY}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getLocation();
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
        },
        tooltip: 'Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
  getLocation(){
    Geolocator.requestPermission().then((request){
      //IOS'a bağlamak istediğinde projeyi bağladıktan sonra burada if(Platform.isIOS) sorgusu yapmalısın.
      if(request != LocationPermission.always){
        return;
      }else{
        geoLocatorController.permissionOK();
      }
    });
  }


}
