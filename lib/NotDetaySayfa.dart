import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Notlar.dart';
import 'main.dart';

class NotDetaySayfa extends StatefulWidget {

  Notlar not;


  NotDetaySayfa({required this.not});

  @override
  State<NotDetaySayfa> createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {

  var tfNotBaslik = TextEditingController();
  var tfNotIcerik = TextEditingController();

  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  Future<void> sil(String not_id) async {
    refNotlar.child(not_id).remove();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }
  Future<void> guncelle(String not_id, String baslik, String icerik, String konumX, String konumY) async {
    var info = HashMap<String, dynamic>();
    info["baslik"] = baslik;
    info["icerik"] = icerik;
    info["konumX"] = konumX;
    info["konumY"] = konumY;
    refNotlar.child(not_id).update(info);
    print("$baslik");
  }

  @override
  void initState() {
    super.initState();
    var not = widget.not;
    tfNotBaslik.text = not.baslik;
    tfNotIcerik.text = not.icerik;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Not Detay"),
          actions: [
            Container(
              child: TextButton(onPressed: (){
                sil(widget.not.not_id);
              },
                  child: Icon(Icons.delete, color: Colors.white.withOpacity(0.7) ) ),
            ),


            TextButton(onPressed: (){
              guncelle(widget.not.not_id, widget.not.baslik, widget.not.icerik, widget.not.konumX, widget.not.konumY);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
            },
                child: Icon(Icons.update, color: Colors.white.withOpacity(0.9)) )
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
                        ))),
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
}
