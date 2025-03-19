import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
// import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;

  ResultScreen({required this.result});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final userLocation = widget.result['user_location'] ?? 'Unknown';
    final List<String> shortestPath =
        (widget.result['shortest_path'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
    final totalDistance =
        widget.result['total_distance']?.toString() ?? '0.0 meters';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildGradientBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: EdgeInsets.all(20),
                      decoration: _buildGlassContainerDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildTitle(),
                          SizedBox(height: 20),
                          _buildResultCard(
                              '📍 User Location', userLocation, Colors.blue),
                          SizedBox(height: 18),
                          _buildStepByStepRoute(shortestPath),
                          SizedBox(height: 18),
                          _buildResultCard('📏 Total Distance',
                              "$totalDistance meters", Colors.red),
                          SizedBox(height: 30),
                          _buildSOSButtons(),
                          SizedBox(height: 20),
                          _buildExitButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.red.shade900, Colors.black],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
    );
  }

  BoxDecoration _buildGlassContainerDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      "EVACUATION PLAN",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.2,
        shadows: [
          Shadow(blurRadius: 20, color: Colors.redAccent, offset: Offset(0, 0))
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, String value, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepByStepRoute(List<String> shortestPath) {
    return Column(
      children: shortestPath.map((step) {
        return ListTile(
          leading: Icon(Icons.location_on, color: Colors.greenAccent),
          title: Text(
            step,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        );
      }).toList(),
    );
  }

  Widget _buildSOSButtons() {
    return Column(
      children: [
        // ElevatedButton.icon(
        //   onPressed: () => launch("tel://112"),
        //   icon: Icon(Icons.call, color: Colors.white),
        //   label: Text("SOS Call",
        //       style: TextStyle(fontSize: 18, color: Colors.white)),
        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        // ),
        // SizedBox(height: 10),
        // ElevatedButton.icon(
        //   onPressed: () => launch("sms:?body=Emergency! Need Help."),
        //   icon: Icon(Icons.message, color: Colors.white),
        //   label: Text("SOS Message",
        //       style: TextStyle(fontSize: 18, color: Colors.white)),
        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        // ),
        // SizedBox(height: 10),
        // ElevatedButton.icon(
        //   onPressed: () =>
        //       launch("https://www.google.com/search?q=first+aid+instructions"),
        //   icon: Icon(Icons.health_and_safety, color: Colors.white),
        //   label: Text("First Aid Help",
        //       style: TextStyle(fontSize: 18, color: Colors.white)),
        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        // ),
        Placeholder()
      ],
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('EXIT SAFELY',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
