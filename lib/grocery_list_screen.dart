import 'package:flutter/material.dart';
import 'package:grocery/api_service.dart';

class GroceryListScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery List"),
      ),
      body: FutureBuilder<List<GroceryItem>>(
        future: apiService.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No items found"));
          } else {
            // Display the list
            final items = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10, // Horizontal spacing between items
                mainAxisSpacing: 10, // Vertical spacing between items
                childAspectRatio: 0.7, // Aspect ratio of each item
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price: ${item.price}"),
                          Text("Short Description: ${item.shortDescription}"),
                        ],
                      ),
                      trailing: Text("ID: ${item.id}"),
                      leading: Image.network(item.imageUrl),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
