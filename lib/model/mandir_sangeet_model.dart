// To parse this JSON data, do
//
//     final mandirBhajanModel = mandirBhajanModelFromJson(jsonString);

import 'dart:convert';

MandirBhajanModel mandirBhajanModelFromJson(String str) => MandirBhajanModel.fromJson(json.decode(str));

String mandirBhajanModelToJson(MandirBhajanModel data) => json.encode(data.toJson());

class MandirBhajanModel {
  int status;
  Category category;
  List<Subcategory> subcategories;

  MandirBhajanModel({
    required this.status,
    required this.category,
    required this.subcategories,
  });

  factory MandirBhajanModel.fromJson(Map<String, dynamic> json) => MandirBhajanModel(
    status: json["status"],
    category: Category.fromJson(json["category"]),
    subcategories: List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "category": category.toJson(),
    "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
  };
}

class Category {
  String name;
  int id;

  Category({
    required this.name,
    required this.id
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],id: json["id"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}

class Subcategory {
  int id;
  String enName;
  String hiName;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Subcategory({
    required this.id,
    required this.enName,
    required this.hiName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["id"],
    enName: json["en_name"],
    hiName: json["hi_name"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "en_name": enName,
    "hi_name": hiName,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
