import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service file
import 'grocery_list_screen.dart'; // Import the screen displaying the grocery list

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Management System',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: GroceryListScreen(),
    );
  }
}
