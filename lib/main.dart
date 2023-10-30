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
    final response = await http.get(Uri.parse(
        'https://api.sr.se/api/v2/scheduledepisodes?channelid=164&format=json'));

    if (response.statusCode == 200) {
      setState(() {
        scheduleData = json.decode(response.body)['schedule'];
      });
    } else {
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

                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12), // Make corners round
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
                      borderRadius:
                          BorderRadius.circular(12), // Make corners round
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
                );
              },
            ),
    );
  }
}
