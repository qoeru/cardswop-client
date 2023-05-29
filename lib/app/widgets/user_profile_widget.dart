// import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
// import 'package:cardswop/domain/models/user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class UserProfileWidget extends StatelessWidget {
//   const UserProfileWidget({super.key, required this.usernameWithPrefix});

//   // final Swopper user;
//   final String usernameWithPrefix;

//   // final int prefix;

//   String convertPrefix() {
//     // usernameWithPrefix.replaceAllMapped(, (match) => null)
//     return usernameWithPrefix.replaceRange(
//         (usernameWithPrefix.length - 5), (usernameWithPrefix.length - 4), '#');
//   }

//   Widget pageAboutUserNoAuth() {
//     return Text('Страница о юзере  ${convertPrefix()}. Вы не вошли в систему.');
//   }

//   Widget pageAboutOtherUser(String otherUsername, int otherPrefix) {
//     return Text(
//         'Страница о юзере ${convertPrefix()}. Вы другой юзер, $otherUsername#$otherPrefix.');
//   }

//   Widget profilePage(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           Text('Ваше имя:  ${convertPrefix()}'),
//           // Text('Ссылка на ваш профиль для других: ')
//           SizedBox(
//             height: 8,
//           ),
//           TextButton(
//               onPressed: () {
//                 context.read<AuthCubit>().closeAuth(context);
//                 context.goNamed('initial');
//               },
//               child: Text('Выйти')),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Swopper? user = context.read<AuthCubit>().user;

//     if (user == null) {
//       return pageAboutUserNoAuth();
//     } else if ('${user.username}_${user.prefix}' == usernameWithPrefix) {
//       return profilePage(context);
//     } else {
//       return pageAboutOtherUser(user.username, user.prefix);
//     }
//   }
// }
