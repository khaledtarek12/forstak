// To parse this JSON data, do
//
//     final productReviewResponse = productReviewResponseFromJson(jsonString);

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

ProductReviewResponse productReviewResponseFromJson(String str) => ProductReviewResponse.fromJson(json.decode(str));

String productReviewResponseToJson(ProductReviewResponse data) => json.encode(data.toJson());

class ProductReviewResponse {
  ProductReviewResponse({
    this.data,
    this.links,
    this.meta,
  });

  List<Review>? data;
  Links? links;
  Meta? meta;

  factory ProductReviewResponse.fromJson(Map<String, dynamic> json) => ProductReviewResponse(
    data: List<Review>.from(json["data"].map((x) => Review.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links!.toJson(),
    "meta": meta!.toJson(),
  };
}

class Review {
  Review({
    this.id,
    this.rating,
    this.comment,
    this.status,
    this.updatedAt,
    this.productName,
    this.userId,
    this.name,
    this.avatar,
  });

  int? id;
  var rating;
  String? comment;
  int? status;
  DateTime? updatedAt;
  String? productName;
  int? userId;
  String? name;
  dynamic avatar;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    rating: json["rating"],
    comment: json["comment"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    productName: json["product_name"],
    userId: json["user_id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "comment": comment,
    "status": status,
    "updated_at": updatedAt!.toIso8601String(),
    "product_name": productName,
    "user_id": userId,
    "name": name,
    "avatar": avatar,
  };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  dynamic prev;
  String? next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
