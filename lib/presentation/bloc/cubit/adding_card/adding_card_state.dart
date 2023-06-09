part of 'adding_card_cubit.dart';

@immutable
abstract class AddingCardState {}

class AddingCardInitial extends AddingCardState {}

class AddingCardSuccess extends AddingCardState {
  final prisma.Card card;
  AddingCardSuccess({required this.card});
}

class AddingCardLoading extends AddingCardState {}

class AddingCardFailed extends AddingCardState {}
