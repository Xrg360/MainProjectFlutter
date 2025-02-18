// import 'package:flutter/material.dart';
// import 'package:wifi_strength_test/screens/ResultScreen.dart';
// import '../services/wifi_service.dart';
// import '../models/wifi_model.dart';

// class WifiListScreen extends StatefulWidget {
//   @override
//   _WifiListScreenState createState() => _WifiListScreenState();
// }

// class _WifiListScreenState extends State<WifiListScreen> {
//   List<WifiModel> wifiList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadWifiData();
//   }

//   void loadWifiData() async {
//     try {
//       final data = await WifiService.getNearbyWifi();
//       setState(() {
//         wifiList = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error loading Wi-Fi data: $e');
//     }
//   }

//   void sendWifiData() async {
//     try {
//       await WifiService.sendWifiDataToApi(wifiList);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Wi-Fi data sent to the server!')),
//       );

//       // Fetch the result from the API
//       final result = await WifiService.recieveResultfromApi();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Result received from the server!')),
//       );

//       // Navigate to ResultScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(result: result),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send Wi-Fi data: $e')),
//       );
//       print('Error sending Wi-Fi data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Wi-Fi Networks'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : wifiList.isEmpty
//               ? Center(child: Text('No Wi-Fi networks found.'))
//               : ListView.builder(
//                   itemCount: wifiList.length,
//                   itemBuilder: (context, index) {
//                     final wifi = wifiList[index];
//                     return ListTile(
//                       leading: Icon(Icons.wifi, color: Colors.blue),
//                       title: Text(wifi.name),
//                       subtitle:
//                           Text('Signal Strength: ${wifi.signalStrength} dBm'),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: sendWifiData,
//         child: Icon(Icons.send),
//         tooltip: 'Send Wi-Fi Data',
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:wifi/screens/ResultScreen.dart';
import 'dart:async'; // Add this import
import '../services/WifiService.dart';
import '../models/wifi_model.dart';

class WifiListScreen extends StatefulWidget {
  @override
  _WifiListScreenState createState() => _WifiListScreenState();
}

class _WifiListScreenState extends State<WifiListScreen> {
  List<WifiModel> wifiList = [];
  bool isLoading = true;
  Timer? _timer; // Add this line

  @override
  void initState() {
    super.initState();
    loadWifiData();
    _startTimer(); // Add this line
  }

  @override
  void dispose() {
    _timer?.cancel(); // Add this line
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      sendWifiData();
    });
  }

  void loadWifiData() async {
    try {
      final data = await WifiService.getNearbyWifi();
      setState(() {
        wifiList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading Wi-Fi data: $e');
    }
  }

  void sendWifiData() async {
    try {
      await WifiService.sendWifiDataToApi(wifiList);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wi-Fi data sent to the server!')),
      );

      // Fetch the result from the API
      final result = await WifiService.recieveResultfromApi();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Result received from the server!')),
      );

      // Navigate to ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: result),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send Wi-Fi data: $e')),
      );
      print('Error sending Wi-Fi data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Wi-Fi Networks'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : wifiList.isEmpty
              ? Center(child: Text('No Wi-Fi networks found.'))
              : ListView.builder(
                  itemCount: wifiList.length,
                  itemBuilder: (context, index) {
                    final wifi = wifiList[index];
                    return ListTile(
                      leading: Icon(Icons.wifi, color: Colors.blue),
                      title: Text(wifi.name),
                      subtitle:
                          Text('Signal Strength: ${wifi.signalStrength} dBm'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendWifiData,
        child: Icon(Icons.send),
        tooltip: 'Send Wi-Fi Data',
      ),
    );
  }
}
