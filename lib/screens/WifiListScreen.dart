import 'package:flutter/material.dart';
import 'package:wifi/screens/ResultScreen.dart';
import 'dart:async';
import 'dart:ui'; // For blur effect
import '../services/WifiService.dart';
import '../models/wifi_model.dart';

class WifiListScreen extends StatefulWidget {
  @override
  _WifiListScreenState createState() => _WifiListScreenState();
}

class _WifiListScreenState extends State<WifiListScreen> {
  List<WifiModel> wifiList = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadWifiData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void _showCustomSnackbar(
      {required String message,
      required Color backgroundColor,
      required IconData icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
                child: Text(message, style: TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void sendWifiData() async {
    try {
      String device_tag = "device_1";

      final result = await WifiService.sendWifiDataToApi(wifiList, device_tag);
      print('Sending Wi-Fi data with device_tag: $device_tag');
      print(
          'Wi-Fi devices being sent: ${wifiList.map((wifi) => wifi.name).toList()}');

      if (result != null) {
        _showCustomSnackbar(
          message: "Result received from server!",
          backgroundColor: Colors.blueAccent.shade700,
          icon: Icons.wifi,
        );

        // Navigate to ResultScreen with the result from POST response
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      } else {
        print('Server returned null result');

        _showCustomSnackbar(
          message: "Failed to get results. Please try again.",
          backgroundColor: Colors.redAccent.shade700,
          icon: Icons.error,
        );
      }
    } catch (e) {
      print('Error details: $e');

      _showCustomSnackbar(
        message: "Failed to send Wi-Fi data.",
        backgroundColor: Colors.redAccent.shade700,
        icon: Icons.error,
      );
      print('Error sending Wi-Fi data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.red.shade900, Colors.black],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Nearby Wi-Fi Networks",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.redAccent),
                                ),
                              )
                            : wifiList.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Wi-Fi networks found.',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 18),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: wifiList.length,
                                    itemBuilder: (context, index) {
                                      final wifi = wifiList[index];
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          leading: Icon(Icons.wifi,
                                              color: Colors.blueAccent),
                                          title: Text(
                                            wifi.name,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            'Signal Strength: ${wifi.signalStrength} dBm',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: sendWifiData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'SEND DATA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
