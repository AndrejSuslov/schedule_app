import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/screens/error_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

class MenuLoader {
  String jsonUrl;

  MenuLoader(this.jsonUrl);

  Future loadMenu() async {
    try {
      http.Response response = await http.get(Uri.parse(jsonUrl));

      if (response.statusCode == 200) {
        final String jsonString = response.body;

        String jsonString2 = jsonString.replaceAll('<br>', '');

        // print(jsonString2.substring(250));
        // print("\n");
        // print('Response body: $jsonString2');

        // final dynamic decodedJson = json.decode(jsonString2);

        final userMap = jsonDecode(jsonString2);

        // print(userMap);

        final canteen = canteenFromJson(userMap);

        return canteen;
      }
    } catch (e) {
      return null;
    }
  }
}

Canteen canteenFromJson(String str) {
  try {
    final Map<String, dynamic> jsonMap = json.decode(str);
    return Canteen.fromJson(jsonMap);
  } catch (e) {
    print('Error decoding JSON: $e');
    return Canteen(cat: [], date: '');
  }
}

String canteenToJson(Canteen data) => json.encode(data.toJson());

// @JsonSerializable()
class Canteen {
  List<Cat> cat;
  String date;

  Canteen({
    required this.cat,
    required this.date,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) => Canteen(
        cat: List<Cat>.from(json["cat"].map((x) => Cat.fromJson(x))),
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "cat": List<dynamic>.from(cat.map((x) => x.toJson())),
        "date": date,
      };
}

// @JsonSerializable()
class Cat {
  String cname;
  List<Item> item;

  Cat({
    required this.cname,
    required this.item,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        cname: json["cname"],
        item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cname": cname,
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
      };
}

class Date {
  String date;

  Date({
    required this.date,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
      };
}

// @JsonSerializable()
class Item {
  // @JsonKey(required: true, name: 'iname')
  String iname;
  // @JsonKey(required: true, name: 'iport')
  String iport;
  // @JsonKey(required: true, name: 'iprice')
  String iprice;

  int quantity;

  Item({
    required this.iname,
    required this.iport,
    required this.iprice,
    this.quantity = 1,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        iname: json["iname"],
        iport: json["iport"],
        iprice: json["iprice"],
      );

  Map<String, dynamic> toJson() => {
        "iname": iname,
        "iport": iport,
        "iprice": iprice,
      };
}
