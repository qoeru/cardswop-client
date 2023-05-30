// import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';

// import 'package:cardswop/domain/models/user.dart';
// import 'package:context_menus/context_menus.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';

// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:go_router/go_router.dart';
// import 'package:responsive_framework/responsive_breakpoints.dart';

// class LoggedPage extends StatelessWidget {
//   const LoggedPage({super.key, required this.child});
//   final Widget child;
//   // int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: ResponsiveBreakpoints.of(context).isMobile
//           ? AddButtonExtended()
//           : SizedBox(),
//       appBar: AppBar(
//           title: IconButton(
//             onPressed: () {
//               context.goNamed('feed');
//             },
//             icon: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(EvaIcons.homeOutline),
//             ),
//           ),
//           // leading: TextButton.icon(
//           //     label: Text('РЕЕСТР'),
//           //     onPressed: () {
//           //       context.goNamed('feed');
//           //     },

//           actions: [
//             if (!ResponsiveBreakpoints.of(context).isMobile)
//               AddButtonExtended(),
//             TextButton(
//               onPressed: () {
//                 Swopper currentUser = context.read<AuthCubit>().user!;
//                 context.goNamed(
//                   'user',
//                   pathParameters: {
//                     'userId': '${currentUser.username}_${currentUser.prefix}',
//                   },
//                 );
//               },
//               child: Text('Профиль'),
//             ),
//             TextButton(
//               onPressed: () {
//                 context.goNamed('about');
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => AboutWidget()));
//                 // context.read<NavigationCubit>().switchToAbout();
//               },
//               child: Text('О сайте'),
//             ),
//             SizedBox(
//               width: 50,
//             )
//           ]),
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: ContextMenuOverlay(
//           buttonStyle: ContextMenuButtonStyle(
//               textStyle: Theme.of(context).textTheme.labelMedium),
//           child: child),
//     );
//   }
// }

// class AddButtonExtended extends StatelessWidget {
//   const AddButtonExtended({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 130,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4.0),
//         child: FilledButton(
//           onPressed: () {
//             context.goNamed('newcard');
//           },
//           style: ButtonStyle(
//               minimumSize: MaterialStateProperty.all(const Size(50, 50))),
//           child: Row(
//             children: [
//               Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
//               const Text('Добавить'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VerificationBanner extends StatefulWidget {
//   const VerificationBanner({super.key});

//   @override
//   State<VerificationBanner> createState() => _VerificationBannerState();
// }

// class _VerificationBannerState extends State<VerificationBanner> {
//   bool? _isVisible;
//   @override
//   void initState() {
//     _isVisible = true;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       maintainAnimation: true,
//       visible: _isVisible!,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Card(
//           color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: (MediaQuery.of(context).size.width < 601)
//                       ? MediaQuery.of(context).size.width / 7
//                       : MediaQuery.of(context).size.width - 556,
//                   child: Text(
//                       'Ваша почта не подтверждена. На указанный вами email было отправлено письмо с ссылкой для подтверждения, пожалуйста подтвердите свой почтовый адрес.'),
//                 ),
//                 TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _isVisible = false;
//                       });
//                     },
//                     child: const Text('Позже')),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       context.read<AuthCubit>().emitEmailVerification();
//                       _isVisible = false;
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: const Text('Письмо отослано!'),
//                           action: SnackBarAction(
//                             label: 'Понятно',
//                             onPressed: () {
//                               ScaffoldMessenger.of(context)
//                                   .hideCurrentSnackBar();
//                             },
//                           )));
//                     });
//                   },
//                   child: const Text('Выслать подтверждение еще раз'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class VerificationBanner extends StatelessWidget {
// //   const VerificationBanner({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Card(
// //         color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
// //         child: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Row(
// //             children: [
// //               SizedBox(
// //                 width: (MediaQuery.of(context).size.width < 601)
// //                     ? MediaQuery.of(context).size.width / 7
// //                     : MediaQuery.of(context).size.width - 556,
// //                 child: Text(
// //                     'Ваша почта не подтверждена. На указанный вами email было отправлено письмо с ссылкой для подтверждения, пожалуйста подтвердите свой почтовый адрес.'),
// //               ),
// //               TextButton(
// //                   onPressed: () {
// //                     isVisible = false;
// //                   },
// //                   child: const Text('Позже')),
// //               TextButton(
// //                 onPressed: () {
// //                   context.read<AuthCubit>().emitEmailVerification();
// //                   isVisible = false;
// //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                       content: const Text('Письмо отослано!'),
// //                       action: SnackBarAction(
// //                         label: 'Понятно',
// //                         onPressed: () {
// //                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
// //                         },
// //                       )));
// //                 },
// //                 child: const Text('Выслать подтверждение еще раз'),
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
