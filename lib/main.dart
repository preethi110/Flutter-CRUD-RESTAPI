import 'dart:convert';
import 'package:appen/Addnewuser.dart';
import 'package:appen/UpdateExistingUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  int page = 1;
  int perPage = 10;
  List<Map<String, dynamic>> userList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(
          'https://gorest.co.in/public/v2/users?page=$page&per_page=$perPage'),
      headers: {
        'Authorization':
            'Bearer 5ddf131dc3b505fc605be2cda0a55452e0c7c8c83538740fb2cdf1b3bc07a3fc',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        userList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
  onPressed: () async {
    // Navigate to the AddEditUserScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditUserScreen(),
      ),
    );

    // Check if the result is true (indicating a user was added)
    if (result == true) {
      // Refresh the user list
      fetchUsers();
    }
  },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userList[index]['email']),
                      Text(userList[index]['gender']), // Add gender here
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                      onPressed: () async {
                         final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateUserScreen(userDetails: userList[index]),
      ),
    );

    // Check if the result is true (indicating a user was added)
    if (result == true) {
      // Refresh the user list
      fetchUsers();
    }

  },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Text(
                                    'Are you sure you want to remove this user?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {   
                                      // Assuming you have access to the userId
                                      String userId =
                                          userList[index]['id'].toString();
                                      bool deletionStatus =
                                          await deleteUser(userId);

                                      if (deletionStatus) {
                                        // Refresh the user list on Screen 1
                                        fetchUsers();

                                        print("User deleted successfully");
                                      } else {
                                        print("Failed to delete user");
                                        // Handle deletion failure
                                        // Display an error message or retry option
                                      }
                                           Navigator.of(context).pop();
                                    },
                                    child: Text('Remove'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle tap on user item
                  },
                  onLongPress: () {
                    // Show edit and remove options
                  },
                );
              },
            ),
    );
  }
}

Future<bool> deleteUser(String userId) async {
  try {
    final response = await http.delete(
      Uri.parse('https://gorest.co.in/public/v2/users/${userId}'),
      headers: {
        'Authorization':
            'Bearer 5ddf131dc3b505fc605be2cda0a55452e0c7c8c83538740fb2cdf1b3bc07a3fc', // Replace with your access token
      },
    );

    if (response.statusCode == 204) {
      // Deletion successful
      print('User deleted successfully');
      return true; // Return true if deletion was successful
    } else {
      // Deletion failed
      print('Failed to delete user: ${response.statusCode}');
      return false; // Return false if deletion failed
    }
  } catch (e) {
    print('Error deleting user: $e');
    return false; // Return false if an error occurred
  }
}
