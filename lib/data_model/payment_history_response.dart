// To parse this JSON data, do
//
//     final paymentHistoryResponse = paymentHistoryResponseFromJson(jsonString);

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

PaymentHistoryResponse paymentHistoryResponseFromJson(String str) =>
    PaymentHistoryResponse.fromJson(json.decode(str));

String paymentHistoryResponseToJson(PaymentHistoryResponse data) =>
    json.encode(data.toJson());

class PaymentHistoryResponse {
  PaymentHistoryResponse({
    this.data,
    this.links,
    this.meta,
  });

  List<Payment>? data;
  Links? links;
  Meta? meta;

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryResponse(
        data: List<Payment>.from(json["data"].map((x) => Payment.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links!.toJson(),
        "meta": meta!.toJson(),
      };
}

class Payment {
  Payment({
    this.id,
    this.amount,
    this.paymentMethod,
    this.paymentDate,
  });

  int? id;
  String? amount;
  String? paymentMethod;
  String? paymentDate;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        paymentDate: json["payment_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "payment_method": paymentMethod,
        "payment_date": paymentDate,
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
  dynamic next;

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

  var currentPage;
  var from;
  var lastPage;
  List<Link>? links;
  String? path;
  var perPage;
  var to;
  var total;

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
