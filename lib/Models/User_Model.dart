class UserModel {
  final String first_name, second_name;
  final String phoneNumber;
  final Address address;

  UserModel(this.first_name, this.second_name , this.phoneNumber, this.address );

  factory UserModel.fromJson(Map<String, dynamic> userDetail) {
    return UserModel(
      userDetail['first_name'],
      userDetail['second_name'],
      userDetail['phone_number'],
      Address.fromJson(userDetail['address'],),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'second_name': second_name,
      'phone_number': phoneNumber,
      'address': address.toJson(),
    };
  }
}

class Address {
  final String buildingName, street, type, state, city, pincode;

  Address(this.buildingName, this.street, this.type, this.state, this.city, this.pincode);

  factory Address.fromJson(Map<String, dynamic> addressDetail) {
    return Address(
      addressDetail['building'],
      addressDetail['street'],
      addressDetail['type'],
      addressDetail['state'],
      addressDetail['city'],
      addressDetail['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building': buildingName,
      'street': street,
      'type': type,
      'state': state,
      'city': city,
      'pincode': pincode,
    };
  }
}
