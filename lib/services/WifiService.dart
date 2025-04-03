import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/wifi_model.dart';

class WifiService {
  static final String apiUrl =
      'https://mainproject-qc8w.onrender.com'; // Update Flask Server IP
  // 'http://192.168.245.72:5000/'; // Update Flask Server IP
  static IO.Socket? socket;

  /// **Fetch nearby Wi-Fi networks**
  static Future<List<WifiModel>> getNearbyWifi() async {
    List<WifiModel> wifiList = [];

    try {
      bool isEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!isEnabled) {
        await WiFiForIoTPlugin.setEnabled(true);
      }

      List<WifiNetwork>? networks = await WiFiForIoTPlugin.loadWifiList();

      if (networks != null) {
        wifiList = networks.map((network) {
          return WifiModel(
            name: network.ssid ?? 'Unknown',
            signalStrength: network.level ?? 0,
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching Wi-Fi networks: $e');
    }

    return wifiList;
  }

  /// **Send Wi-Fi data to Flask API**
  static Future<Map<String, dynamic>?> sendWifiDataToApi(
      List<WifiModel> wifiList, String deviceTag) async {
    try {
      List<Map<String, dynamic>> jsonData =
          wifiList.map((wifi) => wifi.toJson()).toList();
      final jsonBody =
          jsonEncode({'wifi_devices': jsonData, 'device_tag': deviceTag});

      print('Sending JSON payload: $jsonBody'); // Add this line

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'wifi_devices': jsonData, 'device_tag': deviceTag}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Wi-Fi data sent successfully! Response: $data');
        return data['data'];
      } else {
        print('Failed to send Wi-Fi data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending Wi-Fi data to API: $e');
      return null;
    }
  }

  /// **Retrieve the shortest path from Flask API**
  static Future<Map<String, dynamic>?> receiveResultFromApi(
      String deviceTag) async {
    final api = '${apiUrl}result/$deviceTag';

    try {
      final response = await http.get(Uri.parse(api));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Path retrieved successfully! Response: $data');
        return data['data'];
      } else {
        print('Failed to retrieve path. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error retrieving path from API: $e');
      return null;
    }
  }

  /// **Connect to WebSocket for real-time updates**
  static void connectToSocket(
      String deviceTag, Function(Map<String, dynamic>) onUpdate) {
    socket = IO.io(apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      print('Connected to WebSocket server');
    });

    // Listen for real-time updates for this specific user
    socket!.on('update_$deviceTag', (data) {
      print('Real-time update received for $deviceTag: $data');
      onUpdate(data); // Update UI
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from WebSocket server');
    });
  }

  /// **Disconnect WebSocket when not needed**
  static void disconnectSocket() {
    socket?.disconnect();
  }
}
