// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';

// class Map extends StatefulWidget {
//   const Map({Key? key}) : super(key: key);

//   @override
//   State<Map> createState() => _MapState();
// }

// class _MapState extends State<Map> {
//   late GoogleMapController mapController;
//   LatLng myLatLong = LatLng(27.7121, 85.3308);
//   String address = 'Kathmandu';
//   bool zoomedIn = false;
//   Set<Marker> hospitalMarkers = {}; // Set to hold hospital markers

//   void setMarker(LatLng value) async {
//     myLatLong = value;
//     List<Placemark> result =
//         await placemarkFromCoordinates(value.latitude, value.longitude);
//     if (result.isNotEmpty) {
//       address =
//           '${result[0].name}, ${result[0].locality},${result[0].street}, ${result[0].subLocality}, ${result[0].administrativeArea},${result[0].country}';
//     }
//     setState(() {
//       Fluttertoast.showToast(msg: '' + address);
//     });
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void _goToCurrentLocation() async {
//     // Get current location
//     var location = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     if (zoomedIn) {
//       mapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(location.latitude, location.longitude),
//             zoom: 20,
//           ),
//         ),
//       );
//     } else {
//       mapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(location.latitude, location.longitude),
//             zoom: 12,
//           ),
//         ),
//       );
//     }
//     // Update the zoomedIn flag
//     zoomedIn = !zoomedIn;

//     // Fetch nearby hospitals and add markers
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         location.latitude, location.longitude);
//     if (placemarks.isNotEmpty) {
//       Placemark placemark = placemarks.first;
//       // Assuming hospitals are within a certain radius, you can modify the radius as per your requirement
//       List<Placemark> hospitals = await placemarkFromCoordinates(
//           placemark.position.latitude, placemark.position.longitude,
//           name: 'hospital', radius: 5000);
//       hospitalMarkers.clear(); // Clear existing markers
//       for (Placemark hospital in hospitals) {
//         hospitalMarkers.add(
//           Marker(
//             markerId: MarkerId(hospital.name ?? ''),
//             position: hospital.position,
//             infoWindow: InfoWindow(title: hospital.name),
//           ),
//         );
//       }
//       setState(() {});
//     }
//   }

//   void _zoomIn() {
//     mapController.animateCamera(CameraUpdate.zoomIn());
//   }

//   void _zoomOut() {
//     mapController.animateCamera(CameraUpdate.zoomOut());
//   }


// var MapApiApplication = {
//   myCurrentPosition: "",
//   mapOptions: "",
//   marker: "",
//   initialize: function(){
//     MapApiApplication.myCurrentPosition = new google.maps.LatLng(27.7121, 85.3308);
//     MapApiApplication.mapOptions = {
//       zoom: 13,
//       center: MapApiApplication.myCurrentPosition,
//       mapTypeId: google.maps.mapTypeId.ROADMAP
//     };
//     MapApiApplication.map = new google.maps.Map(document.getElementById('map-canvas'),
//     MapApiApplication.mapOptions);
//     MapApiApplication.marker = new google.maps.Marker({
//       position: MapApiApplication.myCurrentPosition,
//       map: MapApiApplication.map,
//       title: 'Here you are'
//     });
//   },
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 200.0),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.blue, width: 1.0),
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20.0),
//             child: Stack(
//               children: [
//                 GoogleMap(
//                   onMapCreated: _onMapCreated,
//                   initialCameraPosition: CameraPosition(
//                     target: myLatLong,
//                     zoom: 12,
//                   ),
//                   markers: {
//                     ...hospitalMarkers,
//                     Marker(
//                       infoWindow: InfoWindow(title: address),
//                       position: myLatLong,
//                       draggable: true,
//                       markerId: MarkerId('1'),
//                       onDragEnd: (value) {
//                         setMarker(value);
//                       },
//                     ),
//                   },
//                   onTap: (value) {
//                     setMarker(value);
//                   },
//                   zoomControlsEnabled: false,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: false,
//                   compassEnabled: true,
//                   padding: EdgeInsets.zero,
//                 ),
//                 Positioned(
//                   top: MediaQuery.of(context).size.height * 0.01,
//                   right: MediaQuery.of(context).size.width * 0.01,
//                   child: Column(
//                     children: [
//                       // SizedBox(height: 295.0),
//                       FloatingActionButton(
//                         onPressed: _zoomIn,
//                         backgroundColor: Colors.white,
//                         mini: true,
//                         child: const Icon(
//                           Icons.add,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       // SizedBox(height: 10.0),
//                       FloatingActionButton(
//                         onPressed: _zoomOut,
//                         backgroundColor: Colors.white,
//                         mini: true,
//                         child: const Icon(
//                           Icons.remove,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       // SizedBox(height: 10.0),
//                       FloatingActionButton(
//                         onPressed: _goToCurrentLocation,
//                         backgroundColor: Colors.white,
//                         mini: true,
//                         child: const Icon(
//                           Icons.my_location,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
