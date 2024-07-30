import 'package:flutter/material.dart';

class BabysitterSignUpPage extends StatefulWidget {
  @override
  _BabysitterSignUpPageState createState() => _BabysitterSignUpPageState();
}

class _BabysitterSignUpPageState extends State<BabysitterSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String gender = '';
  String email = '';
  String password = '';
  String phoneNumber = '';
  DateTime birthDate = DateTime.now();
  String experienceTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up as Babysitter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'Please enter your name';
                  // }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  // setState(() {
                  //   gender = value;
                  // });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'Please enter your email';
                  // }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'Please enter your password';
                  // }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'Please enter your phone number';
                  // }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Experience Time (years)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    experienceTime = value;
                  });
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'Please enter your experience time';
                  // }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Birth Date (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  // setState(() {
                  //   birthDate = DateTime.tryParse(value);
                  // });
                },
                validator: (value) {
                  if (birthDate == null) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState.validate()) {
                  //   // Save the form data
                  //   _formKey.currentState.save();
                  //   // Process the sign-up data here
                  //   print('Name: $name');
                  //   print('Gender: $gender');
                  //   print('Email: $email');
                  //   print('Password: $password');
                  //   print('Phone Number: $phoneNumber');
                  //   print('Experience Time: $experienceTime');
                  //   print('Birth Date: $birthDate');
                  //   // Show success message or navigate to another page
                  // }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
