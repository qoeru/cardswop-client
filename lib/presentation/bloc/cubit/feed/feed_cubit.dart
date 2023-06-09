// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:cardswop_shared/cardswop_shared.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cardswop/localenv.dart' as env;
import 'package:uuid/uuid.dart';
part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedInitial());

  Future<void> uploadComment(
      String? cardId, String content, String uid, String? seriesId) async {
    try {
      if (content == '') {
        throw Exception('unable-to-post-comment: empty comment');
      }

      var comment = Comment(
          id: const Uuid().v4(),
          content: content,
          uid: uid,
          cardId: cardId,
          seriesId: seriesId);
      var response = await http.post(Uri.http(env.HOST, env.COMMENTS_ENDPOINT),
          body: jsonEncode(comment.toJson()));

      if (response.statusCode != 200) {
        throw Exception(
            'unable-to-post-comment, code: ${response.statusCode}, body${response.body}');
      }
    } catch (e) {
      log(e.toString());
    }
    return;
  }

  Future<List<Comment>?> getCardComments(String cardId) async {
    try {
      var response = await http.get(
        Uri.http(env.HOST, '${env.CARD_COMMENTS_ENDPOINT}/$cardId'),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'unable-to-get-card, code: ${response.statusCode}, body${response.body}');
      }

      final comments =
          (jsonDecode(response.body) as Map<String, dynamic>).values;

      List<Comment> cardComments = [];

      for (var comment in comments) {
        cardComments.add(Comment.fromJson(comment));
      }

      return cardComments;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Card?> getCard(String cardId) async {
    try {
      var response = await http.get(
        Uri.http(env.HOST, '${env.CARDS_ENDPOINT}/bycardid/$cardId'),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'unable-to-get-card, code: ${response.statusCode}, body${response.body}');
      }

      final Card cardView = Card.fromJson(jsonDecode(response.body));
      return cardView;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<Card>?> getUserCards(String uid) async {
    try {
      var response = await http.get(
        Uri.http(env.HOST, '${env.CARDS_ENDPOINT}/byuserid/$uid'),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'unable-to-get-card, code: ${response.statusCode}, body${response.body}');
      }

      final cards = (jsonDecode(response.body) as Map<String, dynamic>).values;

      List<Card> userCards = [];

      for (var card in cards) {
        userCards.add(Card.fromJson(card));
      }

      return userCards;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Swopper?> getUserByUid(String uid) async {
    var response = await http.get(
      Uri.http(env.HOST, '${env.USERS_ENDPOINT}/$uid'),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'unable-to-get-user, backend error, code:  ${response.statusCode}, body${response.body}');
    }

    var user = Swopper.fromJson(jsonDecode(response.body));

    return user;
  }

  Future<Swopper?> getUserByNameSuffix(String name, int suffix) async {
    var response = await http.get(
      Uri.http(env.HOST, '${env.USERS_ENDPOINT}/$name/$suffix'),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'unable-to-get-user, backend error, code:  ${response.statusCode}, body${response.body}');
    }

    var user = Swopper.fromJson(jsonDecode(response.body));

    return user;
  }

  Future<List<Card>?> getFeed(
      bool isDesc, List<int> limitednesses, int take) async {
    try {
      var response = await http.get(Uri.http(env.HOST, env.CARDS_ENDPOINT, {
        'limitednesses': limitednesses.join(','),
        'isDesc': isDesc.toString(),
        'take': take.toString()
      }));

      if (response.statusCode != 201) {
        throw Exception(
            'unable-to-get-card, code: ${response.statusCode}, body${response.body}');
      }

      final cards = (jsonDecode(response.body) as Map<String, dynamic>).values;

      List<Card> feed = [];

      for (var card in cards) {
        feed.add(Card.fromJson(card));
      }

      return feed;
    } catch (e) {
      log('here, ${e.toString()}');
    }

    return null;
  }
}
