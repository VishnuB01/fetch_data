import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'KindaCode.com',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const KindaCodeDemo(),
    );
  }
}

class KindaCodeDemo extends StatefulWidget {
  const KindaCodeDemo({super.key});

  @override
  State<KindaCodeDemo> createState() => _KindaCodeDemoState();
}

class _KindaCodeDemoState extends State<KindaCodeDemo> {
  // Create a new instance of Dio with some options
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.slingacademy.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  // Fetch users from the API
  Future<void> fetchUsers(int offset, int limit) async {
    try {
      final response = await dio.get(
        '/v1/sample-data/users',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          users = response.data["users"];
        });
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  // Create an empty list of users
  List<dynamic> users = [];

  // Create a variable to store the current page
  // This will be used for pagination
  int currentPage = 0;

  // fetch previous page
  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      fetchUsers(currentPage * 10, 10);
    }
  }

  // fetch next page
  void nextPage() {
    currentPage++;
    fetchUsers(currentPage * 10, 10);
  }

  @override
  void initState() {
    super.initState();

    // Fetch the first 10 users when the app starts
    fetchUsers(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KindaCode.com'),
        actions: [
          // This button is used to fetch the previous page
          IconButton(
            onPressed: previousPage,
            icon: const Icon(Icons.chevron_left),
          ),
          // Display the current page
          Text(currentPage.toString()),
          // This button is used to fetch the next page
          IconButton(
            onPressed: nextPage,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      // Display the list of users in a ListView
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[0];
          // Display the user's profile picture, first name, last name and email
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['profile_picture']),
              ),
              title: Text(
                user['first_name'] + " " + user["last_name"],
                style: const TextStyle(fontSize: 24),
              ),
              subtitle: Text(user['email']),
            ),
          );
        },
      ),

//       body:Card(

// child: Container(
//   final user = users[1];
//   child: CircleAvatar(backgroundImage: NetworkImage(user['profile_picture']),),
// ),
//       ),
    );
  }
}
