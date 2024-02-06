import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class AddEditUserScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  

  AddEditUserScreen({this.userData});

  @override
  _AddEditUserScreenState createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late String _gender;
  late String _status;
  late double _latitude;
  late double _longitude;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _gender = '';
     _status = 'active'; 
    _latitude = 0.0;
    _longitude = 0.0;
    _formKey = GlobalKey<FormState>();

    if (widget.userData != null) {
      _nameController.text = widget.userData!['name'] ?? '';
      _emailController.text = widget.userData!['email'] ?? '';
      _phoneController.text = widget.userData!['phone'] ?? '';
      _addressController.text = widget.userData!['address'] ?? '';
      _cityController.text = widget.userData!['city'] ?? '';
      _stateController.text = widget.userData!['state'] ?? '';
      _gender = widget.userData!['gender'] ?? '';
      _status = widget.userData!['status'] ?? 'active';
    }

    // Fetch location
    _fetchLocation();
  }

  /*
Fetches the current device location using Geolocator plugin.
This function retrieves the latitude and longitude of the device's current location
with a high accuracy level and updates the state variables accordingly.
If successful, it sets the [_latitude] and [_longitude] variables with the retrieved values
and prints a success message to the console.
If an error occurs during location fetching, it catches the error and prints it to the console.
*/

  Future<void> _fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      print("Lat and long calculated Successfully");
    } catch (e) {
      print("Error fetching location: $e");
      // Handle location fetch error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData != null ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [    //Implementing validation 
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              //Address,City,State are not POST/PATCH yet saved .
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              //Using Radiobutton for Gender and Status
              ListTile(
                title: Text('Gender'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: 'male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    Text('Male'),
                    Radio(
                      value: 'female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
              ),
                            ListTile(
                title: Text('Status'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: 'active',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value.toString();
                        });
                      },
                    ),
                    Text('Active'),
                    Radio(
                      value: 'inactive',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value.toString();
                        });
                      },
                    ),
                    Text('Inactive'),
                  ],
                ),
              ),
              //Adding new user 
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> userData = {
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'address': _addressController.text,
                      'city': _cityController.text,
                      'state': _stateController.text,
                      'gender': _gender,
                      'status': _status,
                      'latitude': _latitude.toString(),
                      'longitude': _longitude.toString(),
                    };
                /*  If addUser succeeds, navigate back to the previous screen with a success indicator. Pass the boolean value to the UserScreen; 
                if it is true, call fetchUser(), which refreshes the data without reloading
                */ 

                    try {
                      await addUser(userData);
          
                     Navigator.pop(context, true);
                    } catch (e) {
                      print('Failed to add user: $e');
                      // Handle error, e.g., show error message
                    }
                  }
                },
                child: Text(widget.userData != null ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
   userData['latitude'] = _latitude.toString();
   userData['longitude'] = _longitude.toString();
   //for reference
   print( "${userData['latitude']} ,${userData['longitude']},${userData['status']},${userData['gender']}," );
   print("${userData['address']},${userData['city']},${userData['state']}");
    final response = await http.post(
      Uri.parse('https://gorest.co.in/public/v2/users'),
      headers: {
        'Content-Type': 'application/json',
            'Authorization': 'Bearer 5ddf131dc3b505fc605be2cda0a55452e0c7c8c83538740fb2cdf1b3bc07a3fc',
      },
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
     
      print('User added successfully');
    } else {
      print('Failed to add user: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add user');
    }
  }
}