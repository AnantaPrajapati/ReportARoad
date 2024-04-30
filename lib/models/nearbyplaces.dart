import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:reportaroad/models/nearbyplacesresponse.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportaroad/utils/userlocation.dart';
import '../utils/map.dart';

class NearByPlaces extends StatefulWidget {
  NearByPlaces({Key? key}) : super(key: key);

  @override
  State<NearByPlaces> createState() => _NearByPlacesState();
}

class _NearByPlacesState extends State<NearByPlaces> {
  // String rapidApiKey = "0a89a955c3msh04b5630c2d3ea4fp152bb2jsnc4f1925740e7";
  String radius = "1500";
  double latitude = 27.7121;
  double longitude = 85.3308;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  GoogleMapController? mapController;
  LatLng myLatLong = LatLng(27.7121, 85.3308);
  String address = 'Kathmandu';
  bool zoomedIn = false;
   List<Marker> markers = [];

  // void _onMapCreated(GoogleMapController controller) {
  //   setState(() {
  //     mapController = controller;
  //   });
  // }
   void clearMarkers() {
    setState(() {
      markers.clear();
    });
  }

  void setLocation(String address, String latitude, String longitude) {
    setState(() {
      '$address($latitude, $longitude)';
    });
  }
  //   void _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       latitude = position.latitude;
  //       longitude = position.longitude;
  //     });
  //   } catch (e) {
  //     print("Error getting current location: $e");
  //   }
  // }

 void setMarker(LatLng value) async {
  myLatLong = value;
  latitude = value.latitude;
  longitude = value.longitude;
  List<Placemark> result = await placemarkFromCoordinates(value.latitude, value.longitude);
  if (result.isNotEmpty) {
    address =
        '${result[0].name}, ${result[0].locality},${result[0].street}, ${result[0].subLocality}, ${result[0].administrativeArea},${result[0].country}';
  }
  setState(() {
    Fluttertoast.showToast(msg: '' + address);
  });
}
void addMarkerForHospital(String name, dynamic lat, dynamic lng) {
  double latitude = lat.toDouble();
  double longitude = lng.toDouble();
    final MarkerId markerId = MarkerId(name);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: name),
    );
    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: getNearbyHospitals(double lat, double long);
          //   child: const Text("Get Nearby Hospitals"),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          if (nearbyPlacesResponse.results != null)
            for (int i = 0; i < nearbyPlacesResponse.results!.length; i++)
              nearbyPlacesWidget(nearbyPlacesResponse.results![i]),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 600,
                      width: double.infinity,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                           clearMarkers();
                          getNearbyHospitals(
                              myLatLong.latitude, myLatLong.longitude);
                        },
                        onVerticalDragUpdate: (_) {},
                        child: Map(mapController: mapController,markers: markers,),
                      ),
                    ),
                  ),
                  Userlocationpage(
                    onLocationSelected: (address, latitude, longitude) {
                      dynamic lat = double.parse(latitude);
                      dynamic long = double.parse(longitude);
                      setLocation(address, lat.toString(), long.toString());
                      getNearbyHospitals(lat, long);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
void getNearbyHospitals(double lat, double long) async {
  var uri = Uri.https('map-places.p.rapidapi.com', '/nearbysearch/json', {
    'location': '$lat,$long',
    'radius': radius,
    'keyword': 'hospital',
    'type': 'hospital',
  });

  var headers = {
    'X-RapidAPI-Key': 'f94610bd79msh579b9bfbd97e821p101b85jsnb9a65d4997c6',
    'X-RapidAPI-Host': 'map-places.p.rapidapi.com',
  };

  try {
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(uri);
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

   var response = await request.close();
    if (response.statusCode == 200) {
      var responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody);
      final results = data['results'];
      clearMarkers(); // Clear existing markers
      for (var result in results) {
        final name = result['name'];
        final geometry = result['geometry'];
        final location = geometry['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        addMarkerForHospital(name, lat, lng);
      }
      setState(() {
        nearbyPlacesResponse =
            NearbyPlacesResponse.fromJson(jsonDecode(responseBody));
      });
    } else {
      print('Failed to load nearby hospitals. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: " + results.name!),
          Text("Location: " +
              results.geometry!.location!.lat.toString() +
              " , " +
              results.geometry!.location!.lng.toString()),
          Text(results.openingHours != null ? "Open" : "Closed"),
        ],
      ),
    );
  }
}
