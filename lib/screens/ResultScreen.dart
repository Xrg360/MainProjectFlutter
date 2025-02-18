import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  ResultScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    // Safely extract values from the result map with default fallbacks
    final userLocation = result['user_location'] ?? 'Unknown';
    final shortestPath =
        (result['shortest_path'] as List<dynamic>?)?.join(' -> ') ??
            'No path available';
    final totalDistance = result['total_distance']?.toString() ?? '0.0 meters';

    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultCard('User Location', userLocation),
            SizedBox(height: 16),
            _buildResultCard('Shortest Path', shortestPath),
            SizedBox(height: 16),
            _buildResultCard('Total Distance', totalDistance),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
