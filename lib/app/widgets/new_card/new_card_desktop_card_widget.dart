// import 'dart:typed_data';
// import 'package:cardswop/app/bloc/cubit/adding_card_cubit.dart';
// import 'package:cardswop/domain/models/card.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:im_stepper/stepper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// class NewCardMaterialCardWidget extends StatefulWidget {
//   const NewCardMaterialCardWidget({super.key});

//   @override
//   State<NewCardMaterialCardWidget> createState() =>
//       _NewCardMaterialCardWidgetState();
// }

// class _NewCardMaterialCardWidgetState extends State<NewCardMaterialCardWidget> {
//   int activeStep = 0;
//   int upperBound = 2;
//   int limitation = 0;

//   var _formKey = GlobalKey<FormState>();

//   Map<String, Uint8List> pictures = {};

//   SwopCard? card;

//   var nameController = TextEditingController();
//   var exchangeValueController = TextEditingController();
//   var descriptionController = TextEditingController();

//   void _pickImage() async {
//     final XFile? pickedImage = await ImagePicker()
//         .pickImage(source: ImageSource.gallery, maxWidth: 480, maxHeight: 480);

//     if (pickedImage != null) {
//       pictures[pickedImage.name] = await pickedImage.readAsBytes();
//     }
//     setState(() {});
//   }

//   bool isVisibleText = true;
//   bool isVisibleMaxImages = false;

//   Widget pictureTile(int index, String pictureName, Uint8List picture) {
//     return Container(
//       height: 70,
//       width: 300,
//       decoration: BoxDecoration(
//           border: Border.all(), borderRadius: BorderRadius.circular(10)),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 8,
//             ),
//             DottedBorder(
//               child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Image.memory(
//                     picture,
//                     filterQuality: FilterQuality.medium,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 16,
//             ),
//             SizedBox(
//               width: ResponsiveBreakpoints.of(context).isMobile ? 50 : 100,
//               child: Text(
//                 pictureName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     pictures.remove(pictureName);
//                   });
//                 },
//                 icon: Icon(EvaIcons.trash2Outline)),
//           ]),
//     );
//   }

//   Widget cardDropZone() {
//     return Column(
//       children: [
//         if (isVisibleMaxImages) Text('Изображений не может быть больше 3'),
//         DottedBorder(
//           child: SizedBox(
//             width: ResponsiveBreakpoints.of(context).isDesktop
//                 ? MediaQuery.of(context).size.width / 4
//                 : MediaQuery.of(context).size.width / 2,
//             height: 320,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Visibility(
//                   visible: pictures.isNotEmpty ? false : true,
//                   child: Center(
//                     child: TextButton(
//                         onPressed: () {
//                           _pickImage();
//                         },
//                         child: const Text('Прикрепите изображения')),
//                   ),
//                 ),
//                 Visibility(
//                   visible: pictures.isNotEmpty ? true : false,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 320,
//                           height: 250,
//                           alignment: Alignment.center,
//                           child: ListView.builder(
//                             // controller: _pageScrollController,
//                             // scrollDirection: Axis.vertical,
//                             itemCount: pictures.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: pictureTile(
//                                   index,
//                                   pictures.keys.elementAt(index),
//                                   pictures.values.elementAt(index),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: pictures.length >= 3
//                               ? null
//                               : () {
//                                   _pickImage();
//                                 },
//                           child: const Text('Прикрепить еще изображение'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Visibility(
//                 //   visible: (pictures.isEmpty || (pictures.length == 3)) ? false  true,
//                 //   child: IconButton(
//                 //     onPressed: () {
//                 //       _pickImage();
//                 //     },
//                 //     icon: Icon(EvaIcons.fileAddOutline),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget activeStepZeroDesktop() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   cardName(context),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   exchangeValues(context),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//             cardDropZone(),
//           ],
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         nextButton(),
//       ],
//     );
//   }

//   Widget activeStepZeroMobile() {
//     return Column(
//       children: [
//         Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               cardName(context),
//               const SizedBox(
//                 height: 8,
//               ),
//               exchangeValues(context),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         cardDropZone(),
//         const SizedBox(
//           height: 8,
//         ),
//         nextButton(),
//         const SizedBox(
//           height: 8,
//         ),
//       ],
//     );
//   }

//   Widget activeStepOne() {
//     return Column(
//       // mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         limitations(context),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             previousButton(),
//             SizedBox(
//               width: 8,
//             ),
//             nextButton(),
//           ],
//         )
//       ],
//     );
//   }

//   Widget limitations(BuildContext context) {
//     // limitation = 0;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 180,
//         width: 300,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ListTile(
//               title: Text('Лимитированность'),
//             ),
//             ListTile(
//               horizontalTitleGap: 5,
//               dense: true,
//               title: const Text(
//                 'Постоянная',
//                 style: TextStyle(fontSize: 14),
//               ),
//               leading: Radio<int>(
//                 value: 0,
//                 groupValue: limitation,
//                 onChanged: (int? value) {
//                   setState(() {
//                     limitation = value!;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               horizontalTitleGap: 5,
//               dense: true,
//               title: const Text(
//                 'Лимитированная',
//                 style: TextStyle(fontSize: 14),
//               ),
//               leading: Radio<int>(
//                 value: 1,
//                 groupValue: limitation,
//                 onChanged: (int? value) {
//                   setState(() {
//                     limitation = value!;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               horizontalTitleGap: 5,
//               dense: true,
//               title: Text(
//                 'Особенная',
//                 style: TextStyle(fontSize: 14),
//               ),
//               leading: Radio<int>(
//                 value: 2,
//                 groupValue: limitation,
//                 onChanged: (int? value) {
//                   setState(() {
//                     limitation = value!;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget submitButton() {
//     return FilledButton(onPressed: () async {
//       // SwopCard swopCard = SwopCard(name: nameController.text, exchangeValue: exchangeValue, date: date, uid: uid, username: username, pictures: pictures, size: size, limited: limited)

//       card = await context.read<AddingCardCubit>().uploadCard(
//           pictures,
//           nameController.text,
//           exchangeValueController.text,
//           "88x63",
//           descriptionController.text,
//           limitation,
//           context);

//       // context.read<NavigationCubit>().switchToHome();
//       // Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: ((context) => CardWidget(card: card))));
//     }, child: BlocBuilder<AddingCardCubit, AddingCardState>(
//       builder: (context, state) {
//         if (state is AddingCardLoading) {
//           return LoadingAnimationWidget.waveDots(
//               color: Theme.of(context).colorScheme.onPrimary, size: 20);
//         }
//         return const Text('Отправить');
//       },
//     ));
//   }

//   Widget cardDescription(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: ResponsiveBreakpoints.of(context).isMobile
//             ? MediaQuery.of(context).size.width / 2
//             : MediaQuery.of(context).size.width / 4,
//         child: TextFormField(
//             controller: descriptionController,
//             minLines: 6,
//             maxLines: 6,
//             decoration: InputDecoration(
//               helperText: 'Необзязательно',
//               hintText: 'Описание',
//             )),
//       ),
//     );
//   }

//   Widget exchangeValues(BuildContext context) {
//     return SizedBox(
//       width: ResponsiveBreakpoints.of(context).isMobile
//           ? MediaQuery.of(context).size.width / 2
//           : MediaQuery.of(context).size.width / 4,
//       child: TextFormField(
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Обязательно поле';
//             }
//           },
//           controller: exchangeValueController,
//           minLines: 11,
//           maxLines: 11,
//           decoration: InputDecoration(
//             hintText: 'Обмен на:',
//           )),
//     );
//   }

//   Widget cardName(BuildContext context) {
//     return SizedBox(
//       width: ResponsiveBreakpoints.of(context).isMobile
//           ? MediaQuery.of(context).size.width / 2
//           : MediaQuery.of(context).size.width / 4,
//       child: TextFormField(
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Обязательно поле';
//             }
//           },
//           controller: nameController,
//           decoration: InputDecoration(labelText: 'Название карточки')),
//     );
//   }

//   // final _pageScrollController = ScrollController();
//   // final _listScrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AddingCardCubit, AddingCardState>(
//       listener: (context, state) {
//         if (state is AddingCardSuccess) {
//           context.goNamed('card',
//               pathParameters: {'cardId': card!.cid!}, extra: card);
//         }
//       },
//       child: SingleChildScrollView(
//         // controller: _pageScrollController,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             IconStepper(
//               // dotCount: 3,
//               // tappingEnabled: false,
//               stepReachedAnimationEffect: Curves.linear,
//               enableStepTapping: false,
//               enableNextPreviousButtons: false,
//               activeStepBorderWidth: 1.5,
//               lineColor: Theme.of(context).colorScheme.primary,
//               stepColor: Colors.transparent,
//               activeStepBorderColor: Theme.of(context).colorScheme.primary,
//               activeStepColor: Theme.of(context).colorScheme.tertiaryContainer,
//               icons: [
//                 Icon(
//                   EvaIcons.infoOutline,
//                   color: Theme.of(context).colorScheme.onTertiaryContainer,
//                 ),
//                 Icon(EvaIcons.pricetagsOutline,
//                     color: Theme.of(context).colorScheme.onTertiaryContainer),
//                 Icon(EvaIcons.menu2Outline,
//                     color: Theme.of(context).colorScheme.onTertiaryContainer),
//               ],
//               activeStep: activeStep,
//               // onStepReached: (index) {
//               //   setState(() {
//               //     activeStep = activeStep;
//               //   });
//               // },
//             ),
//             headerWrapper(),
//             if (activeStep == 0)
//               !ResponsiveBreakpoints.of(context).isMobile
//                   ? activeStepZeroDesktop()
//                   : activeStepZeroMobile(),
//             if (activeStep == 1) activeStepOne(),
//             if (activeStep == 2)
//               Column(
//                 children: [
//                   cardDescription(context),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       previousButton(),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       submitButton(),
//                     ],
//                   )
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget nextButton() {
//     return FilledButton(
//         onPressed: () {
//           if ((_formKey.currentState == null ||
//                   _formKey.currentState!.validate()) &&
//               pictures.isNotEmpty) {
//             if (activeStep < upperBound) {
//               setState(() {
//                 activeStep++;
//               });
//             }
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Далее'),
//         ));
//   }

//   Widget previousButton() {
//     return FilledButton(
//         onPressed: () {
//           if (activeStep > 0) {
//             setState(() {
//               activeStep--;
//             });
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Назад'),
//         ));
//   }

//   Widget headerWrapper() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child:
//           Text(headerText(), style: Theme.of(context).textTheme.headlineLarge),
//     );
//   }

//   String headerText() {
//     switch (activeStep) {
//       case 0:
//         return 'Основная информация';
//       case 1:
//         return 'Теги';
//       case 2:
//         return 'Описание';
//       default:
//         return '';
//     }
//   }
// }
