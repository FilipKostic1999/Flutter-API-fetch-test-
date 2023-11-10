import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<dynamic> scheduleData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch data from the API
    final response = await http.get(Uri.parse(
        'https://api.sr.se/api/v2/scheduledepisodes?channelid=164&format=json'));

    if (response.statusCode == 200) {
      // Update the state with the fetched schedule data
      setState(() {
        scheduleData = json.decode(response.body)['schedule'];
      });
    } else {
      // Handle the case when data fetching fails
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API fetch test'),
      ),
      backgroundColor: Colors.blue,
      body: scheduleData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: scheduleData.length,
              itemBuilder: (context, index) {
                final item = scheduleData[index];
                final imageUrl = item['imageurl'];

                return GestureDetector(
                  onTap: () {
                    // Navigate to the detail screen when an item is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(item: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(item['title']),
                        subtitle: Text(item['description']),
                        leading: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 60,
                              )
                            : SizedBox(width: 60),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageurl'];

    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image if available
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            // Display the description
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              item['description'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
