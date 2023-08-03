import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen>{

  bool isLoading = false;
  String lat = '', long = '', temperatureC = '', temperatureF = '', feelsC = '', feelsF = '', humidity = '', condition = '';
  String kota = 'Palembang';
  String apiKEY = '7558cd96dec9474d920124328230308';

  @override
  void initState() {
    super.initState();
    getWeather("https://api.weatherapi.com/v1/current.json?key=$apiKEY&q=$kota");
  }

  Future<void> getWeather(String urlNya) async {

    setState(() {
      isLoading = true;
    });
    
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(urlNya));
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        lat = data['location']['lat'].toString();
        long = data['location']['lon'].toString();
        temperatureC = data['current']['temp_c'].toString();
        temperatureF = data['current']['temp_f'].toString();
        feelsC = data['current']['feelslike_c'].toString();
        feelsF = data['current']['feelslike_f'].toString();
        condition = data['current']['condition']['text'];
        humidity = data['current']['humidity'].toString();
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

    Widget containerCuaca(title, icon, subtitle){

      return Container(
        width: MediaQuery.of(context).size.width / 2.3,
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

            Icon(icon),
            Text(title, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
            Text(subtitle, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),

          ],
        )
      );

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        // leading: Padding(
        //   padding: EdgeInsets.only(left: orientasi == 'landscape' ? 20 : 0),
        //   child: InkWell(
        //     onTap: (){
        //       Navigator.pop(context);
        //     },
        //     child: const Icon(Icons.arrow_back, color: Colors.black),
        //   ),
        // ),
        title: const Text("Cuaca", )
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                containerCuaca(condition, Icons.cloud_outlined, '-'),
                // ignore: prefer_interpolation_to_compose_strings
                containerCuaca(temperatureC + "°C", Icons.thermostat, '(' + feelsC + '°C)'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: prefer_interpolation_to_compose_strings
                containerCuaca(temperatureF + "°F", Icons.thermostat, '(' + feelsF + '°F)'),
                // ignore: prefer_interpolation_to_compose_strings
                containerCuaca(humidity, Icons.water_drop_outlined, '-'),
              ],
            ),

          ],
        )
      )
    );

  }
}