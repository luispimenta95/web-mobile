import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessageScreen(),
    );
  }
}

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String message = "Loading...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchMessage();

    // Requisita a cada 2 segundos
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchMessage();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancela o timer quando o widget é destruído
    super.dispose();
  }

  Future<void> fetchMessage() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.14/mobile'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          message = data['data']['nome'] ?? 'No message found';
        });
      } else {
        setState(() {
          message = 'Failed to load message';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Screen'),
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
