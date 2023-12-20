// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:json_annotation/json_annotation.dart';

// class MenuLoader {
//   String jsonUrl;

//   MenuLoader(this.jsonUrl);

//   Future<Canteen?> loadMenu() async {
//     try {
//       http.Response response = await http.get(Uri.parse(jsonUrl));

//       if (response.statusCode == 200) {
//         final String jsonString = response.body;

//         String jsonString2 = jsonString
//             .substring(1, jsonString.length - 1)
//             .replaceAll('\\r\\n', '')
//             .replaceAll("\\", '');

//         print(jsonString2.substring(250));
//         print("\n");
//         print('Response body: $jsonString2');

//         final dynamic decodedJson = json.decode(jsonString2);

//         if (decodedJson! is Map<String, dynamic>) {
//           final canteen = canteenFromJson(jsonString2);
//           return canteen;
//         } else {
//           print('Failed to decode JSON. Unexpected format.');
//           return null;
//         }
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error loading data: $e');
//       return null;
//     }
//   }
// }

// Canteen canteenFromJson(String str) {
//   try {
//     final Map<String, dynamic> jsonMap = json.decode(str);
//     return Canteen.fromJson(jsonMap);
//   } catch (e) {
//     print('Error decoding JSON: $e');
//     return Canteen(cat: []);
//   }
// }

// String canteenToJson(Canteen data) => json.encode(data.toJson());

// @JsonSerializable()
// class Canteen {
//   List<Cat> cat;

//   Canteen({
//     required this.cat,
//   });

//   factory Canteen.fromJson(Map<String, dynamic> json) => Canteen(
//         cat: List<Cat>.from(json["cat"].map((x) => Cat.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "cat": List<dynamic>.from(cat.map((x) => x.toJson())),
//       };
// }

// @JsonSerializable()
// class Cat {
//   String cname;
//   List<Item> item;

//   Cat({
//     required this.cname,
//     required this.item,
//   });

//   factory Cat.fromJson(Map<String, dynamic> json) => Cat(
//         cname: json["cname"],
//         item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "cname": cname,
//         "item": List<dynamic>.from(item.map((x) => x.toJson())),
//       };
// }

// @JsonSerializable()
// class Item {
//   @JsonKey(required: true, name: 'iname')
//   String iname;
//   @JsonKey(required: true, name: 'iport')
//   String iport;
//   @JsonKey(required: true, name: 'iprice')
//   String iprice;

//   Item({
//     required this.iname,
//     required this.iport,
//     required this.iprice,
//   });

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         iname: json["iname"],
//         iport: json["iport"],
//         iprice: json["iprice"],
//       );

//   Map<String, dynamic> toJson() => {
//         "iname": iname,
//         "iport": iport,
//         "iprice": iprice,
//       };
// }

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
    return Canteen(cat: []);
  }
}

String canteenToJson(Canteen data) => json.encode(data.toJson());

// @JsonSerializable()
class Canteen {
  List<Cat> cat;

  Canteen({
    required this.cat,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) => Canteen(
        cat: List<Cat>.from(json["cat"].map((x) => Cat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cat": List<dynamic>.from(cat.map((x) => x.toJson())),
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
