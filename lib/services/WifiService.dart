import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import '../models/wifi_model.dart';

class WifiService {
  static final apiUrl = 'http://192.168.2.224:5000/';
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

  static Future<void> sendWifiDataToApi(List<WifiModel> wifiList) async {
    try {
      // Convert the list to JSON
      List<Map<String, dynamic>> jsonData = wifiList.map((wifi) {
        return {
          'name': wifi.name,
          'signalStrength': wifi.signalStrength,
        };
      }).toList();

      // Make the POST request with the correct key
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'wifi_devices': jsonData,
        'device_tag': "123"}), // Fixed key
      );

      if (response.statusCode == 200) {
        print('Wi-Fi data sent successfully!');
      } else {
        print('Failed to send Wi-Fi data. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error sending Wi-Fi data to API: $e');
    }
  }

  static Future<Map<String, dynamic>> recieveResultfromApi() async {
    final api = '${apiUrl}result';

    try {
      final response = await http.get(Uri.parse(api));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to receive result: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
