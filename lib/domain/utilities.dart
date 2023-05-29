// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:developer';
// import 'package:cardswop/domain/models/card.dart';

// class Utilities {
//   late List<SwopCard> currentCards;
//   late DocumentSnapshot lastVisible;

//   Utilities() {
//     FirebaseFirestore.instance
//         .collection('cards')
//         .orderBy('date', descending: false)
//         // .limit(20)
//         .get()
//         .then(
//       (documentSnapshots) {
//         lastVisible = documentSnapshots.docs[documentSnapshots.size - 1];
//         for (var doc in documentSnapshots.docs) {
//           if (!doc.exists) {
//             log('no such doc');
//           }
//           currentCards.add(SwopCard.fromSnapshot(doc));
//           log(currentCards.length.toString());
//         }
//       },
//       onError: (e) => log("Error completing: $e"),
//     );
//   }
// }
