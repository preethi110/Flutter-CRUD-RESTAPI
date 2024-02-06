import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UpdateUserScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  UpdateUserScreen({required this.userDetails});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late String _selectedGender;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userDetails['name']);
    _emailController = TextEditingController(text: widget.userDetails['email']);
    _genderController =
        TextEditingController(text: widget.userDetails['gender']);
    _selectedGender = widget.userDetails['gender'];
    _selectedStatus = widget.userDetails['status'];
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      final response = await http.patch(
        Uri.parse('https://gorest.co.in/public/v2/users/${userId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 5ddf131dc3b505fc605be2cda0a55452e0c7c8c83538740fb2cdf1b3bc07a3fc',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // User updated successfully
        print('User updated successfully');
        return true;
      } else {
        // User update failed
        print('Failed to update user: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            ListTile(
              title: Text('Gender'),
              subtitle: Row(
                children: [
                  Radio<String>(
                    value: 'male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
            ),
            ListTile(
              title: Text('Status'),
              subtitle: Row(
                children: [
                  Radio<String>(
                    value: 'active',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                  Text('Active'),
                  Radio<String>(
                    value: 'inactive',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                  Text('Inactive'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Prepare updated user data
                Map<String, dynamic> updatedUserData = {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'gender': _selectedGender,
                  'status': _selectedStatus,
                };

                // Call updateUser method
                bool updateSuccess = await updateUser(
                    widget.userDetails['id'].toString(), updatedUserData);

                if (updateSuccess) {
                  // User updated successfully
                  // Return to previous screen
                  Navigator.pop(context, true);
                } else {
                  // User update failed
                  // Handle error or display message to user
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
