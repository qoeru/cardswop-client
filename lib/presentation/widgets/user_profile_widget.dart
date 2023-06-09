import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/presentation/bloc/cubit/feed/feed_cubit.dart';
import 'package:cardswop_shared/cardswop_shared.dart' as db;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class UserColumn extends StatelessWidget {
  const UserColumn({super.key, required this.user});

  final db.Swopper user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 64,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            child: Text(
              user.name.characters.first.toUpperCase(),
              style: TextStyle(fontSize: 48),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text('${user.name}#${user.suffix}'),
          const Divider(),
          TextButton(
              onPressed: () {
                context.read<AuthCubit>().closeAuth();
                context.goNamed('login');
              },
              child: const Text('Выйти')),
        ],
      ),
    );
  }
}

class ProfileCards extends StatelessWidget {
  const ProfileCards({super.key, required this.user});

  final db.Swopper user;

  Widget cardPreview(
      String url, String cardId, int limitedness, BuildContext context) {
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

  Widget cardName(String name, BuildContext context) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Future<List<db.Card>?> getUserCards(BuildContext context) {
    return context.read<FeedCubit>().getUserCards(user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Карточки юзера',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(),
        FutureBuilder(
            future: getUserCards(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    alignment: Alignment.center,
                    child: const LinearProgressIndicator());
              }

              List<db.Card>? cards = snapshot.data;

              return MasonryGridView.count(
                crossAxisCount: 3,
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
                          cards[index].id, cards[index].limitedness, context),
                      cardName(cards[index].name, context),
                    ],
                  );
                }),
              );
            }),
      ],
    );
    // Text('Ссылка на ваш профиль для других: ')
  }
}

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    super.key,
    required this.username,
    required this.suffix,
  });

  final String username;
  final int suffix;

  Widget pageAboutUserNoAuth() {
    return Text('Страница о юзере  $username#$suffix. Вы не вошли в систему.');
  }

  Widget pageAboutOtherUser(String otherUsername, int otherPrefix) {
    return Text(
        'Страница о юзере $username#$suffix. Вы другой юзер, $otherUsername#$otherPrefix.');
  }

  Widget userPage(BuildContext context) {
    db.Swopper? user;

    var state = context.read<AuthCubit>().state;
    if (state is LoggedIn) {
      user = state.user;
    }
    if (user == null) {
      return pageAboutUserNoAuth();
    } else if (user.name == username && user.suffix == suffix) {
      return ProfileCards(user: user);
    } else {
      return pageAboutOtherUser(user.name, user.suffix);
    }
  }

  Future<db.Swopper?> getUser(BuildContext context) {
    return context.read<FeedCubit>().getUserByNameSuffix(username, suffix);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: Alignment.center,
                child: const LinearProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: UserColumn(
                      user: snapshot.data!,
                    )),
                Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: userPage(context),
                    )),
              ],
            ),
          );
        });
  }
}
