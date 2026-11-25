class Geo {
  const Geo({required this.lat, required this.lng});
  final String lat;
  final String lng;

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        lat: json['lat'] as String,
        lng: json['lng'] as String,
      );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class Address {
  const Address({required this.city, required this.geo});
  final String city;
  final Geo geo;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json['city'] as String,
        geo: Geo.fromJson(json['geo'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {'city': city, 'geo': geo.toJson()};
}

class User {
  const User({required this.id, required this.name, required this.email, required this.address});
  final int id;
  final String name;
  final String email;
  final Address address;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'address': address.toJson(),
      };
}
