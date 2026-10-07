import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';

class AdvancedMapScreen extends StatefulWidget {
  @override
  _AdvancedMapScreenState createState() => _AdvancedMapScreenState();
}

class _AdvancedMapScreenState extends State<AdvancedMapScreen> {
  final String apiKey = "YOUR_API_KEY_HERE"; // Thay thế bằng API Key của bạn
  
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  
  String _distance = "";
  String _duration = "";
  String _selectedMode = "driving"; // Mặc định là xe hơi

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 1. Lấy vị trí hiện tại
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
    
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _startLatLng = LatLng(position.latitude, position.longitude);
      _startController.text = "${position.latitude}, ${position.longitude}";
      _addMarker(_startLatLng!, "Xuất phát");
      _moveCamera(_startLatLng!);
    });
  }

  // 2. Chuyển địa chỉ thành tọa độ (Geocoding API)
  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    if (address.contains(',')) {
      // Nếu user nhập trực tiếp tọa độ (vd: 10.77, 106.70)
      try {
        List<String> parts = address.split(',');
        return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
      } catch (e) {}
    }
    
    // Gọi Geocoding API nếu nhập địa chỉ text
    String url = "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        var location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
    return null;
  }

  // 3. Tìm đường đi và hiển thị khoảng cách/thời gian
  Future<void> _findRoute() async {
    if (_startController.text.isEmpty || _endController.text.isEmpty) return;

    _startLatLng = await _getCoordinatesFromAddress(_startController.text);
    _endLatLng = await _getCoordinatesFromAddress(_endController.text);

    if (_startLatLng == null || _endLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể xác định địa chỉ!')));
      return;
    }

    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${_startLatLng!.latitude},${_startLatLng!.longitude}&destination=${_endLatLng!.latitude},${_endLatLng!.longitude}&mode=$_selectedMode&key=$apiKey";
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['routes'].isNotEmpty) {
        var route = data['routes'][0];
        var leg = route['legs'][0];
        
        setState(() {
          _distance = leg['distance']['text']; // Lấy khoảng cách
          _duration = leg['duration']['text']; // Lấy thời gian
          _markers.clear();
          _addMarker(_startLatLng!, "Xuất phát");
          _addMarker(_endLatLng!, "Đích đến");
          
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: _decodePolyline(route['overview_polyline']['points']),
            color: Colors.blue,
            width: 5,
          ));
        });
        _moveCamera(_startLatLng!);
        
        // Lưu vào SQLite
        await DatabaseHelper.instance.insertRoute(_startController.text, _endController.text, _selectedMode);
      }
    }
  }

  void _addMarker(LatLng position, String id) {
    _markers.add(Marker(markerId: MarkerId(id), position: position, infoWindow: InfoWindow(title: id)));
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  // 4. Chọn điểm bằng cách Click trên bản đồ
  void _onMapTapped(LatLng position) {
    setState(() {
      _endLatLng = position;
      _endController.text = "${position.latitude}, ${position.longitude}";
      _addMarker(position, "Đích đến (Click)");
    });
  }

  // Hàm giải mã Polyline chuẩn
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Maps')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: InputDecoration(labelText: 'Xuất phát (Địa chỉ hoặc Tọa độ)'),
                ),
                TextField(
                  controller: _endController,
                  decoration: InputDecoration(labelText: 'Đích đến (Click bản đồ hoặc nhập)'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: _selectedMode,
                      items: [
                        DropdownMenuItem(value: "driving", child: Text("Xe hơi")),
                        DropdownMenuItem(value: "walking", child: Text("Đi bộ")),
                        DropdownMenuItem(value: "bicycling", child: Text("Xe đạp")),
                      ],
                      onChanged: (value) {
                        setState(() { _selectedMode = value!; });
                      },
                    ),
                    ElevatedButton(
                      onPressed: _findRoute,
                      child: Text('Tìm đường'),
                    ),
                  ],
                ),
                if (_distance.isNotEmpty) 
                  Text("Khoảng cách: $_distance | Thời gian: $_duration", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) => _controller.complete(controller),
              myLocationEnabled: true,
              onTap: _onMapTapped, // Bắt sự kiện click chuột trên bản đồ
            ),
          ),
        ],
      ),
    );
  }
}