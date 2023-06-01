// import 'dart:developer';
// import 'package:cardswop/domain/models/card.dart';
// import 'package:context_menus/context_menus.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_downloader_web/image_downloader_web.dart';
// import 'package:responsive_framework/responsive_breakpoints.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class CardWidget extends StatelessWidget {
//   CardWidget({super.key, required this.card});

//   final SwopCard card;

//   final PageController controller = PageController();

//   Widget pictures(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (card.pictures.length > 1)
//           IconButton(
//               onPressed: () {
//                 controller.previousPage(
//                     duration: Duration(milliseconds: 150),
//                     curve: Curves.decelerate);
//               },
//               icon: Icon(EvaIcons.arrowLeft)),
//         Card(
//           child: Container(
//             height: ResponsiveBreakpoints.of(context).isDesktop ? 500 : 250,
//             width: ResponsiveBreakpoints.of(context).isDesktop ? 500 : 250,
//             alignment: Alignment.center,
//             child: ContextMenuRegion(
              // contextMenu: GenericContextMenu(buttonConfigs: [
              //   ContextMenuButtonConfig('Сохранить изображение',
              //       onPressed: () async {
              //     if (kIsWeb) {
              //       await WebImageDownloader.downloadImageFromWeb(
              //           card.pictures[controller.page! as int]);
              //     }
              //   })
//               ]),
//               child: PageView(
//                 controller: controller,
//                 children: [
//                   picture(card.pictures[0], context),
//                   if (card.pictures.length > 1)
//                     picture(card.pictures[1], context),
//                   if (card.pictures.length > 2)
//                     picture(card.pictures[2], context),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (card.pictures.length > 1)
//           IconButton(
//               onPressed: () {
//                 controller.nextPage(
//                     duration: Duration(milliseconds: 150),
//                     curve: Curves.decelerate);
//               },
//               icon: Icon(EvaIcons.arrowRight)),
//       ],
//     );
//   }

//   Widget picture(String url, BuildContext context) {
//     return SizedBox(
//       height: ResponsiveBreakpoints.of(context).isDesktop ? 500 : 250,
//       width: ResponsiveBreakpoints.of(context).isDesktop ? 500 : 250,
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         child: Image.network(
//           url,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }

//   Widget descsription(var contextMenu) {
//     return SelectionArea(
//       onSelectionChanged: (selection) {
//         if (selection == null) {
//           selectedText = null;
//         } else {
//           selectedText = selection.plainText;
//         }
//         // log(selection.toString());
//       },
//       child: ContextMenuRegion(
//         contextMenu: contextMenu,
//         child: SizedBox(
//           width: 300,
//           child: Text(card.description!),
//         ),
//       ),
//     );
//   }

//   Widget exchange(var contextMenu) {
//     return SelectionArea(
//       onSelectionChanged: (selection) {
//         if (selection == null) {
//           selectedText = null;
//         } else {
//           selectedText = selection.plainText;
//         }
//         // log(selection.toString());
//       },
//       child: ContextMenuRegion(
//         contextMenu: contextMenu,
//         child: SizedBox(
//           width: 300,
//           child: Text(card.exchangeValue),
//         ),
//       ),
//     );
//   }

//   Widget author(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         context.goNamed(
//           'user',
//           pathParameters: {'userId': '${card.username}_${card.userprefix}'},
//         );
//       },
//       child: Text(
//         '${card.username}#${card.userprefix}',
//         style: Theme.of(context).textTheme.labelSmall,
//       ),
//     );
//   }

//   var sel = TextEditingController();

//   // final ScrollController _scrollController = ScrollController();

//   String? selectedText;

//   @override
//   Widget build(BuildContext context) {
//     // if (_scrollController.hasClients) _scrollController.jumpTo(0);

    // var textContextMenu = GenericContextMenu(buttonConfigs: [
    //   ContextMenuButtonConfig('Копировать текст', onPressed: () {
    //     if (selectedText != null) {
    //       Clipboard.setData(ClipboardData(text: selectedText));
    //     }
    //     context.contextMenuOverlay.hide();
    //   })
    // ]);

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(8),
//       // controller: _scrollController,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           pictures(context),
//           SizedBox(
//             height: 8,
//           ),
//           if (card.pictures.length > 1)
//             SmoothPageIndicator(
//               onDotClicked: (index) {
//                 controller.animateToPage(index,
//                     duration: Duration(milliseconds: 150),
//                     curve: Curves.decelerate);
//               },
//               controller: controller,
//               count: card.pictures.length,
//               effect: ExpandingDotsEffect(
//                   activeDotColor: Theme.of(context).colorScheme.primary),
//             ),
//           if (card.pictures.length > 1) SizedBox(height: 8),
//           Text(
//             card.name,
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           author(context),
//           if (card.description != '')
//             Text(
//               'Описание',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//           if (card.description != '') descsription(textContextMenu),
//           SizedBox(height: 8),
//           // descsription(),
//           Text(
//             'Обмен на:',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           exchange(textContextMenu),
//           // exchange(),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
