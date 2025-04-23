import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:logistika/api_connection/api_connection.dart'; // Tu endpoint all.php



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  LatLng _initialPosition = const LatLng(-17.7833, -63.1833); // Ej: Santa Cruz
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchClientesMarkers();
  }

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  _fetchClientesMarkers() async {
    var res = await http.post(Uri.parse(API.getAllClient));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      if (data["success"] == true) {
        List clientes = data["clientesData"];

        for (var cliente in clientes) {
          double? lat = double.tryParse(cliente["latitude"] ?? "");
          double? lng = double.tryParse(cliente["longitude"] ?? "");
          if (lat != null && lng != null) {
            _markers.add(
              Marker(
                markerId: MarkerId(cliente["codigo"]),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: cliente["negocio"],
                  snippet: cliente["contacto"],
                ),
              ),
            );
          }
        }
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes en el Mapa"),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }
}