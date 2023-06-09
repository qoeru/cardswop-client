import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/localenv.dart' as env;
import 'package:cardswop_shared/cardswop_shared.dart' as prisma;

part 'adding_card_state.dart';

class AddingCardCubit extends Cubit<AddingCardState> {
  AddingCardCubit() : super(AddingCardInitial());

  Future<String> getImagePath(Uint8List img, String imageName) async {
    final String type;

    if (imageName.endsWith('.png')) {
      type = 'png';
    } else if (imageName.endsWith('.jpg')) {
      type = 'jpg';
    } else {
      throw Exception('unable-to-upload-image, wrong image type');
    }

    var response = await http.post(Uri.http(env.HOST, env.UPLOAD_ENDPOINT),
        headers: {'type': type}, body: jsonEncode({'img': img}));

    if (response.statusCode != 201) {
      throw Exception(
          'unable-to-upload-image, code: ${response.statusCode}, body${response.body}');
    }

    var body = jsonDecode(response.body);

    return 'http://${env.HOST}/cards_images/${body['img_path']}';
  }

  void createCard(
      Map<String, Uint8List> pictures,
      String name,
      String exchangeValue,
      String size,
      bool isWithCharacter,
      String? description,
      int limitedness,
      prisma.Series? series,
      List<String> material,
      bool isDifferentVersions,
      List<prisma.Card>? otherCards,
      BuildContext context) async {
    emit(AddingCardLoading());

    var state = context.read<AuthCubit>().state;

    if (state is LoggedIn) {
      prisma.Swopper user = state.user;

      List<String> pictureLinks = [];

      for (var i = 0; i < pictures.length; i++) {
        try {
          String path = await getImagePath(
              pictures.values.elementAt(i), pictures.keys.elementAt(i));
          pictureLinks.add(path);
        } catch (e) {
          emit(AddingCardFailed());
        }
      }

      prisma.Card newCard = prisma.Card(
        id: const Uuid().v4(),
        size: size,
        name: name,
        uid: user.id,
        description: description,
        picturesUrl: pictureLinks,
        exchangeValue: exchangeValue,
        isWithCharacter: isWithCharacter,
        limitedness: limitedness,
        date: DateTime.now(),
        material: material,
        differentVersions: isDifferentVersions,
      );

      try {
        var response = await http.post(Uri.http(env.HOST, env.CARDS_ENDPOINT),
            body: jsonEncode(newCard.toJson()));

        if (response.statusCode != 201) {
          throw Exception(
              'unable-to-upload-card, code: ${response.statusCode}, body${response.body}');
        }
      } catch (e) {
        emit(AddingCardFailed());
        log(e.toString());
        return;
      }

      emit(AddingCardSuccess(card: newCard));
      log('asdda');
      return;
    }
    emit(AddingCardFailed());
    log('ehhh');
  }
}
