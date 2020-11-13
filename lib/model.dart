import 'package:flutter/foundation.dart';

class FooditemList {
  List<FoodItem> foodItems;

  FooditemList({@required this.foodItems});
}

class FoodItem {
  int id;
  String title;
  double price;
  int quantity;
  String imgUrl;
  String category;
  static double total = 0;
  static int totalQty = 0;
  
  FoodItem({
    @required this.id,
    @required this.title,
    @required this.price,
    this.imgUrl,
    this.category,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
    total = total + this.price;
    totalQty = totalQty + 1;
  }

  void decrementQuantity() {
    if(this.quantity>0){
      this.quantity = this.quantity - 1;
      total = total - this.price;
      totalQty = totalQty - 1;
    }
  }
}

  FooditemList fooditemList =
    FooditemList(foodItems: [
      FoodItem(id: 1, title: 'Fix Lunch', price: 60,category: 'Lunch',imgUrl: 'https://firebasestorage.googleapis.com/v0/b/canteen-4a7ec.appspot.com/o/Fix%20Lunch.jpg?alt=media&token=50717812-cf72-4d3c-8c88-c610cd0f2c79'),
      FoodItem(id: 2, title: 'Burger', price: 50, category: 'Burger',imgUrl: 'https://firebasestorage.googleapis.com/v0/b/canteen-4a7ec.appspot.com/o/Burger.jpg?alt=media&token=65466867-3ec8-45f8-aa72-3e25697500c1'),
      FoodItem(id: 3, title: 'Sandwich', price: 60, category: 'Sandwich',imgUrl: 'https://firebasestorage.googleapis.com/v0/b/canteen-4a7ec.appspot.com/o/Sandwich.jpg?alt=media&token=e9f50ee7-cf99-433d-a886-4259942ee73a'),
      FoodItem(id: 4, title: 'Plain Dosa', price: 50, category: 'Dosa',imgUrl: 'https://firebasestorage.googleapis.com/v0/b/canteen-4a7ec.appspot.com/o/Dosa.jpg?alt=media&token=da4af5fd-b437-4e5e-af86-c349eeeda814'),
      FoodItem(id: 5, title: 'Masala Dosa', price: 70, category: 'Dosa'),
      FoodItem(id: 6, title: 'Paratha', price: 30,category: 'Paratha',imgUrl: 'https://firebasestorage.googleapis.com/v0/b/canteen-4a7ec.appspot.com/o/Paratha.JPG?alt=media&token=de691ea1-b065-48f3-b392-5cd3d6c43893'),
      FoodItem(id: 7, title: 'Samosa', price: 40, category: 'Samosa',imgUrl: 'https://firebasestorage.googleapis.com/v0/b/canteen-4a7ec.appspot.com/o/Samosa.jpg?alt=media&token=4d9a382e-5076-41bd-a274-2b2c9d57f621'),
      FoodItem(id: 8, title: 'Cheese Burger', price: 70, category: 'Burger',),
      FoodItem(id: 9, title: 'Butter Dabeli', price: 30, category: 'Dabeli'),
      FoodItem(id: 10, title: 'Masala Dosa', price: 70, category: 'Dosa'),
     FoodItem(id: 11, title: 'Mysore Masala Dosa', price: 90, category: 'Dosa'),                       
     FoodItem(id: 12, title: 'Bhaji Dosa', price: 85,category: 'Dosa'),
      FoodItem(id: 13, title: 'Veg. Sandwich', price: 50, category: 'Sandwich'),
        FoodItem(id: 14, title: 'Veg. Chesse Sandwich', price: 60, category: 'Sandwich'),
           FoodItem(id: 15, title: 'Italian Sandwich', price: 80, category: 'Sandwich'),  
            FoodItem(id: 16, title: 'Mexican Sandwich', price: 90, category: 'Sandwich'), 
            FoodItem(id: 17, title: 'Oil Vadapav', price: 25, category: 'Vadapav'),
        FoodItem(id: 18, title: 'Butter Vadapav', price: 35, category: 'Vadapav'),
      FoodItem(id: 19, title: 'Oil Dabeli', price: 20,category: 'Dabeli'),
      ]);

    
