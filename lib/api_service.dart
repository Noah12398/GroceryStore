import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ApiService {
  final String apiUrl =
      "https://grocery-pricing-api.p.rapidapi.com/searchGrocery?keyword=sweet%20potato&perPage=10&page=1";

  final Map<String, String> headers = {
    'X-RapidAPI-Host': 'grocery-pricing-api.p.rapidapi.com',
    'X-RapidAPI-Key': '',
  };

 Future<List<GroceryItem>> fetchData() async {
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    // Debug: Log the raw response from the API
    // print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body); // Parse JSON

      // Debug: Log the decoded JSON data
      // print('Decoded JSON Data: $jsonData');

      // Use the correct key 'hits' instead of 'items'
      if (jsonData['hits'] != null) {
        // Debug: Log the list of items being returned
        // print('Items: ${jsonData['hits']}');
        return (jsonData['hits'] as List)
            .map((item) => GroceryItem.fromJson(item))
            .toList();
      } else {
        throw Exception("No items found in response");
      }
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    print('Error occurred: $e');
    throw Exception("Error occurred: $e");
  }
}


}
class GroceryItem {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String shortDescription;

  GroceryItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.shortDescription,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'],
      name: json['name'],
      price: json['priceInfo']['linePrice'] ?? "No price available",
      imageUrl: json['image'],
      shortDescription: _parseHtml(json['shortDescription'] ?? "No description available"),
    );
  }

  static String _parseHtml(String htmlContent) {
    var document = parse(htmlContent);
    return parse(document.body?.text ?? "").documentElement?.text ?? "No description available";
  }
}
