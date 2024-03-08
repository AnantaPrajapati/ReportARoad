import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class Userlocationpage extends StatefulWidget {
  const Userlocationpage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserlocationpageState createState() => _UserlocationpageState();
}

class _UserlocationpageState extends State<Userlocationpage> {
  String locationMessage = 'Current location of user';
  late String lat;
  late String long;
  late String address = 'Searching...';


  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('location is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location permission is denied');
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently denied, we cannot request');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
    .listen((Position position) { 
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'latitude: $lat, Longitude: $long';
      });
    });
  }

Future<void> _openMap(String lat, String long) async {
  String googleURL = 
  'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  await canLaunchUrlString(googleURL)
  ? await launchUrlString(googleURL)
  : throw 'could not launch $googleURL';
}


 Future<void> getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
        });
      } else {
        setState(() {
          address = 'Address not found';
        });
      }
    } catch (e) {
      setState(() {
        address = 'Error: $e';
      });
    }
  }
 @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
            child: Column(
              children: [
                ElevatedButton(
                  child: const Text(
                    "Get Location",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF2C75FF),
                    onPrimary: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _getCurrentLocation().then((value) {
                      lat = '${value.latitude}';
                      long = '${value.longitude}';

                      getAddressFromLatLong(value);

                      setState(() {
                        locationMessage = 'Latitude: $lat, Longitude: $long';
                      });
                      _liveLocation();
                    });
                  },
                ),
                const SizedBox(height: 20),
                 ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    "Open Google Map ",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: const Color(0xFF2C75FF), // BUTTON COLOR
                    // ignore: deprecated_member_use
                    onPrimary: Colors.white, // text color
                    minimumSize: const Size(double.infinity, 50), // button size
                  ),
                  onPressed: () {
                    if (lat != null && long != null) {
                      _openMap(lat!, long!);
                    } else {
                      print('Latitude or Longitude is null.');
                    }
                  },
                ),
                const SizedBox(height: 20),
                Text(locationMessage),
                const SizedBox(height: 20),
                Text('Address: $address'),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
 
}
