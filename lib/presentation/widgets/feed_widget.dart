// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cardswop/domain/models/card.dart';
// import 'package:go_router/go_router.dart';
// import 'dart:developer';
// import 'package:responsive_framework/responsive_breakpoints.dart';
// import 'package:shimmer/shimmer.dart';

// class FeedTile extends StatelessWidget {
//   const FeedTile({
//     super.key,
//     required this.card,
//   });

//   final SwopCard card;

//   Widget cardnameBox() {
//     return Text(
//       card.name,
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//       style: TextStyle(fontWeight: FontWeight.bold),
//     );
//   }

//   // Widget usernameBox() {
//   //   return Container(
//   //     // width: 230,
//   //     child: OutlinedButton.icon(
//   //         onPressed: () {},
//   //         icon: const Icon(EvaIcons.personOutline),
//   //         label: Text(
//   //           userName,
//   //           maxLines: 1,
//   //           overflow: TextOverflow.ellipsis,
//   //         )),
//   //   );
//   // }

//   Widget tagWrapper(String tag, Color color, BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(2),
//       padding: const EdgeInsets.all(4),
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(40), color: color),
//       child: Text(
//         tag,
//         style: Theme.of(context).textTheme.bodySmall,
//       ),
//     );
//   }

//   Widget tags(BuildContext context) {
//     return OverflowBar(
//       overflowAlignment: OverflowBarAlignment.center,
//       children: [
//         if (card.limited == 0)
//           tagWrapper(
//               'Постоянная', Theme.of(context).colorScheme.surface, context),
//         if (card.limited == 1)
//           tagWrapper('Лимитная',
//               Theme.of(context).colorScheme.tertiaryContainer, context),
//         if (card.limited == 2)
//           tagWrapper('Особая', Theme.of(context).colorScheme.primaryContainer,
//               context),
//         // tagWrapper(
//         //     'Особая', Theme.of(context).colorScheme.surfaceVariant, context),
//       ],
//     );
//   }

//   Widget previewPicture(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         context.goNamed('card',
//             pathParameters: {'cardId': card.cid!}, extra: card);
//       },
//       child: Image.network(
//         card.pictures[0],
//         fit: BoxFit.fitHeight,
//       ),
//     );
//   }

//   // List<Widget> elements(BuildContext context) => [usernameBox(), previewPicture(context)];

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Theme.of(context).colorScheme.surface,
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 3,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             flex: 7,
//             child: previewPicture(context),
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               constraints: BoxConstraints.expand(),
//               padding: EdgeInsets.all(4),
//               // clipBehavior: Clip.antiAlias,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   cardnameBox(),
//                   tags(context),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomeWidget extends StatelessWidget {
//   HomeWidget({super.key});

//   // ScrollController scrollController = ScrollController();

//   List<SwopCard> getCardsFromSnapshot(
//       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//     List<SwopCard> cards = [];
//     if (!snapshot.hasData) {
//       return [];
//     }
//     for (var doc in snapshot.data!.docs) {
//       if (doc.exists) {
//         cards.add(SwopCard.fromSnapshot(doc));
//       }
//     }
//     return cards;
//     // setState(() {});
//   }

//   Future<QuerySnapshot<Map<String, dynamic>>> getSnapshotByDate() async {
//     return FirebaseFirestore.instance
//         .collection('cards')
//         .orderBy('date', descending: true)
//         .limit(20)
//         .get();
//   }

//   Future<QuerySnapshot<Map<String, dynamic>>> getSnapshotOnlyLimited() async {
//     try {
//       var tmp = FirebaseFirestore.instance
//           .collection('cards')
//           .orderBy('date', descending: true)
//           .where('limited', isEqualTo: 1)
//           .limit(20)
//           .get();
//       return tmp;
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   Future<QuerySnapshot<Map<String, dynamic>>> getSnapshotOnlyRegular() async {
//     try {
//       var tmp = FirebaseFirestore.instance
//           .collection('cards')
//           .where('limited', isEqualTo: 0)
//           .orderBy('date', descending: true)
//           .limit(20)
//           .get();
//       return tmp;
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   Widget loadingFeed(BuildContext context) {
//     return Padding(
//       padding: ResponsiveBreakpoints.of(context).isDesktop
//           ? EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width / 13)
//           : EdgeInsets.zero,
//       child: GridView.builder(
//         // controller: scrollController,
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: 20,
//         gridDelegate: ResponsiveBreakpoints.of(context).isDesktop
//             ? const SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: 3 / 4,
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 5,
//                 crossAxisSpacing: 8)
//             : (ResponsiveBreakpoints.of(context).isTablet)
//                 ? const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 9 / 16,
//                     crossAxisCount: 4,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8)
//                 : const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 2.5 / 4,
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8),
//         itemBuilder: (context, index) {
//           return Card(
//             color: Theme.of(context).colorScheme.surface,
//             clipBehavior: Clip.antiAlias,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             elevation: 3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                   flex: 7,
//                   child: Shimmer.fromColors(
//                     baseColor: Theme.of(context).colorScheme.primaryContainer,
//                     highlightColor:
//                         Theme.of(context).colorScheme.tertiaryContainer,
//                     child: const SizedBox(),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     constraints: const BoxConstraints.expand(),
//                     padding: const EdgeInsets.all(4),
//                     // clipBehavior: Clip.antiAlias,
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         Shimmer.fromColors(
//                           baseColor:
//                               Theme.of(context).colorScheme.primaryContainer,
//                           highlightColor:
//                               Theme.of(context).colorScheme.tertiaryContainer,
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: Colors.white),
//                             child: const Text(
//                               'name name name',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                         Shimmer.fromColors(
//                           baseColor:
//                               Theme.of(context).colorScheme.primaryContainer,
//                           highlightColor:
//                               Theme.of(context).colorScheme.tertiaryContainer,
//                           child: Container(
//                             margin: const EdgeInsets.all(2),
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: Colors.white),
//                             child: Text(
//                               'adasasdasd',
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget feedWith(List<SwopCard> cards, BuildContext context) {
//     return Padding(
//       padding: ResponsiveBreakpoints.of(context).isDesktop
//           ? EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width / 13)
//           : EdgeInsets.zero,
//       child: GridView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         // controller: scrollController,
//         shrinkWrap: true,
//         itemCount: cards.length,
//         gridDelegate: ResponsiveBreakpoints.of(context).isDesktop
//             ? const SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: 3 / 4,
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 5,
//                 crossAxisSpacing: 8)
//             : (ResponsiveBreakpoints.of(context).isTablet)
//                 ? const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 9 / 16,
//                     crossAxisCount: 4,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8)
//                 : const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 2.5 / 4,
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8),
//         itemBuilder: (context, index) {
//           return FeedTile(
//             card: cards[index],
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       // controller: scrollController,
//       padding: EdgeInsets.all(8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Последние свопки',
//             style: Theme.of(context).textTheme.headlineLarge,
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           FutureBuilder(
//             future: getSnapshotByDate(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return loadingFeed(context);
//               }

//               return feedWith(getCardsFromSnapshot(snapshot), context
//                   // scrollController: scrollController,

//                   );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
