// import 'package:cloud_firestore/cloud_firestore.dart';

// class SwopCard {
//   String? cid;
//   String name;
//   String exchangeValue;
//   String? description;
//   DateTime date;
//   // Swopper user;
//   String uid;
//   String username;
//   int userprefix;
//   String size;
//   int limited;

//   List<String> pictures;

//   SwopCard({
//     required this.name,
//     required this.exchangeValue,
//     required this.date,
//     required this.uid,
//     required this.username,
//     required this.pictures,
//     required this.size,
//     required this.limited,
//     required this.userprefix,
//     this.description,
//     this.cid,
//   });

//   // factory SwopCard.fromJson(Map<String, dynamic> json) => SwopCard(
//   //       name: json['name'],
//   //       exchangeValue: json['exchange_value'],
//   //       date: json['date'].toDate(),
//   //       description: json['description'],
//   //       uid: json['uid'],
//   //       limited: json['limited'],
//   //       pictures: json['pictures'],
//   //       size: json['size'],
//   //     );

//   factory SwopCard.fromSnapshot(DocumentSnapshot doc) => SwopCard(
//         cid: doc.id,
//         name: doc.get('name') as String,
//         exchangeValue: doc.get('exchange_value') as String,
//         date: doc.get('date').toDate() as DateTime,
//         description: doc.get('description') as String,
//         uid: doc.get('uid') as String,
//         username: doc.get('username') as String,
//         limited: doc.get('limited') as int,
//         pictures: List<String>.from(doc.get('pictures')),
//         size: doc.get('size') as String,
//         userprefix: doc.get('prefix') as int,
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "uid": uid,
//         "username": username,
//         "exchange_value": exchangeValue,
//         "date": date,
//         "size": size,
//         "pictures": pictures,
//         "limited": limited,
//         "description": description,
//         'prefix': userprefix,
//       };
// }
