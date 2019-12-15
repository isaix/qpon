class Store{
  String name;
  Address address;
  Category category;
  double latitude;
  double longitude;
}


class Address {
  String street;
  String number;
  String city;
  int zipcode;
}

enum Category {
  bar,
  pizza,
  sushi,
  sandwich,
  other
}