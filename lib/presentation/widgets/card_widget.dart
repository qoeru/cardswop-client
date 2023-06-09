import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/presentation/bloc/cubit/feed/feed_cubit.dart';
// import 'package:cardswop/presentation/pages/loading_widget.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:cardswop_shared/cardswop_shared.dart' as db;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key, required this.cardId});

  final String cardId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  Future<List<db.Comment>?> getComments(BuildContext context) {
    return context.read<FeedCubit>().getCardComments(widget.cardId);
  }

  Future<db.Swopper?> getUserFromAComment(
      BuildContext context, db.Comment comment) {
    return context.read<FeedCubit>().getUserByUid(comment.uid);
  }

  var controller = TextEditingController();

  Widget newCommentWidget({required String cardId}) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Комментарий'),
          controller: controller,
          minLines: 3,
          maxLines: 3,
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
            onPressed: () async {
              if (controller.text == '') {
                return;
              }
              final state = context.read<AuthCubit>().state;
              if (state is LoggedIn) {
                await context.read<FeedCubit>().uploadComment(
                    cardId, controller.text, state.user.id, null);
                setState(() {
                  controller.text = '';
                });
              }
            },
            child: const Text('Отправить'))
      ],
    );
  }

  Widget commentWidget({required BuildContext context, required comment}) {
    return FutureBuilder(
        future: getUserFromAComment(context, comment),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          final swopper = snapshot.data!;

          return Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                  child: swopper.profilePicture != null
                      ? Image.network(swopper.profilePicture!)
                      : Text(
                          swopper.name.characters.first,
                        ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        swopper.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        comment.content,
                        maxLines: 500,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getComments(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              newCommentWidget(
                cardId: widget.cardId,
              ),
              ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => commentWidget(
                      context: context, comment: snapshot.data![index]))
            ],
          );
        });
  }
}

class CardInfoColumn extends StatelessWidget {
  const CardInfoColumn({super.key, required this.card});
  final db.Card card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          card.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(),
        if (card.description != null)
          Text(
            'Описание',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (card.description != null)
          Text(
            card.description!,
          ),
        if (card.description != null)
          const SizedBox(
            height: 8,
          ),
        Text(
          'Обмен на...',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          card.exchangeValue,
        ),
        const Divider(),
        CommentSection(cardId: card.id)
      ]),
    );
  }
}

class UserColumn extends StatelessWidget {
  const UserColumn({super.key, required this.uid, required this.card});

  final String uid;
  final db.Card card;

  Future<db.Swopper?> getAuthor(BuildContext context) async {
    return await context.read<FeedCubit>().getUserByUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      // width: 200,
      child: FutureBuilder(
        future: getAuthor(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Column(
              children: [
                SizedBox(
                    height: 48, width: 48, child: CircularProgressIndicator()),
                Divider(),
              ],
            );
          }
          var user = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 48,
                child: Placeholder(),
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                onPressed: () {
                  context.goNamed('user', queryParameters: {
                    'username': user.name,
                    'suffix': user.suffix.toString(),
                  });
                },
                child: Text('${user.name}#${user.suffix}'),
              ),

              const Divider(),

              // город
              if (user.mailExchange == 0) const Text('Обмен почтой: Да'),
              if (user.mailExchange == 1) const Text('Обмен почтой: Уточнять'),
              if (user.mailExchange == 2) const Text('Обмен почтой: Нет'),
            ],
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  CardWidget({super.key, required this.card});

  final db.Card card;

  final pageViewController = PageController();

  Widget picturePage(String pictureUrl, BuildContext context) {
    return Image.network(
      pictureUrl,
      filterQuality: FilterQuality.low,
      // height: 100,
      fit: BoxFit.contain,
    );
  }

  Widget picturesPageView(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (card.picturesUrl!.length > 1)
              IconButton(
                  onPressed: () {
                    pageViewController.previousPage(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.decelerate);
                  },
                  icon: const Icon(EvaIcons.arrowLeftOutline)),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.fromBorderSide(BorderSide(
                          color: Theme.of(context).colorScheme.outline))),
                  // height: double.maxFinite,
                  child: PageView(
                    controller: pageViewController,
                    children: [
                      picturePage(card.picturesUrl!.first, context),
                      if (card.picturesUrl!.length > 1)
                        picturePage(card.picturesUrl!.elementAt(1), context),
                      if (card.picturesUrl!.length > 2)
                        picturePage(card.picturesUrl!.elementAt(2), context),
                    ],
                  ),
                ),
              ),
            ),
            if (card.picturesUrl!.length > 1)
              IconButton(
                  onPressed: () {
                    pageViewController.nextPage(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.decelerate);
                  },
                  icon: const Icon(EvaIcons.arrowRightOutline)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String? selectedText;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          picturesPageView(context),
        ],
      ),
    );
  }
}

class CardPage extends StatelessWidget {
  const CardPage({super.key, required this.cardId});

  final String cardId;

  Future<db.Card?> getCard(BuildContext context) async {
    return context.read<FeedCubit>().getCard(cardId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCard(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 64),
                  alignment: Alignment.center,
                  child: const LinearProgressIndicator(),
                ),
                const Divider(),
              ],
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      flex: 1,
                      child: UserColumn(
                          uid: snapshot.data!.uid, card: snapshot.data!)),
                  const VerticalDivider(
                    width: 64,
                  ),
                  Flexible(flex: 3, child: CardWidget(card: snapshot.data!)),
                  //колонка под персонажа?
                  const VerticalDivider(
                    width: 64,
                  ),
                  Flexible(
                      flex: 2, child: CardInfoColumn(card: snapshot.data!)),
                ],
              ),
            ),
          );
        });
  }
}
