import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShalatScreen extends StatefulWidget {
  const ShalatScreen({Key? key}) : super(key: key);

  @override
  ShalatScreenState createState() => ShalatScreenState();
}

class ShalatScreenState extends State<ShalatScreen>{

  bool isLoading = false;
  String kota = 'Palembang';
  int kotaID = 12750;
  DateTime tanggal = DateTime.now();
  String shubuh = '', dzuhur = '', ashar = '', maghrib = '', isya = '';

  @override
  void initState() {
    super.initState();
    getJadwalShalat("https://prayertimes.api.abdus.dev/api/diyanet/prayertimes?location_id=$kotaID");
  }

  Future<void> getJadwalShalat(String urlNya) async {

    setState(() {
      isLoading = true;
    });
    
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(urlNya));
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        shubuh = data[0]['fajr'] ?? '-';
        dzuhur = data[0]['dhuhr'] ?? '-';
        ashar = data[0]['asr'] ?? '-';
        maghrib = data[0]['maghrib'] ?? '-';
        isya = data[0]['isha'] ?? '-';
      });
    } finally {
      client.close();
    }

    setState(() {
      isLoading = false;
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget cardShalat(title, sub){

      return Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10)
          ),
          border: Border.all(color: Colors.green)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
            Text(sub)

          ],
        )
      );

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("Jadwal Shalat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: isLoading ? const Center(child: Text("Memuat.."),) : Column(
          children: [

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.map, color: Colors.green),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                    const Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(kota)

                  ],)
                ],
              ),
            ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  cardShalat("Shubuh", shubuh),
                  const SizedBox(width: 10),
                  cardShalat("Dzuhur", dzuhur),
                  const SizedBox(width: 10),
                  cardShalat("Ashar", ashar),
                  const SizedBox(width: 10),
                  cardShalat("Maghrib", maghrib),
                  const SizedBox(width: 10),
                  cardShalat("Isya", isya),
                ],
              ),
            ),

            const SizedBox(height: 10,),

            const Text("Swipe ke kiri atau ke kanan untuk melihat jadwal shalat.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13),)


          ],
        )
      )
    );

  }
}