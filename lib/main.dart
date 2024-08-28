import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reserva.dart';  // Certifique-se de importar o modelo de usuário

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UsersScreen(),
    );
  }
}

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<Reserva>> _users;

  @override
  void initState() {
    super.initState();
    _users = fetchUsers();
  }

  Future<List<Reserva>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.0.14/reservas-mobile'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reserva.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: FutureBuilder<List<Reserva>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.camArquivo),
                  subtitle: Text(user.camArquivo),
                );
              },
            );
          }
        },
      ),
    );
  }
}
