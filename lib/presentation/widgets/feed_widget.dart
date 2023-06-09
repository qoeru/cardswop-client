import 'package:card_loading/card_loading.dart';
import 'package:cardswop/presentation/bloc/cubit/feed/feed_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cardswop_shared/cardswop_shared.dart' as db;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({
    super.key,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  bool isSortedByDateDesc = true;

  bool showRegular = true;
  bool showLimited = true;
  bool showSpecial = true;

  Future<List<db.Card>?> getFeed(BuildContext context) async {
    List<int> limitednesses = [];
    if (showRegular == true) limitednesses.add(0);
    if (showLimited == true) limitednesses.add(1);
    if (showSpecial == true) limitednesses.add(2);

    return await context
        .read<FeedCubit>()
        .getFeed(isSortedByDateDesc, limitednesses, 20);
  }

  Widget cardPreview(String url, String cardId, int limitedness) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          context.goNamed('card', pathParameters: {'cardId': cardId});
        },
        child: Image.network(
          url,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget cardName(String name) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget sortColumn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Сортировка',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                groupValue: isSortedByDateDesc,
                value: false,
                onChanged: (value) {
                  if (!showLimited && !showSpecial) {
                    return;
                  }
                  setState(() {
                    isSortedByDateDesc = value!;
                  });
                },
              ),
              const Text('Дата, сначала старые'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                groupValue: isSortedByDateDesc,
                value: true,
                onChanged: (value) {
                  if (!showLimited && !showSpecial) {
                    return;
                  }
                  setState(() {
                    isSortedByDateDesc = value!;
                  });
                },
              ),
              const Text('Дата, сначала новые'),
            ],
          ),
          const Divider(
            height: 24,
          ),
          Text(
            'Тип',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: showRegular,
                onChanged: (value) {
                  if (!showLimited && !showSpecial) {
                    return;
                  }
                  setState(() {
                    showRegular = value!;
                  });
                },
              ),
              const Text('Регулярные'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: showLimited,
                onChanged: (value) {
                  if (!showRegular && !showSpecial) {
                    return;
                  }
                  setState(() {
                    showLimited = value!;
                  });
                },
              ),
              const Text('Лимитированные'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: showSpecial,
                onChanged: (value) {
                  if (!showRegular && !showLimited) {
                    return;
                  }
                  setState(() {
                    showSpecial = value!;
                  });
                },
              ),
              const Text('Особенные'),
            ],
          ),
          const Divider(
            height: 24,
          ),
          ElevatedButton(
              onPressed: () {
                context.goNamed('newcard');
              },
              child: const Text('Загрузить карточку'))
        ],
      ),
    );
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sortColumn(context),
        const VerticalDivider(),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, right: 24),
              child: FutureBuilder(
                  future: getFeed(context),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          alignment: Alignment.center,
                          child: const LinearProgressIndicator());
                    }

                    List<db.Card>? cards = snapshot.data;
                    return Column(
                      children: [
                        MasonryGridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount: cards != null ? cards.length : 20,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                cardPreview(cards![index].picturesUrl!.first,
                                    cards[index].id, cards[index].limitedness),
                                cardName(cards[index].name),
                              ],
                            );
                          }),
                        ),
                        const Text('Вы долистали до конца! o_O')
                      ],
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
