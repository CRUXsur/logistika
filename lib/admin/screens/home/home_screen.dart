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
  // LatLng _initialPosition = const LatLng(-17.7833, -63.1833); // Ej: Santa Cruz
  Position? _currentPosition; // <- ahora usamos esto en vez de _initialPosition
  // final Set<Marker> _markers = {};
  Set<Marker> _markers = {};
  bool _isLoading = true;
  var _selectedCliente = null; //para la tarjeta flotante personalizada

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchClientesMarkers();
  }

  _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      // _initialPosition = LatLng(position.latitude, position.longitude);
      _currentPosition = position;
      _isLoading = false;
      Map<String, dynamic>? _selectedCliente;   //para la tarjeta flotante personalizada
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
                markerId: MarkerId(cliente["cliente_id"]),
                position: LatLng(lat, lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                onTap: () {
                  setState(() {
                    _selectedCliente = cliente;
                  });

                  _showClienteInfoBottomSheet();
                },
              ),
            );
            // _markers.add(
            //   Marker(
            //     markerId: MarkerId(cliente["cliente_id"]),
            //     position: LatLng(lat, lng),
            //     infoWindow: InfoWindow(
            //       title: cliente["negocio"],
            //       // snippet: "Contacto: ${cliente["contacto"]}\nCel: ${cliente["movil"]}",
            //       snippet: "cel:${cliente["movil"]}",
            //       onTap: () {
            //         // Opcional: abrir una pantalla de detalle
            //       },
            //     ),
            //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            //   ),
            // );
          }
        }

        setState(() {});
      }
    }
  }

  void _showClienteInfoBottomSheet() {
    if (_selectedCliente == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedCliente!["negocio"] ?? "Sin nombre",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Contacto: ${_selectedCliente!["contacto"] ?? "-"}"),
              Text("Celular: ${_selectedCliente!["movil"] ?? "-"}"),
              Text("Categoría: ${_selectedCliente!["categoria"] ?? "-"}"),
              Text("Tipo: ${_selectedCliente!["tipo"] ?? "-"}"),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_pin, color: Colors.red),
                  Text("Lat: ${_selectedCliente!["latitude"]}, Lng: ${_selectedCliente!["longitude"]}")
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading || _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }

}