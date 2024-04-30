import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Removed extra backslash

class ViewAddressPage extends StatefulWidget {
  @override
  State<ViewAddressPage> createState() => _ViewAddressPageState();
}

class _ViewAddressPageState extends State<ViewAddressPage> {
  late GoogleMapController _mapController;
  late LatLng _userLocation = LatLng(0, 0);
  late CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(27.717245, 85.323959),
    zoom: 14,
  );
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyPoliceStations();
    _getUserLocation(); 
  }

  Future<void> _fetchNearbyPoliceStations() async {
    final url =
        'https://map-places.p.rapidapi.com/nearbysearch/json?location=27.717245%2C85.323959&radius=1500&keyword=hospital&type=hospital';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-RapidAPI-Key': 'f94610bd79msh579b9bfbd97e821p101b85jsnb9a65d4997c6',
        'X-RapidAPI-Host': 'map-places.p.rapidapi.com'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      setState(() {
        _markers.clear();
        for (final result in results) {
          final double lat = result['geometry']['location']['lat'];
          final double lng = result['geometry']['location']['lng'];
          final String name = result['name'];
            final dynamic rating = result['rating'] ?? 0.0; 
        // final String photoUrl = result['photos'][0]['photo_reference']; 
        final String contactNumber = result['formatted_phone_number'] ?? 'N/A'; 

          _markers.add(
            Marker(
              markerId: MarkerId(name),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: name,  snippet: 'Rating: $rating\nContact: $contactNumber', ),
            ),
          );
        }

        _cameraPosition = CameraPosition(
          target: _markers.isNotEmpty ? _markers.first.position : LatLng(27.717245, 85.323959),
          zoom: 14,
        );
      });
    } else {
      print('Failed to fetch nearby police stations: ${response.reasonPhrase}');
    }
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _navigateToNearestPlace() async {
    final nearestPlace = _markers.isNotEmpty ? _markers.first : null;
    if (nearestPlace != null && _userLocation != null) {
      final url = 'https://www.google.com/maps/dir/?api=1&destination=${nearestPlace.position.latitude},${nearestPlace.position.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else { 
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Could not launch navigation.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Police Stations'),
        actions: [
          IconButton(
            icon: Icon(Icons.navigation),
            onPressed: _navigateToNearestPlace,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        mapType: MapType.normal,
        markers: Set.from(_markers),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}


  // Expanded(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 20.0),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 40),
  //                   child: Container(
  //                     height: 600,
  //                     width: double.infinity,
  //                     child: GestureDetector(
  //                       behavior: HitTestBehavior.translucent,
  //                       onTap: () {
  //                          clearMarkers();
  //                         getNearbyHospitals(
  //                             myLatLong.latitude, myLatLong.longitude);
  //                       },
  //                       onVerticalDragUpdate: (_) {},
  //                       child: Map(mapController: mapController,markers: markers,),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),