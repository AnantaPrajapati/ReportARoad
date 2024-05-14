import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportaroad/utils/CustomAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAddressPage extends StatefulWidget {
  @override
  State<ViewAddressPage> createState() => _ViewAddressPageState();
}

class _ViewAddressPageState extends State<ViewAddressPage> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController _mapController;
  late LatLng _userLocation = LatLng(0, 0);
  late CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(27.717245, 85.323959),
    zoom: 14,
  );
  List<Marker> _markers = [];
    late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  late Map<PolylineId, Polyline> polylines;

  @override
  void initState() {
    super.initState();
    _fetchNearbyPoliceStations();
    _getUserLocation(); 
       polylinePoints = PolylinePoints();
    polylines = {};
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchNearbyPoliceStations() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final url =
        'https://map-places.p.rapidapi.com/nearbysearch/json?location=${position.latitude}%2C${position.longitude}&radius=1500&keyword=hospital&type=hospital';

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
          final String contactNumber = result['formatted_phone_number'] ?? 'N/A';

          _markers.add(
            Marker(
              markerId: MarkerId(name),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: name, snippet: 'Rating: $rating\nContact: $contactNumber'),
            ),
          );
        }

        _cameraPosition = CameraPosition(
          target: _markers.isNotEmpty ? _markers.first.position : LatLng(position.latitude, position.longitude),
          zoom: 14,
        );
      });
    } else {
      print('Failed to fetch nearby police stations: ${response.reasonPhrase}');
    }
  }
 Future<void> _getRouteToNearestPlace() async {
    LatLng nearestPlace = _markers.isNotEmpty ? _markers.first.position : _userLocation;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "81cafe1dc2msh71a68129873e5c7p13f577jsn5150c49bba61", 
      PointLatLng(_userLocation.latitude, _userLocation.longitude),
      PointLatLng(nearestPlace.latitude, nearestPlace.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      setState(() {
        polylineCoordinates.clear();
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        PolylineId id = PolylineId("route");
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        );
        polylines[id] = polyline;
      });
    }
  }

  void _goToCurrentLocation() async {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _userLocation,
          zoom: 14,
        ),
      ),
    );
  }

  void _zoomIn() {
    _mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: AppBar(
            backgroundColor: Color(0xFF2C75FF),
            elevation: 5,
            title: const Text(
              "Hospital",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
             leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            mapType: MapType.normal,
            markers: Set.from(_markers),
            polylines: Set<Polyline>.of(polylines.values),
              myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
               zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: true,
          ),
          // Positioned(
          //   bottom: 16,
          //   right: 16,
          //   child: Column(
          //     children: [
          //       FloatingActionButton(
          //         onPressed: _getRouteToNearestPlace,
          //         child: Icon(Icons.directions),
          //       ),
          //     ],
          //   ),
          // ),
          Positioned(
            bottom: 85,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                   backgroundColor: Colors.white,
                    mini: true,
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  backgroundColor: Colors.white,
                    mini: true,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.blue,
                    ),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _goToCurrentLocation,
                  backgroundColor: Colors.white,
                    mini: true,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
