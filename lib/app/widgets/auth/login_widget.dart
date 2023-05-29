// import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// class LoginWidget extends StatefulWidget {
//   const LoginWidget({super.key});

//   @override
//   State<LoginWidget> createState() => _LoginWidgetState();
// }

// class _LoginWidgetState extends State<LoginWidget> {
//   bool showPassword = false;
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Card(
//           color: Theme.of(context).colorScheme.background,
//           child: SizedBox(
//             height: 350,
//             width: ResponsiveBreakpoints.of(context).isDesktop ? 350 : 300,
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Вход',
//                       style: Theme.of(context).textTheme.displaySmall,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Поле не должно быть пустым';
//                         }
//                         return null;
//                       },
//                       controller: emailController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Введите свой email',
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Поле не должно быть пустым';
//                         }
//                         return null;
//                       },
//                       controller: passwordController,
//                       obscureText: !showPassword,
//                       decoration: InputDecoration(
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 showPassword = !showPassword;
//                               });
//                             },
//                             icon: showPassword
//                                 ? Icon(
//                                     EvaIcons.eyeOutline,
//                                   )
//                                 : Icon(EvaIcons.eyeOff2Outline)),
//                         border: OutlineInputBorder(),
//                         labelText: 'Введите свой пароль',
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     FilledButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           context.read<AuthCubit>().logIn(
//                               emailController.text, passwordController.text);
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: BlocBuilder<AuthCubit, AuthState>(
//                           builder: (context, state) {
//                             if (state is LoginLoading) {
//                               return LoadingAnimationWidget.waveDots(
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                   size: 20);
//                             }
//                             return const Text(
//                               'Войти',
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     BlocConsumer<AuthCubit, AuthState>(
//                         listener: (context, state) {
//                       if (state is LoggedIn ||
//                           state is LoggedWithoutEmailVerified) {
//                         context.goNamed('feed');
//                         // Navigator.pushReplacement(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => LoggedPage()));
//                         // BlocProvider.of<NavigationCubit>(context)
//                         //     .switchToHome();
//                       }
//                     }, builder: (context, state) {
//                       if (state is UnLoggedUserNotFound) {
//                         return const Text('Пользователь не найден');
//                       }
//                       if (state is UnLoggedWrongPassword) {
//                         return const Text('Неверный пароль');
//                       }
//                       if (state is UnLoggedError) {
//                         return const Text('Неизвестная ошибка');
//                       }
//                       if (state is UnLoggedInvalidEmail) {
//                         return const Text('Неверный формат почты');
//                       }
//                       return const SizedBox();
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
