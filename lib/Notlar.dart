class Notlar{
  String not_id;
  String baslik;
  String icerik;
  String konumX;
  String konumY;

  Notlar(this.not_id, this.baslik, this.icerik, this.konumX, this.konumY);

  factory Notlar.fromJson(String key, Map<dynamic,dynamic> json){
    return Notlar(key, json["baslik"] as String, json["icerik"] as String, json["konumX"] as String, json["konumY"] as String);
  }
}