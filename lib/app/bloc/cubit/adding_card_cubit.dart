// import 'dart:typed_data';

// import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
// import 'package:cardswop/domain/models/card.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'dart:developer';
// // import 'package:image/image.dart' as img;

// part 'adding_card_state.dart';

// class AddingCardCubit extends Cubit<AddingCardState> {
//   AddingCardCubit() : super(AddingCardInitial());

//   //проверить будут ли сохраняться значения прошлого кубита если оставить поля нового пустыми

//   // void getPicture(int index) {
//   //   pictures[index].

//   // }

//   Future<SwopCard> uploadCard(
//       Map<String, Uint8List> pictures,
//       String name,
//       String exchangeValue,
//       String size,
//       String? description,
//       int limited,
//       BuildContext context) async {
//     emit(AddingCardLoading());
//     final db = 
//     final db = FirebaseFirestore.instance;
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     final storageRef = FirebaseStorage.instance.ref();

//     String currentUsername = context.read<AuthCubit>().user!.username;
//     int currentUserprefix = context.read<AuthCubit>().user!.prefix;

//     // String username = await db
//     //     .collection('swoppers')
//     //     .doc()
//     //     .get()
//     //     .then((value) => value['username']);

//     List<String> pictureLinks = [];

//     for (var i = 0; i < pictures.length; i++) {
//       try {
//         final cardInStorageRef =
//             storageRef.child('$currentUsername/cards/${DateTime.now()}.jpeg');
//         UploadTask uploadTask =
//             cardInStorageRef.putData(pictures.values.elementAt(i));
//         pictureLinks
//             .add(await uploadTask.then((p0) => p0.ref.getDownloadURL()));
//       } catch (e) {
//         log(e.toString());
//       }
//     }

//     // Swopper user = Swopper(username: username);

//     SwopCard newCard = SwopCard(
//       // cid: ,
//       userprefix: currentUserprefix,
//       name: name,
//       exchangeValue: exchangeValue,
//       username: currentUsername,
//       uid: uid,
//       date: DateTime.now(),
//       pictures: pictureLinks,
//       limited: limited,
//       description: description ?? '',
//       size: size,
//     );

//     // final db = FirebaseFirestore.instance;

//     String newCardId =
//         await db.collection('cards').add(newCard.toJson()).then((doc) {
//       return doc.id;
//       // return doc;
//     });

//     newCard.cid = newCardId;
//     emit(AddingCardSuccess());
//     return newCard;
//   }

//   // Future<String> uploadInfo(SwopCard newCard) async {

//   //   return newCardId;
//   // }
// }
