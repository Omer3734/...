import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:not_al_app_5/controller/geolocator_controller.dart';
import 'package:not_al_app_5/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NotKayitSayfa extends StatefulWidget {
  const NotKayitSayfa({Key? key}) : super(key: key);

  @override
  State<NotKayitSayfa> createState() => _NotKayitSayfaState();
}

class _NotKayitSayfaState extends State<NotKayitSayfa> {

  final geoLocatorController = Get.put(GeolocatorController());


  var tfNotBaslik = TextEditingController();
  var tfNotIcerik = TextEditingController();

  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  Future<void> kayit(String baslik, String icerik, String konumX, String konumY) async {
    print("$baslik\n  -> $icerik");
    print("$konumX\n$konumY");

    var info = HashMap<String, dynamic>();
    info["not_id"];
    info["baslik"] = baslik;
    info["icerik"] = icerik;
    info["konumX"] = konumX;
    info["konumY"] = konumY;
    refNotlar.push().set(info);

    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Not Kayıt"),
          actions: [
            TextButton(
                onPressed: () {
                  getLocation();
                  kayit(tfNotBaslik.text, tfNotIcerik.text, geoLocatorController.currentLocation.latitude.toString(), geoLocatorController.currentLocation.longitude.toString());

                },
                child: Icon(Icons.save, color: Colors.white))
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(color: Colors.white.withOpacity(0.8),
                  child: TextField(
                    controller: tfNotBaslik,
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: "  Başlık . . .", border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(20)
                        )
                    )
                    ),
                  ),
                ),
              ),

              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Container(color: Colors.white.withOpacity(0.7),
                    child: TextField(
                      controller: tfNotIcerik,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(hintText: "  Not . . .",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          )
                      ),
                    ),
                  ),
                ),
                ),
              ))
            ],
          ),
        )
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
