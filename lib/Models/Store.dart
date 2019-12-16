import 'package:Qpon/Models/Category.dart';

class Store {
  String id;
  String name;
  Address address;
  Category category;
  double latitude;
  double longitude;
  double distance;
  String imageUrl;
  String storeUserID;

  Store.fromMap(Map snapshot, String id)
      :
        id = id ?? '',
        name = snapshot['name'] ?? '',
        address = Address.fromMap(snapshot['address']) ?? '',
        category = Category.fromMap(snapshot['category'], snapshot['category']['id'])?? null,
        latitude = snapshot['latitude'] ?? null,
        longitude = snapshot['longitude'] ?? null;

  toJson(){
    return {
      "name": name,
      "address": address.toJson(),
      "category": category.toJson(),
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  @override
  String toString() {
    return '\n id $id \n name $name \n address {${address.toString()}} \n category $category \n latitude $latitude \n longitude $longitude \n distance $distance';
  }
}

class Address {
  String street;
  int number;
  String city;
  int zipcode;

  Address.fromMap(Map snapshot) :
      street = snapshot['street'] ?? '',
      number = snapshot['number'] ?? '',
      city = snapshot['city'] ?? '',
      zipcode = snapshot['zipcode'] ?? '';

  toJson(){
    return {
      "street": street,
      "number": number,
      "city": city,
      "zipcode": zipcode
    };
  }

  @override
  String toString() {
    return '\n\t street $street \n \t number $number \n \t city $city \n \t zipcode $zipcode';
  }
}